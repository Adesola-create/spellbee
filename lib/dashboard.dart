import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

import 'grade_detailpage.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  List<dynamic> localGradeData = [];
  bool isFetching = false;

  @override
  void initState() {
    super.initState();
    loadLocalData();
    fetchAndUpdateDataSilently();
  }

  Future<void> loadLocalData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? gradeDataString = prefs.getString('gradeData');

    if (gradeDataString != null) {
      setState(() {
        localGradeData = json.decode(gradeDataString);
      });
    }
  }

  Future<void> fetchAndUpdateDataSilently() async {
    setState(() {
      isFetching = true;
    });

    const String url = 'https://spellbee.braveiq.net/v1/getspellgrade';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        List<dynamic> fetchedData = json.decode(response.body);

        

        // Download and save images locally
        await saveImagesLocally(fetchedData);

        // Update local state
        setState(() {
          localGradeData = fetchedData;
        });
      }
    } catch (e) {
      debugPrint('Error fetching data: $e');
    } finally {
      setState(() {
        isFetching = false;
      });
    }
  }

  Future<void> saveImagesLocally(List<dynamic> data) async {
    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final Dio dio = Dio();

        // Save fetched data to SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();

    for (var grade in data) {
      String imageUrl = grade['image'];
      String imageName = imageUrl.split('/').last;
      String imagePath = '${appDocDir.path}/$imageName';

      if (!File(imagePath).existsSync()) {
        try {
          await dio.download(imageUrl, imagePath);
          grade['localImagePath'] = imagePath;
        } catch (e) {
          debugPrint('Error downloading image: $e');
        }
      } else {
        grade['localImagePath'] = imagePath;
      }
    }
    await prefs.setString('gradeData', json.encode(data));
  }

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
        // actions: [
        //   IconButton(icon: const Icon(Icons.shopping_cart), onPressed: () {}),
        //   IconButton(icon: const Icon(Icons.notifications), onPressed: () {}),
        // ],
      ),
      body: isFetching && localGradeData.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildWelcomeCard(),
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
                    itemCount: localGradeData.length,
                    itemBuilder: (context, index) {
                      final grade = localGradeData[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GradeDetailPage(
                                grade: grade['title'],
                                imagePath: grade['localImagePath'] ?? grade['image'],
                                price: grade['price'],
                                description: grade['description'],
                              ),
                            ),
                          );
                        },
                        child: _buildCategoryCard(
                          grade['title'],
                          grade['localImagePath'] ?? grade['image'],
                          double.parse(grade['price']),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildCategoryCard(String title, String imagePath, double price) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Image section
          Container(
            height: 135,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
              image: DecorationImage(
                image: File(imagePath).existsSync()
                    ? FileImage(File(imagePath))
                    : NetworkImage(imagePath) as ImageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Title and price section
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '\$${price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return Container(
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
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Start your journey with simple and fun activities perfect for beginners and all level of english learners.'
            
            '\n Learn English words and phrases in a fun and interactive way.',
            
            style: TextStyle(color: Colors.white),
          ),
          // const SizedBox(height: 20),
          // ElevatedButton(
          //   onPressed: () {
          //     // Navigate to your next page
          //   },
          //   style: ElevatedButton.styleFrom(),
          //   child: const Text('Get Started'),
          // ),
        ],
      ),
    );
  }

  Widget _buildProfilePicture() {
    return Container(
      width: 40,
      height: 40,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          image: AssetImage('assets/images/profilepic.jpg'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
