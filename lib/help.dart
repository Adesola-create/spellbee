import 'package:flutter/material.dart';

class HelpAndSupportPage extends StatelessWidget {
  final List<Map<String, String>> faqs = [
    {
      'question': 'How do I start using the app?',
      'answer':
          'To start using the app, select a module from the home screen and follow the learning or quiz instructions provided.'
    },
    {
      'question': 'How do I take a spelling quiz?',
      'answer':
          'To take a spelling quiz, navigate to the module of your choice and complete the learning section first. Once ready, click on the "Start Quiz" button.'
    },
    {
      'question': 'Can I reset my progress?',
      'answer':
          'Currently, there is no option to reset progress directly. However, you can restart modules or quizzes as many times as you want.'
    },
    {
      'question': 'Why is the audio not working?',
      'answer':
          'Ensure your device volume is turned on and the app has permission to access your device’s audio features.'
    },
    {
      'question': 'How can I contact support?',
      'answer':
          'You can reach our support team via email at support@wordpro.com. We aim to respond within 24 hours.'
    },
  ];

   HelpAndSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support', style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.purple,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // const Text(
              //   'Help & Support',
              //   style: TextStyle(
              //     fontSize: 24,
              //     fontWeight: FontWeight.bold,
              //     color: Colors.black87,
              //   ),
              // ),
              const SizedBox(height: 16),
              const Text(
                'If you have questions or need assistance, please refer to the FAQs below or contact our support team.',
                style: TextStyle(fontSize: 16, color: Colors.black87, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              const Text(
                'FAQs',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple,
                ),
              ),
              const SizedBox(height: 16),
              ...faqs.map((faq) => _buildFAQCard(faq)),
              const SizedBox(height: 24),
              const Text(
                'Contact Us',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'If your question isn’t answered here, feel free to contact us at:',
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              const SizedBox(height: 8),
              const Row(
                children: [
                  Icon(Icons.email, color: Colors.purple),
                  SizedBox(width: 8),
                  Text(
                    'support@wordpro.com',
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Row(
                children: [
                  Icon(Icons.help_outline, color: Colors.purple),
                  SizedBox(width: 8),
                  Text(
                    'Visit our FAQ section for more help.',
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFAQCard(Map<String, String> faq) {
    return ExpansionTile(
      title: Text(
        faq['question']!,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.purple,
        ),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            faq['answer']!,
            style: const TextStyle(fontSize: 16, color: Colors.black87),
          ),
        ),
      ],
    );
  }
}
