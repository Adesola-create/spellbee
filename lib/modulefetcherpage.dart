import 'package:flutter/material.dart';
import 'package:spellbee/spell_quiz.dart'; // Import the page
import 'dart:convert';
import 'package:http/http.dart' as http;

class ModuleFetcherPage extends StatefulWidget {
  const ModuleFetcherPage({Key? key}) : super(key: key);

  @override
  _ModuleFetcherPageState createState() => _ModuleFetcherPageState();
}

class _ModuleFetcherPageState extends State<ModuleFetcherPage> {
  late Future<List<Map<String, dynamic>>> moduleWords;

  Future<List<Map<String, dynamic>>> fetchModules() async {
    final response = await http.get(Uri.parse('https://spellbee.braveiq.net/v1/getspellgrade/modules'));

    if (response.statusCode == 200) {
      // Assuming the API returns a list of modules
      List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => item as Map<String, dynamic>).toList();
    } else {
      throw Exception('Failed to load modules');
    }
  }

  @override
  void initState() {
    super.initState();
    moduleWords = fetchModules(); // Fetch data on init
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Module Fetcher'),
        backgroundColor: Colors.purple,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: moduleWords,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No Modules Available'));
          } else {
            // Pass the fetched modules to SpellQuizPage
            return SpellQuizPage(
              moduleWords: snapshot.data!,
              moduleIndex: '1', // Pass module index or any other relevant value
            );
          }
        },
      ),
    );
  }
}
