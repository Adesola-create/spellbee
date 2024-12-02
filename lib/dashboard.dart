import 'package:flutter/material.dart';
import 'grade_detailpage.dart'; // Ensure this imports your GradeDetailPage

class DashboardPage extends StatelessWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            _buildProfilePicture(),
            const SizedBox(width: 8),
            const Text('Hi, Dee'),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.shopping_cart), onPressed: () {}),
          IconButton(icon: const Icon(Icons.notifications), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.purple,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Welcome!',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Start your journey with simple and fun activities perfect for beginners who are just starting out...',
                    style: TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to your next page
                    },
                    style: ElevatedButton.styleFrom(
                      //iconColor: Colors.orange,
                    ),
                    child: const Text('Get Started'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Categories',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: 12, // Change this to the actual number of categories
              itemBuilder: (context, index) {
                final grade = index + 1;
                final imagePath = 'assets/images/grade_$grade.jpg'; // Dynamic image path

                return GestureDetector(
                  onTap: () {
                    // Navigate to the GradeDetailPage with the selected grade and its image
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GradeDetailPage(
                          grade: grade,
                          imagePath: imagePath, // Pass the image path
                        ),
                      ),
                    );
                  },
                  child: _buildCategoryCard('GRADE $grade', imagePath),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // Updated _buildCategoryCard to display an image instead of an icon
  Widget _buildCategoryCard(String title, String imagePath) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: double.infinity,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15), // Optional rounded corners
              image: DecorationImage(
                image: AssetImage(imagePath), // Image for the grade
                fit: BoxFit.cover, // Ensures the image fits properly
                alignment: Alignment.topCenter, // Aligns the image to the top
              ),
            ),
          ),
          
          const SizedBox(height: 15),
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildProfilePicture() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: const DecorationImage(
          image: AssetImage('assets/images/profilepic.jpg'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
