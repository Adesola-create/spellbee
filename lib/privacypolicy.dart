import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Privacy Policy"),
        backgroundColor: Colors.purple,
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Privacy Policy",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.purple,
              ),
            ),
            SizedBox(height: 16),
            Text(
              "Effective Date: Dec 2024",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              "Welcome to wordpro! Your privacy is important to us. This Privacy Policy explains how we collect, use, and safeguard your personal information.",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              "1. Information We Collect",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              "- Personal Information: We may collect information such as your name, email address, and profile details when you register or use the app.\n"
              "- Usage Data: We collect data about how you use the app, including preferences, actions, and app activity.\n"
              "- Device Information: Information about your device, such as operating system and unique device identifiers, may also be collected.",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              "2. How We Use Your Information",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              "- To provide and improve our app functionality.\n"
              "- To personalize your experience.\n"
              "- To communicate updates, offers, or relevant information.\n"
              "- To ensure the security and reliability of the app.",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              "3. Data Sharing and Disclosure",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              "We do not sell your personal data. We may share your information only under the following conditions:\n"
              "- With service providers who assist in app operations.\n"
              "- To comply with legal obligations or to protect our rights.\n"
              "- With your consent, for specific purposes.",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              "4. Data Security",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              "We implement appropriate technical and organizational measures to protect your data. However, no method of transmission over the internet is 100% secure, and we cannot guarantee absolute security.",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              "5. Your Rights",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              "- Access and update your personal information.\n"
              "- Request deletion of your account and associated data.\n"
              "- Opt out of non-essential communications.\n"
              "- Contact us with any questions or concerns about your privacy.",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              "6. Changes to This Privacy Policy",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              "We may update this Privacy Policy from time to time. Changes will be effective upon posting the updated policy in the app.",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              "7. Contact Us",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              "If you have any questions or concerns about this Privacy Policy, please contact us at:\n"
              "Email: support@wordpro.com",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 32),
            Center(
              child: Text(
                "Thank you for trusting wordpro.",
                style: TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
