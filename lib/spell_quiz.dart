import 'package:flutter/material.dart';

class SpellQuizPage extends StatefulWidget {
  final List<Map<String, dynamic>> moduleWords;
  final String moduleIndex;

  const SpellQuizPage({Key? key, required this.moduleWords, required this.moduleIndex}) : super(key: key);

  @override
  _SpellQuizPageState createState() => _SpellQuizPageState();
}

class _SpellQuizPageState extends State<SpellQuizPage> {
  int currentQuestionIndex = 0;
  int score = 0;
  List<String?> selectedOptions = [];
  List<List<String>> optionsForQuestions = [];
  List<bool> isQuestionScored = [];

  @override
  void initState() {
    super.initState();
    selectedOptions = List<String?>.filled(widget.moduleWords.length, null);
    isQuestionScored = List<bool>.filled(widget.moduleWords.length, false);
    _initializeOptions();
  }

  void _initializeOptions() {
    optionsForQuestions = widget.moduleWords.map((wordData) {
      List<String> options = List<String>.from(wordData['spellings'].split(',').map((s) => s.trim()));
      options.shuffle();
      return options;
    }).toList();
  }

  void _nextQuestion() {
    setState(() {
      if (selectedOptions[currentQuestionIndex] == widget.moduleWords[currentQuestionIndex]['word'] &&
          !isQuestionScored[currentQuestionIndex]) {
        score++;
        isQuestionScored[currentQuestionIndex] = true;
      }
      if (currentQuestionIndex < widget.moduleWords.length - 1) {
        currentQuestionIndex++;
      } else {
        _showScoreDialog();
      }
    });
  }

  void _previousQuestion() {
    setState(() {
      if (currentQuestionIndex > 0) {
        currentQuestionIndex--;
      }
    });
  }

  void _showScoreDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Quiz Completed'),
        content: Text('Your score is $score out of ${widget.moduleWords.length}.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final wordData = widget.moduleWords[currentQuestionIndex];
    final selectedOption = selectedOptions[currentQuestionIndex];
    final shuffledOptions = optionsForQuestions[currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Module ${widget.moduleIndex} Quiz',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.purple,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.purple, // Purple background
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 86),
              Text(
                'Choose the correct spelling for:',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // White text color
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                wordData['meaning'],
                style: const TextStyle(fontSize: 24, color: Colors.white), // White text color
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView(
                  children: shuffledOptions.map((spelling) {
                    bool isSelected = selectedOption == spelling;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedOptions[currentQuestionIndex] = spelling;
                        });
                      },
                      child: Card(
                        color: isSelected ? Colors.white : Colors.purple.shade300,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          side: BorderSide(
                            color: isSelected ? Colors.white : Colors.white,
                            width: 2,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            spelling,
                            style: TextStyle(
                              fontSize: 26,
                              color: isSelected ? Colors.purple : Colors.white, // Contrast text
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.purple, // Purple background
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              onPressed: currentQuestionIndex > 0 ? _previousQuestion : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white, // White background
                foregroundColor: Colors.purple, // Purple text
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text('Previous', style: TextStyle(fontSize: 18)),
            ),
            ElevatedButton(
              onPressed: selectedOptions[currentQuestionIndex] != null ? _nextQuestion : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white, // White background
                foregroundColor: Colors.purple, // Purple text
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: Text(currentQuestionIndex < widget.moduleWords.length - 1 ? 'Next' : 'Submit', style: TextStyle(fontSize: 18),),
            ),
          ],
        ),
      ),
    );
  }
}
