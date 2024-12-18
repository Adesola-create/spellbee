import 'package:flutter/material.dart';

class FAQPage extends StatelessWidget {
  final List<Map<String, String>> faqs = [
    {
      "question": "What is this app about?",
      "answer": "This app helps you improve your spelling skills through quizzes and learning modules."
    },
    {
      "question": "How do I start a spelling quiz?",
      "answer": "Navigate to the quiz section, select a module, and follow the instructions to begin the quiz."
    },
    {
      "question": "Can I track my progress?",
      "answer": "Yes, the app allows you to view your progress in the stats or progress section."
    },
    {
      "question": "How do I learn new words?",
      "answer": "Go to the 'Learn Words' section, where you can explore words, their meanings, and examples in sentences."
    },
    {
      "question": "Is the app suitable for all age groups?",
      "answer": "Yes, the app is designed to help both children and adults improve their spelling skills."
    },
    {
      "question": "Can I use this app offline?",
      "answer": "Certain features, like learning modules, can be used offline, but quizzes may require an internet connection."
    },
    {
      "question": "How do I report a problem or give feedback?",
      "answer": "You can report issues or provide feedback through the 'Contact Us' section in the app settings."
    },
  ];

   FAQPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("FAQ"),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: faqs.length,
          itemBuilder: (context, index) {
            final faq = faqs[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              elevation: 4,
              child: ExpansionTile(
                title: Text(
                  faq["question"]!,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      faq["answer"]!,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
