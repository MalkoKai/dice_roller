import 'package:dice_roller/pages/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [SystemUiOverlay.bottom],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Force Portrait Mode
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp, // Normal Portrait
      DeviceOrientation.portraitDown, // Upside-Down Portrait
    ]);
    return MaterialApp(debugShowCheckedModeBanner: false, home: SplashScreen());
  }
}
