import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About WordPro',
        style: TextStyle(
              color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold),),
        // backgroundColor: primaryColor, // Use your primary app color
        elevation: 0,
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App Icon or Logo
            // Center(
            //   child: Container(
            //     width: 120,
            //     height: 120,
            //     decoration: const BoxDecoration(
            //       shape: BoxShape.circle,
            //       image: DecorationImage(
            //         image: AssetImage('assets/logo.png'), // Replace with your app's logo path
            //         fit: BoxFit.cover,
            //       ),
            //     ),
            //   ),
            // ),
            SizedBox(height: 10),
            // Title
            Center(
              child: Text(
                "Welcome to WordPro!",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(height: 20),
            // Description
            Text(
              "Discover the joy of learning English words with our engaging app! "
              "Designed for first graders, this app introduces essential words "
              "through colorful images and simple sentences.",
              style: TextStyle(
                fontSize: 18,
                height: 1.5, // Line height for better readability
              ),
            ),
            SizedBox(height: 16),
            Text(
              "Each word comes with its pronunciation, meaning, and examples, "
              "making vocabulary building fun and interactive. Perfect for young learners, "
              "our app helps build a strong foundation in English!",
              style: TextStyle(
                fontSize: 18,
                height: 1.5,
              ),
            ),
            SizedBox(height: 20),
            // Features Section
            Text(
              "Key Features:",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "- Essential English words.\n"
              "- Colorful images and simple sentences.\n"
              "- Pronunciations, meanings, and examples.\n"
              "- Fun and interactive vocabulary building.\n"
              "- Perfect for young learners.",
              style: TextStyle(
                fontSize: 16,
                height: 1.5,
              ),
            ),
            SizedBox(height: 30),
            // Closing Note
            Text(
              "Start your English learning journey today with WordPro!",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
