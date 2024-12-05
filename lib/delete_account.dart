import 'package:flutter/material.dart';

class DeleteAccountPage extends StatelessWidget {
  const DeleteAccountPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
      ),
      body: Center(
        child: Text('Account'),
      ),
    );
  }
}