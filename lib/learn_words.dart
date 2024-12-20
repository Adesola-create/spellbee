import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'spell_quiz.dart';

class LearnWordsPage extends StatefulWidget {
  final List<Map<String, dynamic>> moduleWords;
  final String moduleIndex;

  const LearnWordsPage(
      {super.key, required this.moduleWords, required this.moduleIndex});

  @override
  _LearnWordsPageState createState() => _LearnWordsPageState();
}

class _LearnWordsPageState extends State<LearnWordsPage> {
  final FlutterTts flutterTts = FlutterTts();
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    // Automatically speak the first word when the page loads
    _speak(widget.moduleWords[currentIndex]['word']);
  }

  Future<void> _speak(String text) async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.speak(text);
  }

  void _nextWord() {
    setState(() {
      if (currentIndex < widget.moduleWords.length - 1) {
        currentIndex++;
        // Automatically speak the next word
        _speak(widget.moduleWords[currentIndex]['word']);
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SpellQuizPage(
              moduleWords: widget.moduleWords,
              moduleIndex: widget.moduleIndex,
            ),
          ),
        );
      }
    });
  }

  void _previousWord() {
    setState(() {
      if (currentIndex > 0) {
        currentIndex--;
        // Automatically speak the previous word
        _speak(widget.moduleWords[currentIndex]['word']);
      }
    });
  }

  Widget buildInfoCard(
      String title, String content, Color borderColor, Color backgroundColor) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
        side: BorderSide(color: borderColor, width: 2),
      ),
      color: backgroundColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: borderColor),
                ),
                IconButton(
                  icon: Icon(Icons.volume_up, color: borderColor),
                  onPressed: () => _speak(content),
                ),
              ],
            ),
            Text(content, style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }

  Widget buildWordCard(
      String title, String content, Color borderColor, Color backgroundColor) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
        side: BorderSide(color: borderColor, width: 2),
      ),
      color: backgroundColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: borderColor),
                ),
                IconButton(
                  icon: Icon(Icons.volume_up, color: borderColor),
                  onPressed: () => _speak(content),
                ),
              ],
            ),
            Text(content,
                style: const TextStyle(
                    fontSize: 22, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget buildImageCard(String imageUrl, BuildContext context) {
    double cardHeight = MediaQuery.of(context).size.height * 2 / 5;

    return GestureDetector(
      // Detect swipe gestures
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity! < 0) {
          // Swipe left to move to the next word
          _nextWord();
        } else if (details.primaryVelocity! > 0) {
          // Swipe right to move to the previous word
          _previousWord();
        }
      },
      child: SizedBox(
        height: cardHeight,
        width: MediaQuery.of(context).size.width, // Full width
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10), // Match card border radius
            child: imageUrl.isNotEmpty
                ? Image.network(
                    imageUrl,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) return child;
                      return const Center(
                        child: CircularProgressIndicator(), // Loading indicator
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Text(
                          'Image not available',
                          style: TextStyle(color: Colors.red),
                        ),
                      );
                    },
                  )
                : const Center(
                    child: Text(
                      'No image URL provided',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final wordData = widget.moduleWords[currentIndex];

    return Scaffold(
  appBar: AppBar(
  title: Text('Module ${widget.moduleIndex}',style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold)),
  elevation: 0, // No shadow for seamless design
  actions: [
    Padding(
      padding: const EdgeInsets.only(right: 16.0), // Add some padding
      child: Center(
        child: Text(
          '${currentIndex+1} OF ${widget.moduleWords.length}', // Display currentIndex or moduleIndex
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
           // color: Colors.white, // Change color if needed
          ),
        ),
      ),
    ),
  ],
),

      body: Stack(
        children: [
          // Main Content
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image card directly under the AppBar with swipe gestures
              buildImageCard(
                wordData['image'] ?? '',
                context,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Word Card
                        buildWordCard(
                          'WORD',
                          wordData['word'].toUpperCase(),
                          Colors.orange,
                          Colors.orange.shade50,
                        ),
                        // Meaning Card
                        buildInfoCard(
                          'MEANING',
                          wordData['meaning'],
                          Colors.blue,
                          Colors.blue.shade50,
                        ),
                        // Sentence Card
                        buildInfoCard(
                          'SAMPLE SENTENCE',
                          wordData['sentence'],
                          Colors.green,
                          Colors.green.shade50,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Previous Button
            ElevatedButton(
              onPressed: currentIndex > 0 ? _previousWord : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple, // Purple background color
                foregroundColor: Colors.white, // White text color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8), // Rounded corners
                ),
                padding: const EdgeInsets.symmetric(
                    horizontal: 24, vertical: 12), // Button padding
              ),
              child: const Text('Previous', style: TextStyle(fontSize: 18)),
            ),
            // Next Button
            ElevatedButton(
              onPressed: _nextWord,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple, // Purple background color
                foregroundColor: Colors.white, // White text color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8), // Rounded corners
                ),
                padding: const EdgeInsets.symmetric(
                    horizontal: 24, vertical: 12), // Button padding
              ),
              child: Text(
                currentIndex < widget.moduleWords.length - 1
                    ? 'Next'
                    : 'Quiz',
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
