import 'package:adapty_flutter/adapty_flutter.dart';
import 'package:flutter/material.dart';

class PaywallAdapty extends StatefulWidget {
  const PaywallAdapty({super.key});

  @override
  State<PaywallAdapty> createState() => _PaywallAdaptyState();
}

class _PaywallAdaptyState extends State<PaywallAdapty>
    implements AdaptyUIPaywallsEventsObserver {
  @override
  void initState() {
    super.initState();
    // Register this class as the paywalls event observer
    AdaptyUI().setPaywallsEventsObserver(this);
    //_showPaywallIfNeeded();
  }

  Future<void> _showPaywallIfNeeded() async {
    try {
      final paywall = await Adapty().getPaywall(
        placementId: 'donation_buy_me_a_coffee',
      );

      if (!paywall.hasViewConfiguration) return;

      final view = await AdaptyUI().createPaywallView(paywall: paywall);

      await view.present();
    } catch (_) {
      // Handle any errors (network, SDK issues, etc.)
    }
  }

  // This method is called when user performs an action on the paywall UI
  @override
  void paywallViewDidPerformAction(
    AdaptyUIPaywallView view,
    AdaptyUIAction action,
  ) {
    switch (action) {
      case const CloseAction():
      case const AndroidSystemBackAction():
        view.dismiss();
        break;
      case CloseAction():
        // TODO: Handle this case.
        throw UnimplementedError();
      case CustomAction():
        // TODO: Handle this case.
        throw UnimplementedError();
      case AndroidSystemBackAction():
        // TODO: Handle this case.
        throw UnimplementedError();
      case OpenUrlAction():
        // TODO: Handle this case.
        throw UnimplementedError();
    }
  }

  @override
  void paywallViewDidAppear(AdaptyUIPaywallView view) {
    // TODO: implement paywallViewDidAppear
  }

  @override
  void paywallViewDidDisappear(AdaptyUIPaywallView view) {
    // TODO: implement paywallViewDidDisappear
  }

  @override
  void paywallViewDidFailLoadingProducts(
    AdaptyUIPaywallView view,
    AdaptyError error,
  ) {
    // TODO: implement paywallViewDidFailLoadingProducts
  }

  @override
  void paywallViewDidFailPurchase(
    AdaptyUIPaywallView view,
    AdaptyPaywallProduct product,
    AdaptyError error,
  ) {
    // TODO: implement paywallViewDidFailPurchase
  }

  @override
  void paywallViewDidFailRendering(
    AdaptyUIPaywallView view,
    AdaptyError error,
  ) {
    // TODO: implement paywallViewDidFailRendering
  }

  @override
  void paywallViewDidFailRestore(AdaptyUIPaywallView view, AdaptyError error) {
    // TODO: implement paywallViewDidFailRestore
  }

  @override
  void paywallViewDidFinishPurchase(
    AdaptyUIPaywallView view,
    AdaptyPaywallProduct product,
    AdaptyPurchaseResult purchaseResult,
  ) {
    // TODO: implement paywallViewDidFinishPurchase
  }

  @override
  void paywallViewDidFinishRestore(
    AdaptyUIPaywallView view,
    AdaptyProfile profile,
  ) {
    // TODO: implement paywallViewDidFinishRestore
  }

  @override
  void paywallViewDidFinishWebPaymentNavigation(
    AdaptyUIPaywallView view,
    AdaptyPaywallProduct? product,
    AdaptyError? error,
  ) {
    // TODO: implement paywallViewDidFinishWebPaymentNavigation
  }

  @override
  void paywallViewDidSelectProduct(AdaptyUIPaywallView view, String productId) {
    // TODO: implement paywallViewDidSelectProduct
  }

  @override
  void paywallViewDidStartPurchase(
    AdaptyUIPaywallView view,
    AdaptyPaywallProduct product,
  ) {
    // TODO: implement paywallViewDidStartPurchase
  }

  @override
  void paywallViewDidStartRestore(AdaptyUIPaywallView view) {
    // TODO: implement paywallViewDidStartRestore
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      // Add a button to re-trigger the paywall for testing purposes
      child: ElevatedButton(
        onPressed: _showPaywallIfNeeded,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.amber,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
        ),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: const Text(
            'BUY ME A COFFEE',
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
    );
  }
}
