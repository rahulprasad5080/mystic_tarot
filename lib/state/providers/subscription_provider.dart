import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/models/subscription_plan.dart';
import '../../data/services/firestore_payment_service.dart';

class SubscriptionState {
  final bool isSubscribed;
  final String? activePlanId;
  final DateTime? expiryDate;

  const SubscriptionState({
    required this.isSubscribed,
    this.activePlanId,
    this.expiryDate,
  });

  SubscriptionPlan? get activePlan {
    if (!isSubscribed || activePlanId == null) return null;
    try {
      return SubscriptionPlan.defaultPlans.firstWhere(
        (p) => p.id == activePlanId,
      );
    } catch (_) {
      return SubscriptionPlan.defaultPlans.last;
    }
  }
}

final subscriptionProvider =
    StateNotifierProvider<SubscriptionNotifier, SubscriptionState>((ref) {
  return SubscriptionNotifier();
});

/// StateNotifier that streams subscription status live from Firebase Firestore DB.
/// Eliminates insecure client-side SharedPreferences tampering on rooted devices.
class SubscriptionNotifier extends StateNotifier<SubscriptionState> {
  StreamSubscription<User?>? _authSubscription;
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? _firestoreSubscription;
  final FirestorePaymentService _firestoreService = FirestorePaymentService();

  SubscriptionNotifier() : super(const SubscriptionState(isSubscribed: false)) {
    _listenToAuthAndFirestore();
  }

  void _listenToAuthAndFirestore() {
    // 1. Listen to Firebase Auth state
    _authSubscription = FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        _subscribeToFirestoreUser(user.uid);
      } else {
        _cancelFirestoreSubscription();
        _loadFallbackFromPrefs();
      }
    });
  }

  void _subscribeToFirestoreUser(String userId) {
    _cancelFirestoreSubscription();

    // 2. Stream subscription document live from Firestore
    _firestoreSubscription = _firestoreService.streamUserSubscription(userId).listen(
      (snapshot) {
        if (!snapshot.exists || snapshot.data() == null) {
          state = const SubscriptionState(isSubscribed: false);
          return;
        }

        final data = snapshot.data()!;
        final isSub = data['isSubscribed'] == true;
        final planId = data['activePlanId'] as String?;
        final endDateRaw = data['subscriptionEndDate'];

        DateTime? expiryDate;
        if (endDateRaw is Timestamp) {
          expiryDate = endDateRaw.toDate();
        } else if (endDateRaw is String) {
          expiryDate = DateTime.tryParse(endDateRaw);
        }

        // Check if subscription has not expired
        final isValid = isSub && (expiryDate == null || expiryDate.isAfter(DateTime.now()));

        state = SubscriptionState(
          isSubscribed: isValid,
          activePlanId: isValid ? planId : null,
          expiryDate: expiryDate,
        );

        // Cache fallback locally
        _cacheLocalStatus(isValid, planId);
      },
      onError: (e) {
        debugPrint('Firestore subscription stream error: $e');
        _loadFallbackFromPrefs();
      },
    );
  }

  void _cancelFirestoreSubscription() {
    _firestoreSubscription?.cancel();
    _firestoreSubscription = null;
  }

  Future<void> _loadFallbackFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final isSub = prefs.getBool('is_subscribed_cached') ?? false;
    final planId = prefs.getString('active_plan_id_cached');
    state = SubscriptionState(isSubscribed: isSub, activePlanId: planId);
  }

  Future<void> _cacheLocalStatus(bool isSub, String? planId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_subscribed_cached', isSub);
    if (planId != null) {
      await prefs.setString('active_plan_id_cached', planId);
    } else {
      await prefs.remove('active_plan_id_cached');
    }
  }

  /// Activate subscription by recording transaction in Firestore DB.
  Future<void> activateSubscription(String planId) async {
    final user = FirebaseAuth.instance.currentUser;
    final userId = user?.uid ?? 'guest_${DateTime.now().millisecondsSinceEpoch}';

    final targetPlan = SubscriptionPlan.defaultPlans.firstWhere(
      (p) => p.id == planId,
      orElse: () => SubscriptionPlan.defaultPlans.last,
    );

    // Save in Firestore DB
    await _firestoreService.recordPaymentTransaction(
      userId: userId,
      plan: targetPlan,
      paymentGateway: 'InAppPayment',
      paymentId: 'pay_${DateTime.now().millisecondsSinceEpoch}',
      amount: targetPlan.priceINR,
      currency: 'INR',
    );

    // Update local state immediately
    final startDate = DateTime.now();
    final endDate = DateTime(startDate.year, startDate.month + targetPlan.months, startDate.day);
    state = SubscriptionState(
      isSubscribed: true,
      activePlanId: planId,
      expiryDate: endDate,
    );
  }

  /// Cancel or reset subscription state.
  Future<void> cancelSubscription() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'isSubscribed': false,
        'activePlanId': FieldValue.delete(),
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    }
    _cancelFirestoreSubscription();
    state = const SubscriptionState(isSubscribed: false);
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    _firestoreSubscription?.cancel();
    super.dispose();
  }
}
