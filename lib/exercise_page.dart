import 'package:flutter/material.dart';

class ExcercisePage extends StatelessWidget {
  const ExcercisePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Excercise'),
      ),
      body: const Center(
        child: Text('Test Your Spelling Ability!'),
      ),
    );
  }
}