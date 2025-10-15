import 'package:adapty_flutter/adapty_flutter.dart';
import 'package:flutter/material.dart';
import 'package:dice_roller/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Configure and activate Adapty SDK
  await Adapty().activate(
    configuration:
        AdaptyConfiguration(apiKey: 'public_live_JMJ7LnV7.k4xOEIDk7ogzSWEdnt5w')
          ..withActivateUI(true)
          ..withGoogleAdvertisingIdCollectionDisabled(true),
  );

  runApp(const App());
}
