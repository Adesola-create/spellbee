import 'package:flutter/material.dart';

class ExcercisePage extends StatelessWidget {
  const ExcercisePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Excercise'),
      ),
      body: Center(
        child: Text('Test Your Spelling Ability!'),
      ),
    );
  }
}