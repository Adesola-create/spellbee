import 'dart:async';
import 'package:flutter/material.dart';
import 'home_page.dart';
import 'spell_word.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'history_model.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
//import 'dart:io';

class QuizHistoryManager {
  // Save quiz history
  static Future<void> saveQuizHistory(Map<String, dynamic> history) async {
    final prefs = await SharedPreferences.getInstance();

    // Retrieve existing history
    List<String> historyList = prefs.getStringList('quizHistoryLog') ?? [];
    //print('History List: $historyList');
    // Add the new history
    historyList.add(jsonEncode(history));

    // Save updated history
    await prefs.setStringList('quizHistoryLog', historyList);

    // Attempt to send pending history
    await sendPendingHistory();
  }

  // Retrieve quiz history
  static Future<List<Map<String, dynamic>>> getQuizHistory() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> historyData = prefs.getStringList('quizHistoryLog') ?? [];
    return historyData
        .map((e) => jsonDecode(e) as Map<String, dynamic>)
        .toList();
  }

  // Send unsent quiz history to the server
  static Future<void> sendPendingHistory() async {
    final prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> historyList = await getQuizHistory();

    for (var history in historyList.where((h) => h['sent'] == false)) {
      try {
        final response = await http.post(
          Uri.parse('https://spellbee.braveiq.net/v1/history'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(history),
        );

        if (response.statusCode == 200) {
          history['sent'] = true; // Mark as sent
          List<String> updatedList =
              historyList.map((e) => jsonEncode(e)).toList();
          if (history['length'] > 0) {
            await prefs.setStringList('quizHistoryLog', updatedList);
          }
        }
      } catch (e) {
        // Handle network error silently
      }
    }

    // Save updated history
  }
}

Future<void> navigateToSpellWordPage(
    BuildContext context, String moduleIndex) async {
  final prefs = await SharedPreferences.getInstance();
  final grade = prefs.getString('grade');

  if (grade != null) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SpellWordPage(
          grade: grade,
          newindex: int.parse(
              moduleIndex), // Automatically navigate to the specified module
        ),
      ),
    );
  } else {
    // Handle the case where the grade is not found
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Grade not found')),
    );
  }
}

class SpellQuizPage extends StatefulWidget {
  final List<Map<String, dynamic>> moduleWords;
  final String moduleIndex;

  const SpellQuizPage({
    super.key,
    required this.moduleWords,
    required this.moduleIndex,
  });

  @override
  _SpellQuizPageState createState() => _SpellQuizPageState();
}

class _SpellQuizPageState extends State<SpellQuizPage> {
  int currentQuestionIndex = 0;
  int score = 0;
  bool hasAnswered = false;
  List<String> currentOptions = [];
  final Stopwatch stopwatch = Stopwatch(); // Add stopwatch
  late Timer timer; // Timer to update the UI
  int elapsedSeconds = 0; // Time spent in seconds

  @override
  void initState() {
    super.initState();
    _loadQuestion();
    QuizHistoryManager.sendPendingHistory();
    stopwatch.start(); // Start the stopwatch when the quiz starts
    _startTimer(); // Start the timer to update elapsed time
  }

  @override
  void dispose() {
    stopwatch.stop(); // Stop the stopwatch when the page is disposed
    timer.cancel(); // Cancel the timer
    super.dispose();
  }

  /// Start a periodic timer to update the elapsed time
  void _startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        elapsedSeconds = stopwatch.elapsed.inSeconds; // Update elapsed time
      });
    });
  }

  /// Load the current question and shuffle options
  void _loadQuestion() {
    final wordData = widget.moduleWords[currentQuestionIndex];
    currentOptions = List<String>.from(
        wordData['spellings'].split(',').map((s) => s.trim()));
    currentOptions.shuffle(); // Shuffle options only once per question
  }

  void _handleAnswer(String selectedOption) {
    setState(() {
      hasAnswered = true;
      String correctAnswer = widget.moduleWords[currentQuestionIndex]['word'];
      if (selectedOption == correctAnswer) {
        score++;
      }
    });

    // Delay for feedback before moving to the next question
    Future.delayed(const Duration(seconds: 2), () {
      if (currentQuestionIndex < widget.moduleWords.length - 1) {
        setState(() {
          currentQuestionIndex++;
          hasAnswered = false;
          _loadQuestion(); // Load next question and shuffle options
        });
      } else {
        // Navigate to results screen
        _showResults();
      }
    });
  }

  void _showResults() {
    void saveQuizDetails() async {
      final prefs = await SharedPreferences.getInstance();
      final grade = prefs.getString('grade') ?? 'Unknown';

      stopwatch.stop(); // Stop the stopwatch at the end of the quiz
      timer.cancel(); // Stop the timer
      int timeSpentInSeconds = stopwatch.elapsed.inSeconds; // Get elapsed time

      final quizHistory = QuizHistory(
        date: DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
        grade: grade,
        module: widget.moduleIndex,
        percentScore: (score / widget.moduleWords.length) * 100,
        length: widget.moduleWords.length,
        sentStatus: false, // Initially not sent
        timeSpent: timeSpentInSeconds, // Save time spent in seconds
      );

      // Save passed module index if passed (>= 80%)
      if ((score / widget.moduleWords.length) * 100 >= 80) {
        final passedModulesKey = 'passedGrade$grade';
        final existingModules = prefs.getStringList(passedModulesKey) ?? [];

        // Parse moduleIndex and increment by 1
        final incrementedModuleIndex =
            (int.parse(widget.moduleIndex) + 1).toString();

        // Check if the module is already saved
        if (!existingModules.contains(incrementedModuleIndex)) {
          existingModules
              .add(incrementedModuleIndex); // Add the incremented module index
          existingModules.sort((a, b) =>
              int.parse(a).compareTo(int.parse(b))); // Sort for consistency
          prefs.setStringList(
              passedModulesKey, existingModules); // Save updated list
        }
      }

      await QuizHistoryManager.saveQuizHistory(quizHistory.toMap());
    }

    saveQuizDetails();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuizResultPage(
          score: score,
          totalQuestions: widget.moduleWords.length,
          moduleWords: widget.moduleWords, // Pass moduleWords here
          moduleIndex: widget.moduleIndex, // Also pass moduleIndex
          timeSpent: stopwatch.elapsed.inSeconds,
        ),
      ),
    );
  }

  /// Format elapsed time into "MM:SS"
  String _formatElapsedTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final wordData = widget.moduleWords[currentQuestionIndex];
    final String correctAnswer = wordData['word'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Module ${widget.moduleIndex} Quiz'),
        backgroundColor: Colors.purple,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Center(
              child: Text(
                _formatElapsedTime(elapsedSeconds), // Display elapsed time
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),
            Text(
              'Question ${currentQuestionIndex + 1}/${widget.moduleWords.length}',
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Text(
              'Choose the correct spelling for:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              wordData['meaning'],
              style: const TextStyle(fontSize: 24),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Expanded(
              child: ListView(
                children: currentOptions.map((option) {
                  bool isCorrect = option == correctAnswer;
                  bool isSelected = hasAnswered && option == correctAnswer;
                  bool isWrongSelection = hasAnswered &&
                      option != correctAnswer &&
                      option ==
                          widget.moduleWords[currentQuestionIndex]['selected'];

                  return GestureDetector(
                    onTap: hasAnswered
                        ? null // Disable selection after answering
                        : () {
                            setState(() {
                              widget.moduleWords[currentQuestionIndex]
                                  ['selected'] = option;
                            });
                            _handleAnswer(option);
                          },
                    child: Card(
                      color: isSelected
                          ? Colors.green
                          : isWrongSelection
                              ? Colors.red
                              : Colors.white,
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              side: BorderSide(
                                color: Colors.grey, // Border color
                                width: 2.0, // Border width
                              ),
                            ),
                        title: Text(
                          option,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            color: hasAnswered && isCorrect
                                ? Colors.white
                                : isWrongSelection
                                    ? Colors.white
                                    : Colors.black,
                          ),
                        ),
                        trailing: hasAnswered
                            ? isCorrect
                                ? const Icon(Icons.check, color: Colors.white)
                                : isWrongSelection
                                    ? const Icon(Icons.close,
                                        color: Colors.white)
                                    : null
                            : null,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class QuizResultPage extends StatelessWidget {
  final int score;
  final int totalQuestions;
  final List<Map<String, dynamic>> moduleWords;
  final String moduleIndex;
  final int timeSpent; // Add timeSpent parameter

  const QuizResultPage({
    super.key,
    required this.score,
    required this.totalQuestions,
    required this.moduleWords, // Ensure this is required
    required this.moduleIndex, // And moduleIndex as well
    required this.timeSpent, // Pass time spent
  });

  @override
  Widget build(BuildContext context) {
    bool passed = score / totalQuestions >=
        0.8; // Pass if score is greater than or equal to 8
    double percentage = (score / totalQuestions) * 100;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Results', style: TextStyle(fontSize: 22),),
       // backgroundColor: Colors.purple,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Your Score',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              '$score/$totalQuestions',
              style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple),
            ),
            Text(
              '${percentage.toString()}%',
              style: const TextStyle(
                  fontSize: 52,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Text(
              'Time Spent: ${Duration(seconds: timeSpent).inMinutes} min ${Duration(seconds: timeSpent).inSeconds % 60} sec',
              style: const TextStyle(fontSize: 18, color: Colors.black),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomePage(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 16),
                    backgroundColor: Colors.purple,
                  ),
                  child: const Text('Back to Home',
                      style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () async {
                    if (passed) {
                      await navigateToSpellWordPage(
                          context, moduleIndex); // Pass `moduleIndex` directly
                    } else {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SpellQuizPage(
                            moduleWords: moduleWords,
                            moduleIndex: moduleIndex,
                          ),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 16),
                    backgroundColor: passed ? Colors.green : Colors.orange,
                  ),
                  child: Text(
                    passed ? 'Next Lesson' : 'Retake Quiz',
                    style: const TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
