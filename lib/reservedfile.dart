import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'spell_quiz.dart';

class LearnWordsPage extends StatefulWidget {
  final List<Map<String, dynamic>> moduleWords;
  final String moduleIndex;

  const LearnWordsPage(
      {Key? key, required this.moduleWords, required this.moduleIndex})
      : super(key: key);

  @override
  _LearnWordsPageState createState() => _LearnWordsPageState();
}

class _LearnWordsPageState extends State<LearnWordsPage> {
  final FlutterTts flutterTts = FlutterTts();
  int currentIndex = 0;

  Future<void> _speak(String text) async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.speak(text);
  }

  void _nextWord() {
    setState(() {
      if (currentIndex < widget.moduleWords.length - 1) {
        currentIndex++;
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
      }
    });
  }

  Widget buildInfoCard(
      String title, String content, Color borderColor, Color backgroundColor) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
        side: BorderSide(color: borderColor, width: 2),
      ),
      color: backgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
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
            SizedBox(height: 8),
            Text(content, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  Widget buildWordCard(String label, String imagePath, BuildContext context) {
    // Get the height of 2/5 of the screen
    double cardHeight = MediaQuery.of(context).size.height * 2 / 5;

    return SizedBox(
      height: cardHeight, // Set the height dynamically
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                // Expand the image to take up remaining space
                child: ClipRRect(
                  borderRadius:
                      BorderRadius.circular(10), // Match card border radius
                  child: Image.asset(
                    'assets/images/bg7.jpeg', // Pass the image path dynamically
                    width: double
                        .infinity, // Ensure the image fills the card width
                    fit: BoxFit.cover, // Adjust image fit within the container
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Text(
                          'Image not available',
                          style: TextStyle(color: Colors.red),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

//  Widget buildWordCard(String label, String imagePath) {
//   return SizedBox(
//     height: 300, // Set the desired height
//     child: Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Text(
//               label,
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black87,
//               ),
//             ),
//             const SizedBox(height: 16),
//             // Use Image.asset to load local image
//             Image.asset(
//               'assets/images/bg7.jpeg', // Pass the local image path
//               height: 200, // Adjust the image height
//               fit: BoxFit.cover, // Adjust the image's fit within the container
//               errorBuilder: (context, error, stackTrace) {
//                 return const Text(
//                   'Image not available',
//                   style: TextStyle(color: Colors.red),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     ),
//   );
// }

  /*  Widget buildWordCard(String title, String content) {
    return Container(
      width: double.infinity, // full width
      height: 200, // adjust height as needed
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/bg7.jpeg'), // replace with your image path
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 8.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
          side: BorderSide(color: Colors.deepPurple, width: 2),
        ),
        color: Colors.transparent, // make card background transparent
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 18, color: Colors.deepPurple),
                  ),
                  IconButton(
                    icon: Icon(Icons.volume_up, color: Colors.deepPurple),
                    onPressed: () => _speak(content),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Center(
                child: Text(
                  content,
                  style: TextStyle(fontSize: 38, fontWeight: FontWeight.bold, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
 */
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
        title: Text('Module ${widget.moduleIndex}'),
        actions: [
          IconButton(
            icon: Icon(Icons.quiz),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SpellQuizPage(
                      moduleWords: widget.moduleWords,
                      moduleIndex: widget.moduleIndex),
                ),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'assets/images/bigbg.jpg'), // replace with your image path
            fit: BoxFit.cover,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Word Card
            buildWordCard(
              'WORD IMAGE',
              wordData['imageUrl'] ?? '', // Fallback to an empty string if null
              context,
            ),

            // My word Card
            buildInfoCard(
              'WORD',
              wordData['word'].toUpperCase(),
              Colors.yellow,
              Colors.yellow.shade50,
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
              'SAMPLESENTENCE',
              wordData['sentence'],
              Colors.green,
              Colors.green.shade50,
            ),
            // Spellings Card
            /* buildInfoCard(
              'SPELLINGS',
              wordData['spellings'].toString(),
              Colors.orange,
              Colors.orange.shade50,
            ), */
            SizedBox(height: 20),
            // Navigation Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: currentIndex > 0 ? _previousWord : null,
                  child: Text('Previous'),
                ),
                ElevatedButton(
                  onPressed: _nextWord,
                  child: Text(currentIndex < widget.moduleWords.length - 1
                      ? 'Next'
                      : 'Quiz'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
