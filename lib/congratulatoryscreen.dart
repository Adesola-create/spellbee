import 'package:flutter/material.dart';
import 'package:spellbee/spell_grade.dart';
// For animations

class CongratulationsScreen extends StatelessWidget {
  const CongratulationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Congratulations!',style: TextStyle(fontSize: 20, color: Colors.white),),
        backgroundColor: Colors.purple,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Lottie Animation for Ribbons/Confetti
            Image(
              image: AssetImage(
                  'assets/images/animation.gif'), // Ensure you have this animation
              width: 300,
              height: 300,
              fit: BoxFit.cover,
              
            ),
            const SizedBox(height: 20),
            // Celebration Text
            const Text(
              '🎉 Congratulations! 🎉',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.purple,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            // Sub-text
            const Text(
              'You have successfully completed all the modules for this grade!',
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            // Home Button
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SpellGradePage(),),
                );
                
              },
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                backgroundColor: Colors.purple,
              ),
              child: const Text(
                'Back to Home',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
