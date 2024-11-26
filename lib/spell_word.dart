import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'learn_words.dart'; // Import LearnWordsPage
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class SpellWordPage extends StatefulWidget {
  final String grade;

  const SpellWordPage({Key? key, required this.grade}) : super(key: key);

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
  }

  Future<void> loadStoredWords() async {
    final prefs = await SharedPreferences.getInstance();
    final storedWords = prefs.getString('words${widget.grade}');

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
   // final headers = {'Content-Type': 'application/json'};
    final body = {'grade': widget.grade};

    // Check internet connectivity
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      // No internet connection, silently terminate
      setState(() {
        isLoading = false; // Stop loading indicator
      });
      return;
    }

    try {
      // Make the request with a timeout
      final response = await http.post(url,
         // headers: headers,
          body: body); //.timeout(const Duration(seconds: 30));
      if (response.statusCode == 200) {
       // print(response.body);
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
        // Handle non-200 responses if necessary
        setState(() {
          isLoading = false; // Stop loading indicator
        });
      }
    } catch (e) {
      // Handle timeout and other errors silently
      setState(() {
        isLoading = false; // Stop loading indicator
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
      List<Map<String, dynamic>> moduleWords, moduleIndex) {
    moduleIndex++;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LearnWordsPage(
            moduleWords: moduleWords, moduleIndex: moduleIndex.toString()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Grade ${widget.grade} Spelling Words')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : error.isNotEmpty
              ? Center(child: Text(error))
              : ListView.builder(
                  padding: EdgeInsets.all(8.0),
                  itemCount: modules.length,
                  itemBuilder: (context, moduleIndex) {
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                        title: Text('Module ${moduleIndex + 1}'),
                        onTap: () => navigateToLearnWordsPage(
                            modules[moduleIndex], moduleIndex),
                      ),
                    );
                  },
                ),
    );
  }
}
