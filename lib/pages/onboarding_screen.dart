import 'package:dice_roller/widgets/gradient_container.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingPage> _pages = [
    OnboardingPage(
      title: 'Welcome to\nRPG Dice Roller',
      description:
          'Roll any combination of dice with ease!\nPerfect for tabletop games, board games, and RPGs.',
      icon: Icons.casino_rounded,
      color: Colors.blue,
    ),
    OnboardingPage(
      title: 'Shake to Roll',
      description:
          'Enable shake-to-roll feature and roll dice by shaking your device!',
      icon: Icons.vibration_rounded,
      color: Colors.orange,
    ),
    OnboardingPage(
      title: 'Easy setup',
      description:
          'Start rolling in 3 easy steps:\n1) Add multiple dice types with a tap or remove them with a long press\n2) Set the modifier by swiping the numbers wheel\n3) You\'re ready to roll by tapping the ROLL button or shaking your device',
      icon: Icons.tune_rounded,
      color: Colors.pink,
    ),
    OnboardingPage(
      title: 'Past Rolls',
      description:
          'View your past rolls and analyze your rolling history just with a swipe up.',
      icon: Icons.history,
      color: Colors.green,
    ),
    OnboardingPage(
      title: 'Stats tracking',
      description:
          'Analyze your rolling statistics and improve your gameplay over time.',
      icon: Icons.numbers_rounded,
      color: Colors.red,
    ),
    OnboardingPage(
      title: 'Explore the App',
      description:
          'Now you are ready to discover all the features and functionalities of the app.\nNew features are constantly being added, so stay tuned!\nIf you need help, start the Guided Tour in the Settings to learn more.',
      icon: Icons.explore,
      color: Colors.purple,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _finishOnboarding() async {
    // Save that user has seen onboarding
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_seen_onboarding', true);

    // Navigate to main app
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder:
            (context) => GradientContainer('It\'s time to roll!', [
              Colors.blueGrey,
              Colors.black,
            ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: Colors.black),
        child: SafeArea(
          child: Column(
            children: [
              // Skip button
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: _finishOnboarding,
                  child: const Text(
                    'Skip',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
              // PageView with onboarding pages
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: _onPageChanged,
                  itemCount: _pages.length,
                  itemBuilder: (context, index) {
                    return _buildPageContent(_pages[index]);
                  },
                ),
              ),
              // Page indicators
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _pages.length,
                  (index) => _buildPageIndicator(index),
                ),
              ),
              const SizedBox(height: 20),
              // Navigation buttons
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Previous button
                    if (_currentPage > 0)
                      IconButton(
                        onPressed: _previousPage,
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        iconSize: 40,
                      )
                    else
                      const SizedBox(width: 48),
                    // Next/Finish button
                    if (_currentPage == _pages.length - 1)
                      ElevatedButton(
                        onPressed: _finishOnboarding,

                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),

                        child: Text(
                          'Get Started',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    if (_currentPage < _pages.length - 1)
                      IconButton(
                        onPressed: _nextPage,
                        icon: const Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                        ),
                        iconSize: 40,
                      )
                    else
                      const SizedBox(width: 48),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPageContent(OnboardingPage page) {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              color: page.color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(page.icon, size: 80, color: page.color),
          ),
          const SizedBox(height: 50),
          // Title
          Text(
            page.title,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          // Description
          Text(
            page.description,
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade400,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPageIndicator(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: _currentPage == index ? 24 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: _currentPage == index ? Colors.white : Colors.grey.shade500,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

class OnboardingPage {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  OnboardingPage({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}
