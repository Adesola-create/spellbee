import 'package:flutter/material.dart';
import 'package:spellbee/signup_page.dart';
import 'splash_screen.dart'; // Import the splash screen
import 'slidescreenbg.dart';
import 'welcome_screen.dart'; // Import the welcome screen
import 'login_page.dart'; // Import the login page
import 'home_page.dart'; // Import the home page
import 'forgot_password.dart'; // Import the forgot password page
import 'spell_grade.dart'; // Assuming this is still part of your app

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Auth App',
      home: LoginScreen(),
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => SplashScreen(),
        '/intro': (context) => SlideScreen(),
        '/welcome': (context) => WelcomeScreen(), // Add welcome screen route
        '/login': (context) => LoginScreen(), // Add login screen route
        '/home': (context) => HomePage(),
        '/forgot_password': (context) => ForgotPassword(),
        '/spell_grade': (context) => SpellGradePage(),
        '/signup': (context) => SignupScreen(), // Add this line in routes
      },
    );
  }
}
