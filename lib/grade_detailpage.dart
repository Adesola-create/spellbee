import 'package:flutter/material.dart';

class GradeDetailPage extends StatelessWidget {
  final int grade;
  final String imagePath;

  const GradeDetailPage({
    Key? key,
    required this.grade,
    required this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Grade $grade'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                height: 300,
                width: 200, // Set width for the image container
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  image: DecorationImage(
                    image: AssetImage(imagePath), // Use dynamic image path
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter, // Align image to top if necessary
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'In Grade $grade,',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            const Text(
              'students are introduced to basic spelling concepts. The focus is on:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                // Add to cart action
              },
              child: const Text(
                'Add To Cart',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                minimumSize:
                    const Size(double.infinity, 50), // Full width button
                backgroundColor: Colors.purple, // Button color
              ),
            ),
          ],
        ),
      ),
    );
  }
}
