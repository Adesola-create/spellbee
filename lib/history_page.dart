import 'dart:convert';
import 'package:WordPro/constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<Map<String, dynamic>> quizHistoryList = [];
  List<Map<String, dynamic>> filteredList = [];
  String selectedGrade = 'All'; // Default filter

  @override
  void initState() {
    super.initState();
    _loadQuizHistory(); // Load history when the page is initialized
  }

  /// Load quiz history from SharedPreferences
  Future<void> _loadQuizHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      //await prefs.remove('quizHistory');
      final historyData = prefs.getStringList('quizHistoryLog') ?? [];
      print('Loaded quiz history: $historyData');

      setState(() {
        quizHistoryList = historyData
            .map((e) =>
                json.decode(e) as Map<String, dynamic>) // Decode JSON strings
            .toList();
        _applyFilter(); // Apply default filter (show all)
      });
    } catch (error) {
      print('Error loading quiz history: $error');
    }
  }

  /// Apply filter based on the selected grade
  void _applyFilter() {
    setState(() {
      if (selectedGrade == 'All') {
        filteredList = quizHistoryList;
      } else {
        filteredList = quizHistoryList
            .where((history) => history['grade'] == selectedGrade)
            .toList();
      }
    });
  }

  /// Format time spent in "MM:SS" format
  String _formatTimeSpent(int? timeSpent) {
    if (timeSpent == null) return '00:00'; // Default value for null
    final minutes = timeSpent ~/ 60;
    final seconds = timeSpent % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    // Sort the quizHistoryList by date
    quizHistoryList.sort((a, b) {
      final dateA = DateTime.parse(a['date'] ?? '1970-01-01');
      final dateB = DateTime.parse(b['date'] ?? '1970-01-01');
      return dateB.compareTo(dateA);
    });

    // Extract unique grades from quizHistoryList
    final grades = quizHistoryList
        .map((history) =>
            history['grade'] as String?) // Explicitly cast to String?
        .where((grade) => grade != null) // Ensure null grades are filtered out
        .cast<String>() // Cast to a list of strings
        .toSet()
        .toList()
      ..sort(); // Sort the grades in ascending order

// Add "All" to the beginning of the list
    grades.insert(0, 'All');

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Quiz History',
        style: TextStyle(
              color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold),),
        // backgroundColor: Colors.purple,
      ),
      body: Column(
        children: [
          _buildFilterButtons(grades), // Filter buttons
          Expanded(
            child: filteredList.isEmpty
                ? const Center(
                    child: Text(
                      'No quiz history found.',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      final history = filteredList[index];
                      return _buildQuizHistoryTile(history);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  /// Build filter buttons
  Widget _buildFilterButtons(List<String> grades) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: grades.map((grade) {
            final isSelected = selectedGrade == grade;
            return Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    selectedGrade = grade;
                    _applyFilter(); // Update filtered list
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      isSelected ? primaryColor : Colors.grey[300],
                  foregroundColor: isSelected ? Colors.white : Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22.0),
                  ),
                ),
                child: Text(
                  grade == 'All' ? grade : 'Grade $grade',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  /// Build a single quiz history tile
  Widget _buildQuizHistoryTile(Map<String, dynamic> history) {
    final scrollController = ScrollController();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[200], // Background color
        borderRadius: BorderRadius.circular(8), // Rounded corners
        border: Border.all(color: Colors.grey), // Border
      ),
      padding: const EdgeInsets.symmetric(
          vertical: 8, horizontal: 12), // Reduced padding
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Grade: ${history['grade'] ?? 'N/A'} - Module: ${history['module'] ?? 'N/A'}',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Row(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  controller: scrollController,
                  child: Row(
                    children: [
                      _buildSubtitleItem(Icons.score,
                          'Score: ${(history['percentScore'] ?? 0).toStringAsFixed(1)}%'),
                      _buildSubtitleItem(
                          Icons.quiz, 'Questions: ${history['length'] ?? '0'}'),
                      _buildSubtitleItem(Icons.access_time,
                          'Time: ${_formatTimeSpent(history['timeSpent'] as int?)}'),
                      _buildSubtitleItem(Icons.calendar_today,
                          'Date: ${history['date'] ?? 'Unknown'}'),
                      _buildSubtitleItem(
                          history['sent'] == true ? Icons.check : Icons.close,
                          'Sync: ${history['sent'] == true ? "Yes" : "No"}',
                          color: history['sent'] == true
                              ? Colors.green
                              : Colors.red),
                    ],
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward_ios, size: 16),
                onPressed: () {
                  // Scroll to the end if not already at the end, otherwise scroll to the beginning
                  if (scrollController.offset ==
                      scrollController.position.maxScrollExtent) {
                    scrollController.animateTo(
                      0, // Scroll back to the start
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  } else {
                    scrollController.animateTo(
                      scrollController
                          .position.maxScrollExtent, // Scroll to the end
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Helper method to build subtitle items with icons and text
  Widget _buildSubtitleItem(IconData icon, String text, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Row(
        children: [
          Icon(icon, size: 16, color: color ?? Colors.black),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(color: color ?? Colors.black),
          ),
        ],
      ),
    );
  }
}
