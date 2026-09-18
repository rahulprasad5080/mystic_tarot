import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/subscription_plan.dart';

/// Firebase Firestore Database Service for Payment Transactions & Subscription Management.
class FirestorePaymentService {
  final FirebaseFirestore _db;

  FirestorePaymentService({FirebaseFirestore? db})
      : _db = db ?? FirebaseFirestore.instance;

  /// Record payment transaction details securely in Firestore under `users/{userId}/payments/{paymentId}`.
  Future<void> recordPaymentTransaction({
    required String userId,
    required SubscriptionPlan plan,
    required String paymentGateway,
    required String paymentId,
    String? orderId,
    String? signature,
    String? purchaseToken,
    required double amount,
    required String currency,
  }) async {
    try {
      final paymentRef = _db
          .collection('users')
          .doc(userId)
          .collection('payments')
          .doc(paymentId.isNotEmpty ? paymentId : DateTime.now().millisecondsSinceEpoch.toString());

      await paymentRef.set({
        'paymentId': paymentId,
        'orderId': orderId ?? '',
        'signature': signature ?? '',
        'purchaseToken': purchaseToken ?? '',
        'paymentGateway': paymentGateway,
        'planId': plan.id,
        'planTitle': plan.title,
        'amount': amount,
        'currency': currency,
        'status': 'verified',
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Calculate subscription end date based on plan months
      final startDate = DateTime.now();
      final endDate = DateTime(
        startDate.year,
        startDate.month + plan.months,
        startDate.day,
      );

      // Update main user profile document in Firestore
      final userRef = _db.collection('users').doc(userId);
      await userRef.set({
        'isSubscribed': true,
        'activePlanId': plan.id,
        'activePlanTitle': plan.title,
        'subscriptionStartDate': Timestamp.fromDate(startDate),
        'subscriptionEndDate': Timestamp.fromDate(endDate),
        'paymentGateway': paymentGateway,
        'lastPaymentId': paymentId,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      debugPrint('Firestore Payment Transaction recorded successfully for user $userId');
    } catch (e) {
      debugPrint('Error recording payment transaction in Firestore: $e');
      rethrow;
    }
  }

  /// Listen to user subscription status in real-time from Firestore DB.
  Stream<DocumentSnapshot<Map<String, dynamic>>> streamUserSubscription(String userId) {
    return _db.collection('users').doc(userId).snapshots();
  }

  /// Get user subscription status directly from Firestore.
  Future<Map<String, dynamic>?> getUserSubscription(String userId) async {
    try {
      final doc = await _db.collection('users').doc(userId).get();
      return doc.data();
    } catch (e) {
      debugPrint('Error fetching user subscription from Firestore: $e');
      return null;
    }
  }
}
