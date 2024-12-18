import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'billing_page.dart';
import 'login_page.dart';
import 'faq_page.dart';
//import 'userprofile.dart';
import 'delete_account.dart';
import 'about_page.dart';
import 'terms_condition.dart';
import 'help.dart';
import 'privacypolicy.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  String userName = '';
  String userEmail = '';
  String userPhone = '';
  String userId = '';
  String profileImageUrl =
      ''; // Placeholder image//https://via.placeholder.com/150

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
    _loadUserData();
    _loadProfileImage(); // Load profile image from local storage
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userEmail = prefs.getString('userEmail');

    if (userEmail != null && userEmail.isNotEmpty) {
      // If a user is logged in, navigate to the dashboard
    } else {
      // Otherwise, navigate to the welcome screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  Future<void> _onRefresh() async {
    // Simulate a delay for fetching or reloading data
    //await Future.delayed(Duration(seconds: 2));
    // You can add your logic here to refresh the data or re-fetch it.
    setState(() {
      // For example, we can change some data to simulate refreshing.
      // _checkLoginStatus();
      _loadUserData();
      _loadProfileImage(); // Load profile image from local storage
    });
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('userName') ?? 'Unknown User';
      userEmail = prefs.getString('userEmail') ?? 'Unknown Email';
      userPhone = prefs.getString('userPhone') ?? 'Unknown';
      userId = prefs.getString('userId') ?? 'Unknown ID';
    });
  }

  Future<void> _loadProfileImage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      profileImageUrl = prefs.getString('profile_photo') ??
          'assets/images/profilepic.jpg'; // Default placeholder
    });
  }

  // Function to pick image from gallery or camera
  Future<void> _updateProfileImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        profileImageUrl = pickedFile.path; // Update the local path
      });

      // Save the updated image path to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('profile_photo', pickedFile.path);

      // Optionally, send updated image to your API
      _sendUpdatedImageToServer(pickedFile.path);
    }
  }

  Future<void> _sendUpdatedImageToServer(String imagePath) async {
    // Logic to send the image to the server.
    print("Image sent to server: $imagePath");
  }

  Route _createRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0); // Slide in from the right
        const end = Offset.zero; // Slide to the center
        const curve = Curves.easeInOut;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        automaticallyImplyLeading: false,
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh, // This is the callback for pull-to-refresh
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
          children: [
            _buildGroupedSection([
              _buildProfileSection(),
            ]),
            const SizedBox(height: 24.0),
            _buildGroupedSection([
              _buildUserInfo('Name', userName, Icons.person, onTap: () {
                // Navigator.of(context).push(_createRoute(ProfilePage()));
              }),
              _buildUserInfo('Email', userEmail, Icons.email, onTap: () {
                // Navigator.of(context).push(_createRoute(ProfilePage()));
              }),
              _buildUserInfo('Phone Number', userPhone, Icons.phone, onTap: () {
                // Navigator.of(context).push(_createRoute(ProfilePage()));
              }),
              // _buildUserInfo('City', '', Icons.location_city, onTap: () {
              //  // Navigator.of(context).push(_createRoute(ProfilePage()));
              // }),
            ]),

            const SizedBox(height: 24.0),
            _buildGroupedSection([
              _buildListTile('FAQs', Icons.help, onTap: () {
                Navigator.of(context).push(_createRoute(FAQPage()));
              }),
              _buildListTile('Help & Support', Icons.help, onTap: () {
                //Navigator.of(context).push(_createRoute(HelpSupportPage()));
                Navigator.of(context).push(_createRoute(HelpAndSupportPage()));
              }),
              _buildListTile('Terms & Conditions', Icons.info, onTap: () {
                Navigator.of(context)
                    .push(_createRoute(const TermsAndConditionsPage()));
              }),
              _buildListTile('Privacy Policy', Icons.info, onTap: () {
                Navigator.of(context).push(_createRoute(const PrivacyPolicyPage()));
              }),
              _buildListTile('Delete your Account', Icons.help, onTap: () {
                Navigator.of(context).push(_createRoute(const AccountDeletionPage()));
              }),
              _buildListTile('About WordPro', Icons.info_outline, onTap: () {
                Navigator.of(context).push(_createRoute(const AboutPage()));
              }),
            ]),
            const SizedBox(height: 24.0),
            Center(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    //remove userEmail from pref
                    SharedPreferences.getInstance().then((prefs) {
                      prefs.remove('userEmail');
                    });
                    _checkLoginStatus();
                   // Navigator.of(context).push(_createRoute(LoginScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14.0),
                  ),
                  child: const Text('Log Out',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            const Center(child: Text('Version 1.0.1 (0167)')),
          ],
        ),
      ), // bottomNavigationBar: const BottomNavBar(currentIndex: 4),
    );
  }

  Widget _buildProfileSection() {
    return Row(
      children: [
        const SizedBox(width: 16.0),
        Stack(
          children: [
            // Profile Image Display
            CircleAvatar(
              radius: 36.0,
              backgroundImage: profileImageUrl.isNotEmpty
                  ? FileImage(File(profileImageUrl))
                  : const AssetImage('assets/images/profilepic.jpg')
                      as ImageProvider,
              onBackgroundImageError: (_, __) {
                // Handle fallback if the image is invalid
              },
            ),
            // Floating Camera Icon
            Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onTap: _showImagePickerDialog, // Show the image picker dialog
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.transparent,
                  ),
                  padding: const EdgeInsets.all(6.0),
                  child: const Icon(
                    Icons
                        .add_a_photo, // Ensure you use a valid icon name from `Icons`
                    color: Colors.grey, // Icon color
                    size: 30.0, // Icon size
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 16.0),
        // User Info Section
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12.0),
            Text(
              userName,
              style:
                  const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 3.0),
            Text(
              userEmail,
              style: const TextStyle(fontSize: 16.0, color: Colors.grey),
            ),
            const SizedBox(height: 3.0),
            Text(
              'BraveIQ ID: 000$userId',
              style: const TextStyle(fontSize: 14.0, color: Colors.black),
            ),
            const SizedBox(height: 12.0),
          ],
        ),
      ],
    );
  }

  Widget _buildGroupedSection(List<Widget> tiles) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        children: tiles.map((tile) {
          return Column(
            children: [
              tile,
              if (tile != tiles.last) const Divider(height: 1.0),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildListTile(String title, IconData icon,
      {String trailingText = '', VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: trailingText.isNotEmpty
          ? Text(trailingText)
          : const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  Widget _buildUserInfo(String title, String value, IconData icon,
      {VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: value.isNotEmpty
          ? Text(
              value,
              style: const TextStyle(fontSize: 16),
            )
          : const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  void _showImagePickerDialog() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () {
                  _updateProfileImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () {
                  _updateProfileImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
