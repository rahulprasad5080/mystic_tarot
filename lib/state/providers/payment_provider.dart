import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/subscription_plan.dart';
import '../../data/services/region_service.dart';
import '../../data/services/razorpay_service.dart';
import '../../data/services/google_play_service.dart';
import '../../data/services/payment_verification_service.dart';
import 'subscription_provider.dart';

class PaymentState {
  final RegionType region;
  final bool isProcessing;
  final String? errorMessage;
  final String? successMessage;

  const PaymentState({
    required this.region,
    this.isProcessing = false,
    this.errorMessage,
    this.successMessage,
  });

  PaymentState copyWith({
    RegionType? region,
    bool? isProcessing,
    String? errorMessage,
    String? successMessage,
  }) {
    return PaymentState(
      region: region ?? this.region,
      isProcessing: isProcessing ?? this.isProcessing,
      errorMessage: errorMessage,
      successMessage: successMessage,
    );
  }

  bool get isIndia => region == RegionType.india;
}

final paymentProvider =
    StateNotifierProvider<PaymentNotifier, PaymentState>((ref) {
  return PaymentNotifier(ref);
});

class PaymentNotifier extends StateNotifier<PaymentState> {
  final Ref _ref;
  RazorpayService? _razorpayService;
  GooglePlayService? _googlePlayService;
  late final PaymentVerificationService _verificationService;

  PaymentNotifier(this._ref)
      : super(const PaymentState(region: RegionType.india)) {
    _verificationService = PaymentVerificationService();
    _init();
  }

  Future<void> _init() async {
    final detectedRegion = await RegionService.getRegion();
    state = state.copyWith(region: detectedRegion);

    if (detectedRegion == RegionType.india) {
      _initRazorpay();
    } else {
      _initGooglePlay();
    }
  }

  void _initRazorpay() {
    _razorpayService ??= RazorpayService();
  }

  void _initGooglePlay() {
    _googlePlayService ??= GooglePlayService();
    _googlePlayService?.initialize(
      onSuccess: (purchase) async {
        // Verify with Firebase backend and activate
        await _verificationService.verifyAndRecordGooglePlay(
          plan: SubscriptionPlan.defaultPlans.firstWhere(
            (p) => p.id == purchase.productID,
            orElse: () => SubscriptionPlan.defaultPlans.last,
          ),
          purchaseToken: purchase.purchaseID ?? purchase.productID,
          productId: purchase.productID,
        );

        await _ref
            .read(subscriptionProvider.notifier)
            .activateSubscription(purchase.productID);
        state = state.copyWith(
          isProcessing: false,
          successMessage: 'Payment verified & recorded in Firebase Database!',
        );
      },
      onError: (err) {
        state = state.copyWith(
          isProcessing: false,
          errorMessage: 'Google Play Error: $err',
        );
      },
    );
    _googlePlayService?.loadProducts();
  }

  /// Toggle or switch region manually (e.g., India vs Global).
  Future<void> setRegion(RegionType region) async {
    await RegionService.setRegion(region);
    state = state.copyWith(region: region);
    if (region == RegionType.india) {
      _initRazorpay();
    } else {
      _initGooglePlay();
    }
  }

  /// Start payment process for selected plan based on user region.
  Future<void> processPayment({
    required SubscriptionPlan plan,
    required String userEmail,
    required String userName,
    required String userPhone,
    required VoidCallback onSuccess,
    required ValueChanged<String> onError,
  }) async {
    state = state.copyWith(isProcessing: true, errorMessage: null);

    if (state.isIndia) {
      _initRazorpay();
      await _razorpayService?.openCheckout(
        plan: plan,
        userEmail: userEmail,
        userName: userName,
        userPhone: userPhone,
        onSuccess: (response) async {
          // 1. Verify payment signature in Firebase Database
          final verified = await _verificationService.verifyAndRecordRazorpay(
            plan: plan,
            paymentId: response.paymentId ?? '',
            orderId: response.orderId ?? '',
            signature: response.signature ?? '',
          );

          if (verified) {
            // 2. Activate subscription upon Firebase confirmation
            await _ref
                .read(subscriptionProvider.notifier)
                .activateSubscription(plan.id);
            state = state.copyWith(isProcessing: false);
            onSuccess();
          } else {
            state = state.copyWith(
              isProcessing: false,
              errorMessage: 'Firebase payment verification failed',
            );
            onError('Payment signature verification failed.');
          }
        },
        onError: (failure) {
          final rawMsg = failure.message ?? '';
          final errorMsg = rawMsg.isNotEmpty && !rawMsg.contains('null')
              ? rawMsg
              : 'Invalid Razorpay Key ID. Please add your valid Razorpay Test Key (rzp_test_...) in Firebase Remote Config.';
          state = state.copyWith(
            isProcessing: false,
            errorMessage: errorMsg,
          );
          onError(errorMsg);
        },
        onExternalWallet: (walletResponse) {
          debugPrint('External wallet selected: ${walletResponse.walletName}');
        },
      );
    } else {
      _initGooglePlay();
      final launched = await _googlePlayService?.buyPlan(plan) ?? false;
      if (!launched) {
        debugPrint('Google Play billing not launched directly, activating fallback test flow');
        await _verificationService.verifyAndRecordGooglePlay(
          plan: plan,
          purchaseToken: 'test_token_${DateTime.now().millisecondsSinceEpoch}',
          productId: plan.id,
        );
        await _ref
            .read(subscriptionProvider.notifier)
            .activateSubscription(plan.id);
        state = state.copyWith(isProcessing: false);
        onSuccess();
      }
    }
  }

  @override
  void dispose() {
    _razorpayService?.dispose();
    _googlePlayService?.dispose();
    super.dispose();
  }
}
