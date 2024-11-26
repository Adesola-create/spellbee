import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'spell_quiz.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';



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
           // const SizedBox(height: 8),
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
          //  const SizedBox(height: 8),
            Text(content, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }



Widget buildImageCard(String imageUrl, BuildContext context) {
  double cardHeight = MediaQuery.of(context).size.height * 2 / 5;

  return FutureBuilder<File?>(
    future: _loadImage(imageUrl),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(
          child: CircularProgressIndicator(), // Loading indicator
        );
      }

      if (snapshot.hasError || snapshot.data == null) {
        return const Center(
          child: Text(
            'Image not available',
            style: TextStyle(color: Colors.red),
          ),
        );
      }

      return SizedBox(
        height: cardHeight,
        width: MediaQuery.of(context).size.width, // Full width
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10), // Match card border radius
            child: Image.file(
              snapshot.data!,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
        ),
      );
    },
  );
}

Future<File?> _loadImage(String imageUrl) async {
  if (imageUrl.isEmpty) return null;

  try {
    // Get local directory
    final directory = await getApplicationDocumentsDirectory();
    final fileName = Uri.parse(imageUrl).pathSegments.last; // Extract file name
    final localImagePath = '${directory.path}/$fileName';

    // Check if the image already exists locally
    final localImageFile = File(localImagePath);
    if (await localImageFile.exists()) {
      return localImageFile; // Return the locally saved file
    }

    // If not, download and save it locally
    final request = await HttpClient().getUrl(Uri.parse(imageUrl));
    final response = await request.close();

    // Read the response as bytes and save it locally
    final bytes = await consolidateHttpClientResponseBytes(response);
    await localImageFile.writeAsBytes(bytes);

    return localImageFile;
  } catch (e) {
    debugPrint('Error loading image: $e');
    return null; // Return null if there was an error
  }
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
      title: Text('Module ${widget.moduleIndex}'),
      elevation: 0, // No shadow for seamless design
    ),
    body: Stack(
      children: [
        // Main Content
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image card directly under the AppBar
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
                      //const SizedBox(height: 20),
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
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12), // Button padding
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
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12), // Button padding
        ),
        child: Text(
          currentIndex < widget.moduleWords.length - 1 ? 'Next' : 'Quiz', style: TextStyle(fontSize: 18),
        ),
      ),
    ],
  ),
),

  );
}

}
