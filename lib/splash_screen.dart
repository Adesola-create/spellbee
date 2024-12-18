import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_page.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _typingAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(seconds: 6),
      vsync: this,
    );

    _typingAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _animationController.forward();

    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userEmail = prefs.getString('userEmail');

    // Wait for 5 seconds (or the duration of the animation)
    await Future.delayed(const Duration(seconds: 5));

    if (userEmail != null && userEmail.isNotEmpty) {
      // If a user is logged in, navigate to the dashboard
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } else {
      // Otherwise, navigate to the welcome screen
      _navigateToIntro();
    }
  }

  Future<void> _navigateToIntro() async {
    await Future.delayed(const Duration(seconds: 6));
    Navigator.pushReplacementNamed(
        context, '/intro'); // Updated to navigate to IntroScreen
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue, // Change this to your primary color
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: AnimatedBuilder(
            animation: _typingAnimation,
            builder: (context, child) {
              return Text(
                'wordpro'.substring(
                    0,
                    (_typingAnimation.value * 'wordpro'.length)
                        .ceil()), // Corrected for 'BraveIQ'
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 46,
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
