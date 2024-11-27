import 'package:flutter/material.dart';
import 'package:spellbee/home_page.dart';
//import 'package:spellbee/spell_grade.dart';
import 'spell_word.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'history_model.dart';
import 'package:intl/intl.dart';
//import 'dart:convert';
import 'package:http/http.dart' as http;
//import 'dart:io';

class QuizHistoryManager {
  static const String _historyKey = 'quiz_history';

  // Save quiz history
  static Future<void> saveQuizHistory(QuizHistory history) async {
    final prefs = await SharedPreferences.getInstance();

    // Retrieve existing history
    final historyList = await getQuizHistory();

    // Add the new history
    historyList.add(history);

    // Save updated history
    final encodedList = historyList.map((e) => e.toJson()).toList();
    prefs.setStringList(_historyKey, encodedList);

    // Attempt to send history to the server
    await sendPendingHistory();
  }

  // Retrieve quiz history
  static Future<List<QuizHistory>> getQuizHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final historyData = prefs.getStringList(_historyKey) ?? [];
   // print('Retrieved history data: $historyData');
    return historyData.map((e) => QuizHistory.fromJson(e)).toList();
  }

  // Send unsent quiz history to the server
  static Future<void> sendPendingHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final historyList = await getQuizHistory();

    for (final history in historyList.where((h) => !h.sentStatus)) {
      try {
        final response = await http.post(
          Uri.parse('https://spellbee.braveiq.net/v1/history'),
          headers: {'Content-Type': 'application/json'},
          body: history.toJson(),
        );

        if (response.statusCode == 200) {
          history.sentStatus = true; // Mark as sent
        }
      } catch (e) {
        // Handle network error silently
      }
    }

    // Save updated history
    final updatedList = historyList.map((e) => e.toJson()).toList();
    prefs.setStringList(_historyKey, updatedList);
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
    Key? key,
    required this.moduleWords,
    required this.moduleIndex,
  }) : super(key: key);

  @override
  _SpellQuizPageState createState() => _SpellQuizPageState();
}

class _SpellQuizPageState extends State<SpellQuizPage> {
  int currentQuestionIndex = 0;
  int score = 0;
  bool hasAnswered = false;
  List<String> currentOptions = [];

  @override
  void initState() {
    super.initState();
    _loadQuestion();
    QuizHistoryManager.sendPendingHistory();
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

      final quizHistory = QuizHistory(
        date: DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
        grade: grade,
        module: widget.moduleIndex,
        percentScore: (score / widget.moduleWords.length) * 100,
        length: widget.moduleWords.length,
        sentStatus: false, // Initially not sent
      );

      // Save passed module index if passed (>= 80%)
if ((score / widget.moduleWords.length) * 100 >= 80) {
  final passedModulesKey = 'passedGrade$grade';
  final existingModules = prefs.getStringList(passedModulesKey) ?? [];
  
  // Parse moduleIndex and increment by 1
  final incrementedModuleIndex = (int.parse(widget.moduleIndex) + 1).toString();

  // Check if the module is already saved
  if (!existingModules.contains(incrementedModuleIndex)) {
    existingModules.add(incrementedModuleIndex); // Add the incremented module index
    existingModules.sort((a, b) => int.parse(a).compareTo(int.parse(b))); // Sort for consistency
    prefs.setStringList(passedModulesKey, existingModules); // Save updated list
  }
}


      await QuizHistoryManager.saveQuizHistory(quizHistory);
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
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final wordData = widget.moduleWords[currentQuestionIndex];
    final String correctAnswer = wordData['word'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Module ${widget.moduleIndex} Quiz'),
        backgroundColor: Colors.purple,
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
            Text(
              'Choose the correct spelling for:',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
      bottomNavigationBar:
          currentQuestionIndex == widget.moduleWords.length - 1 && hasAnswered
              ? Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: _showResults,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      backgroundColor: Colors.purple,
                    ),
                    child: const Text(
                      'Submit',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                )
              : const SizedBox.shrink(),
    );
  }
}

class QuizResultPage extends StatelessWidget {
  final int score;
  final int totalQuestions;
  final List<Map<String, dynamic>> moduleWords;
  final String moduleIndex;

  const QuizResultPage({
    Key? key,
    required this.score,
    required this.totalQuestions,
    required this.moduleWords, // Ensure this is required
    required this.moduleIndex, // And moduleIndex as well
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool passed = score / totalQuestions >=
        0.8; // Pass if score is greater than or equal to 8
    double percentage = (score / totalQuestions) * 100;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Results'),
        backgroundColor: Colors.purple,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Your Score',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomePage(),
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
