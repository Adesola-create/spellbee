import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<Map<String, dynamic>> quizHistoryList = [];

  @override
  void initState() {
    super.initState();
    _loadQuizHistory(); // Load history when the page is initialized
  }

  /// Load quiz history from SharedPreferences
  Future<void> _loadQuizHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyData = prefs.getStringList('quizHistory') ?? [];



      setState(() {
        quizHistoryList = historyData
            .map((e) => json.decode(e) as Map<String, dynamic>) // Decode JSON strings
            .toList();
      });
    } catch (error) {
      print('Error loading quiz history: $error');
    }
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
    //sort the list by date
    quizHistoryList.sort((a, b) {
      final dateA = DateTime.parse(a['date'] ?? '1970-01-01');
      final dateB = DateTime.parse(b['date'] ?? '1970-01-01');
      return dateB.compareTo(dateA);
    });
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz History'),
        backgroundColor: Colors.purple,
      ),
      body: quizHistoryList.isEmpty
          ? const Center(
              child: Text(
                'No quiz history found.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: quizHistoryList.length,
              itemBuilder: (context, index) {
                final history = quizHistoryList[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: ListTile(
                    title: Text(
                      'Grade: ${history['grade'] ?? 'N/A'} - Module: ${history['module'] ?? 'N/A'}',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            'Score: ${(history['percentScore'] ?? 0).toStringAsFixed(1)}%'),
                        Text('Questions: ${history['length'] ?? '0'}'),
                        Text(
                            'Time Spent: ${_formatTimeSpent(history['timeSpent'] as int?)}'),
                        Text('Date: ${history['date'] ?? 'Unknown'}'),
                        Text(
                          'Sent: ${history['sent'] == true ? "Yes" : "No"}',
                          style: TextStyle(
                            color: history['sent'] == true
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
