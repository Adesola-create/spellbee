import 'package:WordPro/constants.dart';
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
  double originalPrice = double.parse(widget.price); // Original price
  double discountPercentage = 20.0; // Discount percentage

  // Calculate discount price
  double discountPrice = originalPrice - (originalPrice * discountPercentage / 100);

  return Scaffold(
    extendBodyBehindAppBar: true,
    appBar: PreferredSize(
      preferredSize: const Size.fromHeight(50),
      child: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            padding: const EdgeInsets.all(8.0),
            child: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              padding: const EdgeInsets.all(8.0),
              child: const Icon(
                Icons.favorite_border,
                color: Colors.black,
              ),
            ),
            onPressed: () {},
          ),
          const SizedBox(width: 10),
          IconButton(
            icon: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              padding: const EdgeInsets.all(8.0),
              child: const Icon(
                Icons.share,
                color: Colors.black,
              ),
            ),
            onPressed: () {},
          ),
          const SizedBox(width: 10),
        ],
      ),
    ),
    body: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 350,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: FileImage(File(widget.imagePath)),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: const BoxDecoration(
              color: Colors.black,
            ),
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                '\$$discountPrice',
                style: const TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                '\$$originalPrice',
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white70,
                  decoration: TextDecoration.lineThrough,
                  decorationColor: Colors.white,
                ),
              ),
              trailing: Text(
                '$discountPercentage%',
                style: const TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${widget.grade} Resources',
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
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'This grade features:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Text(
                  '- Over 1,000 English learning words\n'
                  '- Suitable for vocabulary development\n'
                  '- Word mastery for everyday usage\n'
                  '- Spelling Bee competition preparatory',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    ),
    bottomNavigationBar: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      color: Colors.white, // Background color for the button container
      child: ElevatedButton(
        onPressed: () {
          deliverPurchase(); // Add to cart action
        },
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 60),
          backgroundColor: primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        child: const Text(
          'Buy Now',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
    ),
  );
}
}
