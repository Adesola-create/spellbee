import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences
import 'spell_word.dart';

class SpellGradePage extends StatefulWidget {
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
    final storedGrades = prefs.getString('grades');
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
    final url = Uri.parse('https://spellbee.braveiq.net/v1/getspellgrade');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        // Compare and update local storage only if the data is different
        final prefs = await SharedPreferences.getInstance();
        final storedGrades = prefs.getString('grades');

        if (storedGrades == null || storedGrades != response.body) {
          await prefs.setString('grades', response.body);
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
        title: Text('Spell Grades'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: _grades.length,
                itemBuilder: (context, index) {
                  final grade = _grades[index];
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
                    child: Card(
                      color: Colors.grey[300],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: BorderSide(color: Colors.purple, width: 1.5),
                      ),
                      child: ListTile(
                        title: Text(grade['title']),
                        subtitle: Text(grade['note']),
                        trailing: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'N',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                              TextSpan(
                                text: ' ${grade['price']}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}