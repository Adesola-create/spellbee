import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constants.dart';
import 'faq_page.dart';

class HelpPage extends StatefulWidget {
  const HelpPage({super.key});

  @override
  _HelpPageState createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  final List<Map<String, String>> helpSections = [
    {
      'title': 'Getting Started',
      'content':
          'If you\'re new to WordPro, we\'re here to help you set up and start benefiting from all that our platform has to offer.\n\nCreating an Account: Sign up for WordPro in just a few steps. Simply download the app, open it, and select "Create Account." You’ll be asked for basic information like your name, email, and a password.\n\nNavigating the App: Our interface is designed for simplicity. The main dashboard provides access to all key features: Practice Questions, Performance Analysis, and more. Explore each feature by tapping on the icons and discover how WordPro can help you reach your academic goals.\n\nSetting Up Your Profile: Personalize your profile with details like your subjects, target exams, and study goals. This allows WordPro to deliver a tailored learning experience that meets your unique needs.',
    },
   {
  'title': 'Account Management',
  'content':
      'Updating Account Information: To update your name, email, or password, go to "Settings" and select "Account Info." Make sure to save changes to keep your profile up-to-date.\n\nResetting Your Password: If you forgot your password, click on "Forgot Password" on the login screen. We’ll email you instructions to reset it. Be sure to use a strong password to keep your account secure.\n\nManaging Subscriptions: View or update your subscription plan under "Settings" > "Subscription." You can also cancel or change plans here. For any billing inquiries, feel free to contact our support team.',
},

    {
  'title': 'Using WordPro\'s Features',
  'content':
      'Accessing Practice Questions: Our extensive question bank is available under the "Practice" section. You can filter questions by subject, topic, or difficulty level. Start practicing and improve your skills at your own pace.\n\nViewing Performance Analysis: After each practice session, access a detailed analysis of your results in "Performance Analysis." This feature provides insights on accuracy, speed, and areas for improvement.\n\nSetting Study Goals: Under "Goals," set specific learning objectives and track your progress toward them. BraveIQ will remind you of your goals and keep you motivated as you reach new milestones.\n\nExam Simulation Mode: Get a feel for real exam conditions with our "Exam Simulation" feature. Timed practice sessions help you prepare for the pressure and pace of exam day, so you can build confidence and improve time management.',
},

  {
  'title': 'Troubleshooting Common Issues',
  'content':
      'App Not Loading: If BraveIQ isn\'t loading, ensure you\'re connected to the internet. Restart the app, and if the issue persists, clear your app cache in the device settings.\n\nPractice Questions Not Saving: If your progress isn’t saving, confirm that you’re logged in and check your internet connection. If the issue continues, try reinstalling the app.\n\nSubscription Issues: If you’re experiencing subscription issues, verify your payment method and check that your plan hasn’t expired. For further assistance, reach out to support via the contact information below.',
},

   {
  'title': 'Contact Support',
  'content':
      'Need Help? Reach Out to Us: Our support team is here to answer your questions and resolve any issues you may have.\n\nEmail Support: Email us at support@braveiq.net and a member of our team will respond within 24-48 hours.\n\nLive Chat: Access live chat support directly through the app during business hours (Monday to Friday, 9 AM - 6 PM). Go to "Settings" > "Help & Support" and tap on "Chat with Us."',
},

  ];

  void navigateToFAQ() {
   // Navigate to the FAQ page
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FAQPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
   const SizedBox(height: 12),
                // FAQ Card with navigation button
              Card(
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(
                    color: Colors.grey,
                    width: 1.0,
                  ),
                ),
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Frequently Asked Questions (FAQ)',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Have questions? Find answers to frequently asked questions on our FAQ page.',
                        style: TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: navigateToFAQ,
                        style: ElevatedButton.styleFrom(
                           side: const BorderSide(color: Colors.grey, width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 55),
                        ),
                        child: const Text(
                          'Go to FAQ',
                           style: TextStyle(color: primaryColor),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Help Section Cards
              const Text(
                'Explore Help Topics:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Column(
                children: helpSections.map((section) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(
                        color: Colors.grey, // Set border color
                        width: 1.0, // Set border width
                      ),
                    ),
                    elevation: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            section['title']!,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            section['content']!,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),

            

              const SizedBox(height: 22),
            ],
          ),
        ),
      ),

      // Call and Chat Buttons (static at the bottom)
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () async {
                  final Uri callUri =
                      Uri(scheme: 'tel', path: '+2348032716283');
                  if (await canLaunchUrl(callUri)) {
                    await launchUrl(callUri);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Unable to make a call.')),
                    );
                  }
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: primaryColor, width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Call Us',
                  style: TextStyle(color: primaryColor),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: () async {
                  final prefs = await SharedPreferences.getInstance();
                  final String? userId = prefs.getString('userId');
                  final Uri whatsappUri = Uri(
                    scheme: 'https',
                    host: 'wa.me',
                    path: '+2348032716283',
                    queryParameters: {
                      'text': '[ID$userId] Hello, I need assistance!'
                    },
                  );
                  if (await canLaunchUrl(whatsappUri)) {
                    await launchUrl(whatsappUri);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Unable to open WhatsApp.')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Chat on WhatsApp',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
