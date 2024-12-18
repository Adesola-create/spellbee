import 'package:WordPro/spell_grade.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class GradeDetailPage extends StatefulWidget {
  final String grade;
  final String imagePath;
  final String price;
  final String description;

  const GradeDetailPage({
    super.key,
    required this.grade,
    required this.imagePath,
    required this.price,
    required this.description,
  });

  @override
  _GradeDetailPageState createState() => _GradeDetailPageState();
}

class _GradeDetailPageState extends State<GradeDetailPage> {
  Future<void> deliverPurchase() async {
    final prefs = await SharedPreferences.getInstance();
    final String? userId = prefs.getString('userId');
    final url = Uri.parse('https://spellbee.braveiq.net/v1/purchased');
    final body = {
      'grade': widget.grade,
      'purchased': 'true',
      'userid': userId,
    };

    //printing response code
    // Check internet connectivity
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        // isLoading = false; // Stop loading indicator if no connection
      });
      return;
    }

    try {
      // Make the request with a timeout
      final response = await http.post(url, body: body);

      if (response.statusCode == 200) {
        //navigate to excercise page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SpellGradePage(),
          ),
        );
      } else {
        setState(() {
          //isLoading = false; // Stop loading indicator on error
        });
      }
    } catch (e) {
      setState(() {
        //isLoading = false; // Stop loading indicator on error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // Extend body to overlap with AppBar
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          backgroundColor: Colors.transparent, // Transparent AppBar
          elevation: 0, // Remove shadow
          leading: IconButton(
            icon: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white, // White background
              ),
              padding: const EdgeInsets.all(8.0),
              child: const Icon(
                Icons.arrow_back,
                color: Colors.black, // Black icon color
              ),
            ),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            // Favorite (Love) Icon
            IconButton(
              icon: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white, // White background
                ),
                padding: const EdgeInsets.all(8.0),
                child: const Icon(
                  Icons.favorite_border,
                  color: Colors.black, // Black icon color
                ),
              ),
              onPressed: () {
                // Handle favorite action
              },
            ),
            const SizedBox(width: 10), // Add spacing between icons
            // Share Icon
            IconButton(
              icon: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white, // White background
                ),
                padding: const EdgeInsets.all(8.0),
                child: const Icon(
                  Icons.share,
                  color: Colors.black, // Black icon color
                ),
              ),
              onPressed: () {
                // Handle share action
              },
            ),
            const SizedBox(
                width: 10), // Add spacing before the end of the AppBar
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Fullscreen Image
            Container(
              height: 350, // Adjust as needed
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: FileImage(File(widget.imagePath)),
                  fit: BoxFit.cover, // Image covers the width
                ),
              ),
            ),
            // Price Container directly under the image
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.green,
              ),
              child: Text(
                widget.price,
                style: const TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Content below the price container
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'GRADE ${widget.grade}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    widget.description,
                    style: const TextStyle(
                      fontSize: 18,
                      //fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    '- Learning common sight words (e.g., "the", "and", "to")\n'
                    '- Simple CVC (consonant-vowel-consonant) word families\n'
                    '- Short vowel sounds and simple word families',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      deliverPurchase(); // Add to cart action
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize:
                          const Size(double.infinity, 50), // Full width
                      backgroundColor: Colors.purple,
                    ),
                    child: const Text(
                      'Buy Now',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
