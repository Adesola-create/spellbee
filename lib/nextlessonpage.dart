import 'package:flutter/material.dart';

class NextLessonPage extends StatelessWidget {
  const NextLessonPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Next Lesson'),
        backgroundColor: Colors.purple,
      ),
      body: const Center(
        child: Text(
          'This is the next lesson page!',
          style: TextStyle(fontSize: 24, color: Colors.purple),
        ),
      ),
    );
  }
}
