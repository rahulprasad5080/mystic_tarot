import 'package:flutter/foundation.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../models/subscription_plan.dart';
import 'remote_config_service.dart';

typedef PaymentSuccessCallback = void Function(PaymentSuccessResponse response);
typedef PaymentErrorCallback = void Function(PaymentFailureResponse response);
typedef ExternalWalletCallback = void Function(ExternalWalletResponse response);

/// Handles Razorpay SDK integration for Indian users (UPI, NetBanking, Cards, Paytm, GPay).
class RazorpayService {
  late Razorpay _razorpay;
  PaymentSuccessCallback? _onSuccess;
  PaymentErrorCallback? _onError;
  ExternalWalletCallback? _onExternalWallet;

  RazorpayService() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void dispose() {
    _razorpay.clear();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    debugPrint('Razorpay Payment Success: ${response.paymentId}');
    _onSuccess?.call(response);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    debugPrint('Razorpay Payment Error: ${response.code} - ${response.message}');
    _onError?.call(response);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    debugPrint('Razorpay External Wallet: ${response.walletName}');
    _onExternalWallet?.call(response);
  }

  /// Launch Razorpay payment sheet for a given subscription plan.
  Future<void> openCheckout({
    required SubscriptionPlan plan,
    required String userEmail,
    required String userName,
    required String userPhone,
    required PaymentSuccessCallback onSuccess,
    required PaymentErrorCallback onError,
    ExternalWalletCallback? onExternalWallet,
  }) async {
    _onSuccess = onSuccess;
    _onError = onError;
    _onExternalWallet = onExternalWallet;

    final keyId = RemoteConfigService.razorpayKeyId;
    final amountInPaise = (plan.priceINR * 100).toInt();

    final options = {
      'key': keyId,
      'amount': amountInPaise,
      'name': 'Ably Tarot Card Reading',
      'description': '${plan.title} - ${plan.durationText} Celestial Membership',
      'currency': 'INR',
      'prefill': {
        'contact': userPhone.isNotEmpty ? userPhone : '9876543210',
        'email': userEmail.isNotEmpty ? userEmail : 'seeker@ablytarot.com',
        'name': userName.isNotEmpty ? userName : 'Seeker',
      },
      'theme': {
        'color': '#006D85',
      },
      'external': {
        'wallets': ['paytm', 'phonepe', 'gpay']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error opening Razorpay checkout: $e');
      onError(PaymentFailureResponse(
        Razorpay.UNKNOWN_ERROR,
        'Failed to launch Razorpay gateway: $e',
        null,
      ));
    }
  }
}
