import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import '../models/subscription_plan.dart';

typedef InAppPurchaseSuccessCallback = void Function(PurchaseDetails purchase);
typedef InAppPurchaseErrorCallback = void Function(String error);

/// Service wrapper for Google Play Billing (In-App Purchases / Subscriptions) for global users.
class GooglePlayService {
  final InAppPurchase _iap = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _subscription;
  InAppPurchaseSuccessCallback? _onSuccess;
  InAppPurchaseErrorCallback? _onError;
  List<ProductDetails> _products = [];

  List<ProductDetails> get products => _products;

  void initialize({
    required InAppPurchaseSuccessCallback onSuccess,
    required InAppPurchaseErrorCallback onError,
  }) {
    _onSuccess = onSuccess;
    _onError = onError;

    _subscription = _iap.purchaseStream.listen(
      _onPurchaseUpdated,
      onDone: () => _subscription?.cancel(),
      onError: (error) {
        debugPrint('Google Play Billing Stream Error: $error');
        _onError?.call(error.toString());
      },
    );
  }

  void dispose() {
    _subscription?.cancel();
  }

  /// Load available products from Google Play Console store.
  Future<bool> loadProducts() async {
    final bool available = await _iap.isAvailable();
    if (!available) {
      debugPrint('Google Play Billing is not available on this device');
      return false;
    }

    final Set<String> ids = SubscriptionPlan.defaultPlans.map((p) => p.id).toSet();
    final ProductDetailsResponse response = await _iap.queryProductDetails(ids);

    if (response.error != null) {
      debugPrint('Error querying products: ${response.error!.message}');
      return false;
    }

    _products = response.productDetails;
    return true;
  }

  /// Purchase a subscription plan via Google Play Billing.
  Future<bool> buyPlan(SubscriptionPlan plan) async {
    final bool available = await _iap.isAvailable();
    if (!available) {
      _onError?.call('Google Play Store is not available on this device.');
      return false;
    }

    ProductDetails? targetProduct;
    try {
      targetProduct = _products.firstWhere((p) => p.id == plan.id);
    } catch (_) {
      targetProduct = null;
    }

    final PurchaseParam purchaseParam = targetProduct != null
        ? PurchaseParam(productDetails: targetProduct)
        : PurchaseParam(
            productDetails: ProductDetails(
              id: plan.id,
              title: plan.title,
              description: '${plan.durationText} Celestial Membership',
              price: '\$${plan.priceUSD.toStringAsFixed(2)}',
              rawPrice: plan.priceUSD,
              currencyCode: 'USD',
            ),
          );

    try {
      return await _iap.buyNonConsumable(purchaseParam: purchaseParam);
    } catch (e) {
      debugPrint('Error initiating Google Play purchase: $e');
      _onError?.call(e.toString());
      return false;
    }
  }

  void _onPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    for (final PurchaseDetails purchase in purchaseDetailsList) {
      if (purchase.status == PurchaseStatus.pending) {
        debugPrint('Google Play purchase pending: ${purchase.productID}');
      } else if (purchase.status == PurchaseStatus.error) {
        debugPrint('Google Play purchase error: ${purchase.error}');
        _onError?.call(purchase.error?.message ?? 'Purchase failed');
      } else if (purchase.status == PurchaseStatus.purchased ||
          purchase.status == PurchaseStatus.restored) {
        debugPrint('Google Play purchase success: ${purchase.productID}');
        if (purchase.pendingCompletePurchase) {
          _iap.completePurchase(purchase);
        }
        _onSuccess?.call(purchase);
      }
    }
  }
}
