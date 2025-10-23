import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:dice_roller/pages/onboarding_screen.dart';
import 'package:dice_roller/widgets/gradient_container.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isFirstLaunch = true;

  @override
  void initState() {
    super.initState();
    _checkFirstLaunch();
  }

  Future<void> _checkFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    final hasSeenOnboarding = prefs.getBool('has_seen_onboarding') ?? false;

    setState(() {
      _isFirstLaunch = !hasSeenOnboarding;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Center(child: Lottie.asset('assets/animations/dice.json')),
      nextScreen:
          _isFirstLaunch
              ? const OnboardingScreen()
              : GradientContainer('It\'s time to roll!', [
                Colors.blueGrey,
                Colors.black,
              ]),
      duration: 1500,
      backgroundColor: Colors.black,
    );
  }
}
