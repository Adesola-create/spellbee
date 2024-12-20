import 'package:flutter/material.dart';
import 'dashboard.dart'; // Import your other pages
import 'spell_grade.dart';
import 'history_page.dart';
import 'overview.dart';
import 'account_page.dart';

class HomePage extends StatefulWidget {
  final int selectedIndex;  // Add this parameter

  const HomePage({super.key, this.selectedIndex = 0});
  
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  // List of pages to display when navigating using BottomNavBar
  final List<Widget> _pages = [
    const DashboardPage(), // Dashboard page
    const SpellGradePage(),   // Exercise page
    const HistoryPage(),   // History page
    const OverviewPage(), // Challenge page
    const AccountPage(),   // Account page
  ];
  @override
  void initState() {
    super.initState();
    // Set the current index based on the passed value
    _currentIndex = widget.selectedIndex;
  }
  get primaryColor => null;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // If the current index is not 0 (the index tab), navigate to index tab
        if (_currentIndex != 0) {
          setState(() {
            _currentIndex = 0; // Set to the index tab
          });
          return false; // Prevent the default back action
        }
        return true; // Allow back navigation if on the index tab
      },
    child: Scaffold(
      body: _pages[_currentIndex],  // Show the selected page
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;  // Update current index on tap
          });
        },
        selectedItemColor: primaryColor, // Use your primary color for selected item
        unselectedItemColor: Colors.grey, // Color for unselected items
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.bold, // Set selected item text to bold
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.normal, // Unselected items remain normal weight
        ),
        items: [
          BottomNavigationBarItem(
            icon: _buildIcon(Icons.home, Icons.home_outlined, 0),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: _buildIcon(Icons.school, Icons.school_outlined, 1),
            label: 'Exercise',
          ),
          BottomNavigationBarItem(
            icon: _buildIcon(Icons.history, Icons.history_outlined, 2),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: _buildIcon(Icons.gamepad, Icons.gamepad_outlined, 3),
            label: 'Overview',
          ),
          BottomNavigationBarItem(
            icon: _buildIcon(Icons.settings, Icons.settings_outlined, 4),
            label: 'Account',
          ),
        ],
      ),
    ),
    );
  }

  Widget _buildIcon(IconData selectedIcon, IconData unselectedIcon, int index) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 2,  // Vertical padding
        horizontal: 12,  // Horizontal padding
      ),
      decoration: BoxDecoration(
        //color: _currentIndex == index ? Colors.purple.withOpacity(0.1) : Colors.transparent, // Background color for selected item
        borderRadius: BorderRadius.circular(14), // Rounded corners
      ),
      child: Icon(
        _currentIndex == index ? selectedIcon : unselectedIcon, // Show appropriate icon
        color: _currentIndex == index ? primaryColor : Colors.black, // Icon color
      ),
    );
  }
}