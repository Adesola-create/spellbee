import 'dart:convert';
import 'dart:io';
import 'package:WordPro/home_page.dart';
//import 'package:WordPro/userprofile.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:dio/dio.dart';
import 'constants.dart';
import 'grade_detailpage.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  List<dynamic> localGradeData = [];
  bool isFetching = false;
  String userName = '';

  @override
  void initState() {
    super.initState();
    loadLocalData();
    fetchAndUpdateDataSilently();
  }

  Future<void> loadLocalData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? gradeDataString = prefs.getString('gradeData');
    print(gradeDataString);

    if (gradeDataString != null) {
      setState(() {
        userName = prefs.getString('userName') ?? '';
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
      String productId = grade['productid'];
      String playPrice = await getPlayPrice(data, productId);

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
        grade['playPrice'] = playPrice;
      }
    }
    await prefs.setString('gradeData', json.encode(data));
    setState(() {
      localGradeData = data;
    });
  }

  Future<String> getPlayPrice(
      List<dynamic> fetchedGrades, String productId) async {
    // Extract all productIds from fetchedExams
    final Set<String> serverProductIds =
        fetchedGrades.map((exam) => exam['productid'] as String).toSet();

    // Query Play Console for all product details
    final ProductDetailsResponse response =
        await InAppPurchase.instance.queryProductDetails(serverProductIds);

    // Map Play Console prices for easy lookup
    final Map<String, ProductDetails> playConsolePrices = {
      for (var product in response.productDetails) product.id: product,
    };

    // Match the entered productId
    if (playConsolePrices.containsKey(productId)) {
      return playConsolePrices[productId]!
          .price; // Return the Play Console price
    } else {
      return 'N/A'; // Fallback if the productId is not found
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            _buildProfilePicture(),
            const SizedBox(width: 8),
            Text('Hi, $userName'),
          ],
        ),
      ),
      body: isFetching && localGradeData.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildWelcomeCardCarousel(),
                  const SizedBox(height: 20),
                  const Text(
                    'Categories',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.55,
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
                                imagePath:
                                    grade['localImagePath'] ?? grade['image'],
                                price: grade['playPrice'] ?? grade['price'],
                                description: grade['description'],
                                productid: grade['productid'],
                              ),
                            ),
                          );
                        },
                        child: _buildCategoryCard(
                            grade['title'],
                            grade['localImagePath'] ?? grade['image'],
                            grade['playPrice'] ?? grade['price'],
                            grade['description'],
                            grade['productid']),
                      );
                    },
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildCategoryCard(
      String title, String imagePath, String price, description, productid) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15), // Rounded corners for the card
      ),
      elevation: 0, // Add shadow to the card for better UI
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start, // Align content to the start
        children: [
          // Image section
          Container(
            height: 180, // Full height for the image
            width: double.infinity, // Make the image occupy full width
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
              image: DecorationImage(
                image: File(imagePath).existsSync()
                    ? FileImage(File(imagePath))
                    : NetworkImage(imagePath) as ImageProvider,
                fit: BoxFit.cover, // Cover the entire container
              ),
            ),
          ),
          // Title, price, and button section
          Padding(
            padding: const EdgeInsets.all(
                8.0), // Padding for title, price, and button
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  '$title Resources',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis, // Handle long titles
                  maxLines: 1,
                ),
                const SizedBox(height: 4), // Spacing between title and price
                // Price
                Text(
                  price,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  overflow: TextOverflow.ellipsis, // Handle long price text
                ),
                const SizedBox(height: 8), // Spacing between price and button
                // Buy Now button
                SizedBox(
                  width: double.infinity, // Make the button full width
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GradeDetailPage(
                            grade: title,
                            imagePath: imagePath,
                            price: price,
                            description: description,
                            productid: productid,
                          ),
                        ),
                      ); // Handle the Buy Now button press
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          primaryColor, // Blue background color for the button
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            8), // Rounded corners for the button
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 12, // Button height
                      ),
                    ),
                    child: const Text('Buy Now',
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeCardCarousel() {
    final List<Widget> cards = [
      _buildSingleWelcomeCard(
        'Welcome!',
        'Start your journey with simple and fun activities perfect for beginners and all levels of English learners.',
        color: primaryColor,
      ),
      _buildSingleWelcomeCard('Learn Words!',
          'Explore new words and phrases daily with engaging lessons and activities.',
          color: const Color.fromARGB(255, 0, 71, 3)),
      _buildSingleWelcomeCard('Achieve Goals!',
          'Track your progress and achieve your learning milestones with ease.',
          color: const Color.fromARGB(255, 56, 4, 141)),
    ];

    return SizedBox(
      height: 200, // Height of the carousel
      child: PageView(
        controller: PageController(viewportFraction: 0.95), // Swipeable cards
        children: cards,
      ),
    );
  }

  Widget _buildSingleWelcomeCard(String title, String description,
      {color = primaryColor}) {
    return Container(
      margin: const EdgeInsets.symmetric(
          horizontal: 5), // Adds spacing between cards
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            description,
            style: const TextStyle(color: Colors.white, fontSize: 17),
          ),
        ],
      ),
    );
  }

  Widget _buildProfilePicture() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => HomePage(selectedIndex: 4)), // Navigate to ProfilePage
        );
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: AssetImage('assets/images/profilepic.png'),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
