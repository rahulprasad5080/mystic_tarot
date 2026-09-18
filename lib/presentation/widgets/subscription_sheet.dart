import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/subscription_plan.dart';
import '../../data/services/region_service.dart';
import '../../state/providers/auth_provider.dart';
import '../../state/providers/payment_provider.dart';
import '../../state/providers/subscription_provider.dart';

class SubscriptionSheet extends ConsumerStatefulWidget {
  const SubscriptionSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const SubscriptionSheet(),
    );
  }

  @override
  ConsumerState<SubscriptionSheet> createState() => _SubscriptionSheetState();
}

class _SubscriptionSheetState extends ConsumerState<SubscriptionSheet> {
  String _selectedPlanId = 'plan_12_month';

  @override
  Widget build(BuildContext context) {
    final isSubscribed = ref.watch(subscriptionProvider).isSubscribed;
    final paymentState = ref.watch(paymentProvider);
    final paymentNotifier = ref.read(paymentProvider.notifier);
    final currentUser = ref.watch(currentUserProvider);

    final plans = SubscriptionPlan.defaultPlans;
    final selectedPlan = plans.firstWhere(
      (p) => p.id == _selectedPlanId,
      orElse: () => plans.last,
    );

    final isIndia = paymentState.isIndia;
    final displayPrice = isIndia ? selectedPlan.formattedPriceINR : selectedPlan.formattedPriceUSD;

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFF8FAFC),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.only(
        top: 12,
        left: 20,
        right: 20,
        bottom: 28,
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Bottom sheet drag handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFCBD5E1),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 18),

              // Crown Header Icon
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [Color(0xFF38BDF8), Color(0xFF006D85)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF38BDF8).withValues(alpha: 0.35),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.workspace_premium_rounded,
                  color: Colors.white,
                  size: 34,
                ),
              ),
              const SizedBox(height: 12),

              const Text(
                'Celestial Membership',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Unlock unlimited AI Tarot readings & ad-free cosmic guidance',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF64748B),
                ),
              ),
              const SizedBox(height: 14),

              // Region & Gateway Indicator Badge Bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFFBFDBFE),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Text(
                      isIndia ? '🇮🇳 India Region' : '🌐 Global Region',
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1E40AF),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDBEAFE),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        isIndia ? 'Razorpay (UPI / Cards)' : 'Google Play Billing',
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1D4ED8),
                        ),
                      ),
                    ),
                    const Spacer(),
                    // Region toggle switch button
                    InkWell(
                      onTap: () {
                        paymentNotifier.setRegion(
                          isIndia ? RegionType.global : RegionType.india,
                        );
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.swap_horiz_rounded,
                            size: 16,
                            color: const Color(0xFF2563EB),
                          ),
                          const SizedBox(width: 2),
                          Text(
                            isIndia ? 'Switch to USD' : 'Switch to INR',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF2563EB),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Feature Highlights List
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFFE2E8F0),
                    width: 1,
                  ),
                ),
                child: const Column(
                  children: [
                    _FeatureRow(
                      icon: Icons.auto_awesome,
                      text: 'Ask up to 10 AI Oracle questions daily',
                    ),
                    SizedBox(height: 10),
                    _FeatureRow(
                      icon: Icons.text_fields_rounded,
                      text: 'Unlimited prompt character length',
                    ),
                    SizedBox(height: 10),
                    _FeatureRow(
                      icon: Icons.block_rounded,
                      text: '100% Ad-Free experience across all readings',
                    ),
                    SizedBox(height: 10),
                    _FeatureRow(
                      icon: Icons.bolt_rounded,
                      text: 'Priority AI generation speed & deep insights',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Subscription Plan Options Grid / List
              Column(
                children: plans.map((plan) {
                  final isSelected = plan.id == _selectedPlanId;
                  final isBestValue = plan.id == 'plan_12_month';
                  final planPriceText = isIndia ? plan.formattedPriceINR : plan.formattedPriceUSD;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedPlanId = plan.id;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFFF0F9FF) : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFF006D85)
                              : const Color(0xFFE2E8F0),
                          width: isSelected ? 2 : 1,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: const Color(0xFF006D85).withValues(alpha: 0.1),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            isSelected
                                ? Icons.radio_button_checked_rounded
                                : Icons.radio_button_off_rounded,
                            color: isSelected
                                ? const Color(0xFF006D85)
                                : const Color(0xFF94A3B8),
                            size: 22,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  spacing: 6,
                                  runSpacing: 4,
                                  children: [
                                    Text(
                                      plan.title,
                                      style: TextStyle(
                                        fontSize: 14.5,
                                        fontWeight: FontWeight.bold,
                                        color: isSelected
                                            ? const Color(0xFF006D85)
                                            : const Color(0xFF0F172A),
                                      ),
                                    ),
                                    if (isBestValue)
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 6,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF006D85),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: const Text(
                                          'BEST VALUE',
                                          style: TextStyle(
                                            fontSize: 8.5,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${plan.durationText} access',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF64748B),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                planPriceText,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF006D85),
                                ),
                              ),
                              Text(
                                isIndia ? 'Razorpay Payment' : 'Google Play Billing',
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Color(0xFF94A3B8),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

              // Action Button (Subscribe or Manage)
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: paymentState.isProcessing
                      ? null
                      : () async {
                          final nav = Navigator.of(context);
                          final messenger = ScaffoldMessenger.of(context);

                          final userEmail = currentUser?.email ?? '';
                          final userName = currentUser?.displayName ?? 'Seeker';
                          final userPhone = '';

                          await paymentNotifier.processPayment(
                            plan: selectedPlan,
                            userEmail: userEmail,
                            userName: userName,
                            userPhone: userPhone,
                            onSuccess: () {
                              if (!mounted) return;
                              nav.pop();
                              messenger.showSnackBar(
                                SnackBar(
                                  content: Row(
                                    children: [
                                      const Icon(Icons.stars_rounded, color: Colors.amberAccent),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          '✨ Celestial Membership Activated (${selectedPlan.durationText})! Enjoy 10 daily AI questions!',
                                        ),
                                      ),
                                    ],
                                  ),
                                  backgroundColor: const Color(0xFF006D85),
                                  duration: const Duration(seconds: 4),
                                ),
                              );
                            },
                            onError: (errMsg) {
                              if (!mounted) return;
                              messenger.showSnackBar(
                                SnackBar(
                                  content: Text('Payment Error: $errMsg'),
                                  backgroundColor: Colors.redAccent,
                                ),
                              );
                            },
                          );
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF006D85),
                    foregroundColor: Colors.white,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: paymentState.isProcessing
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          isSubscribed
                              ? 'Switch to ${selectedPlan.title}'
                              : isIndia
                                  ? 'Pay via Razorpay — $displayPrice'
                                  : 'Pay via Google Play — $displayPrice',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 12),

              // Security & Payment Gateways Note
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.lock_outline_rounded, size: 13, color: Color(0xFF94A3B8)),
                  const SizedBox(width: 4),
                  Text(
                    isIndia
                        ? 'Secured by Razorpay UPI, NetBanking & Cards'
                        : 'Secured by Google Play Store Payments',
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF94A3B8),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _FeatureRow({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFFE0F2FE),
          ),
          child: Icon(
            icon,
            size: 16,
            color: const Color(0xFF006D85),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Color(0xFF334155),
            ),
          ),
        ),
      ],
    );
  }
}
