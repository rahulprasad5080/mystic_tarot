class SubscriptionPlan {
  final String id;
  final String title;
  final String durationText;
  final int months;
  final double priceINR;
  final double priceUSD;
  final String formattedPriceINR;
  final String formattedPriceUSD;
  final String paymentGatewayIndia;
  final String paymentGatewayGlobal;

  const SubscriptionPlan({
    required this.id,
    required this.title,
    required this.durationText,
    required this.months,
    required this.priceINR,
    required this.priceUSD,
    required this.formattedPriceINR,
    required this.formattedPriceUSD,
    this.paymentGatewayIndia = 'Razorpay UPI',
    this.paymentGatewayGlobal = 'Google Play Payments',
  });

  static const List<SubscriptionPlan> defaultPlans = [
    SubscriptionPlan(
      id: 'plan_1_month',
      title: '1 Month Pass',
      durationText: '1 Month',
      months: 1,
      priceINR: 30.0,
      priceUSD: 1.19,
      formattedPriceINR: '₹30',
      formattedPriceUSD: '\$1.19',
    ),
    SubscriptionPlan(
      id: 'plan_3_month',
      title: '3 Months Pass',
      durationText: '3 Months',
      months: 3,
      priceINR: 79.0,
      priceUSD: 3.49,
      formattedPriceINR: '₹79',
      formattedPriceUSD: '\$3.49',
    ),
    SubscriptionPlan(
      id: 'plan_6_month',
      title: '6 Months Pass',
      durationText: '6 Months',
      months: 6,
      priceINR: 149.0,
      priceUSD: 6.99,
      formattedPriceINR: '₹149',
      formattedPriceUSD: '\$6.99',
    ),
    SubscriptionPlan(
      id: 'plan_12_month',
      title: '1 Year Pass',
      durationText: '1 Year',
      months: 12,
      priceINR: 299.0,
      priceUSD: 13.99,
      formattedPriceINR: '₹299',
      formattedPriceUSD: '\$13.99',
    ),
  ];
}
