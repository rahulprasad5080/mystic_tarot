import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/models/subscription_plan.dart';

class SubscriptionState {
  final bool isSubscribed;
  final String? activePlanId;

  const SubscriptionState({
    required this.isSubscribed,
    this.activePlanId,
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

class SubscriptionNotifier extends StateNotifier<SubscriptionState> {
  SubscriptionNotifier() : super(const SubscriptionState(isSubscribed: false)) {
    _loadSubscriptionStatus();
  }

  Future<void> _loadSubscriptionStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final isSub = prefs.getBool('is_subscribed') ?? false;
    final planId = prefs.getString('active_plan_id');
    state = SubscriptionState(isSubscribed: isSub, activePlanId: planId);
  }

  Future<void> activateSubscription(String planId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_subscribed', true);
    await prefs.setString('active_plan_id', planId);
    await prefs.setString('subscription_date', DateTime.now().toIso8601String());
    state = SubscriptionState(isSubscribed: true, activePlanId: planId);
  }

  Future<void> cancelSubscription() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_subscribed', false);
    await prefs.remove('active_plan_id');
    state = const SubscriptionState(isSubscribed: false);
  }
}
