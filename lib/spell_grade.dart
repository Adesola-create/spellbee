import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'spell_word.dart';

class SpellGradePage extends StatefulWidget {
  const SpellGradePage({super.key});

  @override
  _SpellGradePageState createState() => _SpellGradePageState();
}

class _SpellGradePageState extends State<SpellGradePage> {
  List<dynamic> _grades = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    loadStoredGrades();
    fetchSpellGrades();
  }

  Future<void> loadStoredGrades() async {
    final prefs = await SharedPreferences.getInstance();
    final storedGrades = prefs.getString('myProducts');
    if (storedGrades != null) {
      setState(() {
        _grades = json.decode(storedGrades);
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false; // No stored data, just stop loading
      });
    }
  }

  Future<void> fetchSpellGrades() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    final url =
        Uri.parse('https://spellbee.braveiq.net/v1/getproducts?userid=$userId');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        final prefs = await SharedPreferences.getInstance();
        final storedGrades = prefs.getString('myProducts');

        if (storedGrades == null || storedGrades != response.body) {
          await prefs.setString('myProducts', response.body);
          setState(() {
            _grades = data;
          });
        }
      } else {
        throw Exception('Failed to load grades');
      }
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Purchased Spell Grades'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: _grades.length,
                itemBuilder: (context, index) {
                  final grade = _grades[index];

                  // Truncate the description to fit row space
                  String truncatedDescription =
                      (grade['description'] ?? 'No description available');
                  if (truncatedDescription.length > 100) {
                    truncatedDescription =
                        '${truncatedDescription.substring(0, 100)}...';
                  }

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SpellWordPage(
                            grade: grade['id'],
                          ),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey, // Border color
                          width: 1.5, // Border thickness
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.white, // Background color
                      ),
                      margin: const EdgeInsets.only(bottom: 10.0),
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Grade Image
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: (grade['localImagePath'] != null &&
                                        File(grade['localImagePath'])
                                            .existsSync())
                                    ? FileImage(File(grade['localImagePath']))
                                    : NetworkImage(grade['image'])
                                        as ImageProvider,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12), // Spacing

                          // Title and Description
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Grade Title
                                Text(
                                  grade['title'],
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                // Truncated Description
                                Text(
                                  truncatedDescription,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black54,
                                  ),
                                  maxLines: 3, // Limit the number of lines
                                  overflow: TextOverflow.ellipsis, // Add ellipsis
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
