
import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(WordPuzzleGame());
}

class WordPuzzleGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Word Puzzle Game',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: GamePage(),
    );
  }
}

class GamePage extends StatefulWidget {
  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  final List<List<String>> wordLists = [
    ['CAT', 'DOG', 'MOUSE', 'FISH', 'BIRD', 'LION', 'TIGER', 'BEAR', 'WOLF', 'FROG'],
    ['APPLE', 'BANANA', 'CHERRY', 'DATE', 'ELDERBERRY', 'FIG', 'GRAPE', 'HONEYDEW', 'KIWI', 'LEMON'],
    // Add more lists as needed
  ];

  List<String> currentWords = [];
  List<String> currentPuzzle = [];
  Set<String> foundWords = {};
  bool isGameCompleted = false;

  @override
  void initState() {
    super.initState();
    startNewLevel();
  }

  void startNewLevel() {
    currentWords = wordLists[Random().nextInt(wordLists.length)];
    currentPuzzle = generatePuzzle(currentWords);
    foundWords.clear();
    isGameCompleted = false;
    setState(() {});
  }

  List<String> generatePuzzle(List<String> words) {
    List<String> puzzleGrid = List.generate(64, (index) => String.fromCharCode(Random().nextInt(26) + 65));

    // Place words in the grid
    for (String word in words) {
      placeWordInPuzzle(word, puzzleGrid);
    }
    return puzzleGrid;
  }

  void placeWordInPuzzle(String word, List<String> puzzleGrid) {
    bool placed = false;
    while (!placed) {
      int direction = Random().nextInt(3); // 0: horizontal, 1: vertical, 2: diagonal
      int row = Random().nextInt(8);
      int col = Random().nextInt(8);

      if (direction == 0 && col <= 8 - word.length) { // Horizontal
        for (int i = 0; i < word.length; i++) {
          puzzleGrid[row * 8 + (col + i)] = word[i];
        }
        placed = true;
      } else if (direction == 1 && row <= 8 - word.length) { // Vertical
        for (int i = 0; i < word.length; i++) {
          puzzleGrid[(row + i) * 8 + col] = word[i];
        }
        placed = true;
      } else if (direction == 2 && row <= 8 - word.length && col <= 8 - word.length) { // Diagonal
        for (int i = 0; i < word.length; i++) {
          puzzleGrid[(row + i) * 8 + (col + i)] = word[i];
        }
        placed = true;
      }
    }
  }

  void checkWord(List<int> selectedIndices) {
    String formedWord = selectedIndices.map((i) => currentPuzzle[i]).join();
    if (currentWords.contains(formedWord) && !foundWords.contains(formedWord)) {
      foundWords.add(formedWord);
      if (foundWords.length == currentWords.length) {
        setState(() {
          isGameCompleted = true;
        });
      }
      setState(() {});
    }
  }

  List<int> selectedIndices = [];

  void onSelect(int index) {
    if (selectedIndices.contains(index)) {
      selectedIndices.remove(index);
    } else {
      selectedIndices.add(index);
    }
    setState(() {});
  }

  void onCompleteSelection() {
    checkWord(selectedIndices);
    selectedIndices.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Word Puzzle Game')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (isGameCompleted)
              Column(
                children: [
                  Text('Congratulations! You found all the words!', style: TextStyle(fontSize: 20)),
                  ElevatedButton(
                    onPressed: startNewLevel,
                    child: Text('Start Next Level'),
                  ),
                ],
              ),
            if (!isGameCompleted) ...[
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 8,
                    childAspectRatio: 1,
                  ),
                  itemCount: currentPuzzle.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onPanUpdate: (details) {
                        // Check if the gesture is a valid selection
                        if (details.delta.dx != 0 || details.delta.dy != 0) {
                          onSelect(index);
                        }
                      },
                      onPanEnd: (details) {
                        // Complete the selection
                        onCompleteSelection();
                      },
                      child: Container(
                        margin: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: selectedIndices.contains(index)
                              ? Colors.yellow
                              : foundWords.contains(currentPuzzle[index])
                                  ? Colors.green
                                  : Colors.blue,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            currentPuzzle[index],
                            style: TextStyle(color: Colors.white, fontSize: 24),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}