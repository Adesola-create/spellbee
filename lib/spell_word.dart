import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'learn_words.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'congratulatoryscreen.dart';

class SpellWordPage extends StatefulWidget {
  final String grade;
  final int? newindex; // Optional parameter

  const SpellWordPage({Key? key, required this.grade, this.newindex})
      : super(key: key);

  @override
  _SpellWordPageState createState() => _SpellWordPageState();
}

class _SpellWordPageState extends State<SpellWordPage> {
  List<List<Map<String, dynamic>>> modules = [];
  bool isLoading = true;
  String error = '';

  @override
  void initState() {
    super.initState();
    loadStoredWords();
    fetchSpellWords();

    // Automatically navigate if newindex is provided
    if (widget.newindex != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _autoNavigateToModule(widget.newindex!);
      });
    }
  }

Future<List<int>> getPassedModules(String grade) async {
  final prefs = await SharedPreferences.getInstance();
  final passedModulesKey = 'passedGrade$grade';
  final existingModules = prefs.getStringList(passedModulesKey) ?? [];

  // Ensure the first module is always unlocked
  final unlockedModules = existingModules.map((e) => int.parse(e)).toSet();
  unlockedModules.add(1); // Add the first module (module index 1) to the set

  return unlockedModules.toList();
}



  Future<void> loadStoredWords() async {
    final prefs = await SharedPreferences.getInstance();
    final storedWords = prefs.getString('words${widget.grade}');
    //save grade
    prefs.setString('grade', widget.grade);

    if (storedWords != null) {
      final List<dynamic> data = json.decode(storedWords);
      setState(() {
        modules = groupWordsIntoModules(data);
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false; // No stored data, just stop loading
      });
    }
  }

  Future<void> fetchSpellWords() async {
    final url = Uri.parse('https://spellbee.braveiq.net/v1/getspellwords');
    final body = {'grade': widget.grade};

    // Check internet connectivity
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        isLoading = false; // Stop loading indicator if no connection
      });
      return;
    }

    try {
      // Make the request with a timeout
      final response = await http.post(url, body: body);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final prefs = await SharedPreferences.getInstance();
        final storedWords = prefs.getString('words${widget.grade}');

        if (storedWords == null || storedWords != response.body) {
          await prefs.setString('words${widget.grade}', response.body);
          setState(() {
            modules = groupWordsIntoModules(data);
          });
        }
      } else {
        setState(() {
          isLoading = false; // Stop loading indicator on error
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false; // Stop loading indicator on error
      });
    }
  }

  List<List<Map<String, dynamic>>> groupWordsIntoModules(List<dynamic> data) {
    List<List<Map<String, dynamic>>> groupedModules = [];
    for (int i = 0; i < data.length; i += 10) {
      groupedModules.add(data
          .sublist(i, i + 10 > data.length ? data.length : i + 10)
          .cast<Map<String, dynamic>>());
    }
    return groupedModules;
  }

  void navigateToLearnWordsPage(
      List<Map<String, dynamic>> moduleWords, int moduleIndex) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LearnWordsPage(
          moduleWords: moduleWords,
          moduleIndex: (moduleIndex + 1).toString(),
        ),
      ),
    );
  }

  Future<void> _autoNavigateToModule(int newIndex) async {
  // Wait for modules to load
  while (isLoading) {
    await Future.delayed(const Duration(milliseconds: 200));
  }

  if (newIndex >= 0 && newIndex < modules.length) {
    // Navigate to the selected module
    navigateToLearnWordsPage(modules[newIndex], newIndex);
  } else {
    // Navigate to the CongratulationsScreen when all modules are completed
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CongratulationsScreen(),
      ),
    );
  }
}


  @override
  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(title: Text('Grade ${widget.grade} Spelling Words')),
    body: isLoading
        ? const Center(child: CircularProgressIndicator())
        : error.isNotEmpty
            ? Center(
                child: Text(
                error,
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ))
            : FutureBuilder<List<int>>(
                future: getPassedModules(widget.grade),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error loading modules',
                        style: TextStyle(
                            fontSize: 18, color: Colors.redAccent),
                      ),
                    );
                  } else {
                    final unlockedModules = snapshot.data ?? [];

                    return ListView.builder(
                      padding: const EdgeInsets.all(8.0),
                      itemCount: modules.length,
                      itemBuilder: (context, moduleIndex) {
                        final isUnlocked =
                            unlockedModules.contains(moduleIndex + 1);

                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            title: Text('Module ${moduleIndex + 1}'),
                            trailing: Icon(
                              isUnlocked
                                  ? Icons.lock_open // Unlocked
                                  : Icons.lock, // Locked
                              color: isUnlocked ? Colors.green : Colors.red,
                            ),
                            onTap: () {
                              if (isUnlocked) {
                                // Navigate to LearnWordsPage for unlocked module
                                navigateToLearnWordsPage(
                                    modules[moduleIndex], moduleIndex);
                              } else {
                                // Show dialog for locked module
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Locked Module'),
                                    content: const Text(
                                        'This module is not yet unlocked.'),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            },
                          ),
                        );
                      },
                    );
                  }
                },
              ),
  );
}

}
