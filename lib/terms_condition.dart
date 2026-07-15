import 'package:flutter/material.dart';

class TermsOfUsePage extends StatelessWidget {
  const TermsOfUsePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Terms and Conditions"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           
            const SizedBox(height: 10),
            const Text(
              "Last Updated: December 7, 2024",
              style: TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 20),
            _buildSection(
              "1. Acceptance of Terms",
              "By accessing or using BraveIQ's services, you agree to comply with and be bound by these Terms and all applicable laws. "
              "If you do not agree to these Terms, you must not use the Platform.\n\n"
              "BraveIQ reserves the right to update or modify these Terms at any time, and such changes will be effective immediately upon posting. "
              "You are encouraged to review these Terms regularly for any updates. Your continued use of the Platform after changes have been posted constitutes your acceptance of the modified Terms.",
            ),
            _buildSection(
              "2. Changes to Terms",
              "BraveIQ reserves the right to revise, modify, or change these Terms at its sole discretion. Any such changes will be posted on this page, and the 'Last Updated' date at the top will reflect the date of the most recent revisions. "
              "We may, but are not obligated to, notify users of any changes through email or an in-app notification.\n\n"
              "It is your responsibility to review these Terms regularly. Your continued use of the Platform after changes to the Terms signifies your acceptance of those changes. If you do not agree with the changes, you must discontinue use of the Platform.",
            ),
            _buildSection(
              "3. User Responsibilities",
              "As a user of the BraveIQ Platform, you agree to comply with all applicable laws and regulations. "
              "You are solely responsible for any content that you submit or upload to the Platform, including but not limited to educational materials, assessments, and any other content created during your use of the service.\n\n"
              "Specifically, you agree to:\n"
              "- Provide accurate, complete, and up-to-date information when creating an account.\n"
              "- Maintain the confidentiality of your account credentials.\n"
              "- Ensure compliance with all applicable local, state, and national laws.\n"
              "- Avoid engaging in harassment, offensive conduct, or illegal activities.\n"
              "- Not distribute malware, viruses, or harmful code.\n\n"
              "Failure to adhere to these responsibilities may result in suspension or termination of your account.",
            ),
            _buildSection(
              "4. Account Management",
              "To access certain features of the BraveIQ Platform, you must create an account. By creating an account, you agree to:\n"
              "- Be responsible for all activities under your account.\n"
              "- Update your account information promptly.\n"
              "- Secure your account credentials.\n"
              "- Notify BraveIQ of any unauthorized account use.\n\n"
              "BraveIQ reserves the right to suspend or terminate your account if it is compromised or if you violate these Terms.",
            ),
            _buildSection(
              "5. Privacy Policy",
              "Your use of the Platform is also governed by our Privacy Policy, which explains how we collect, use, and protect your personal data. "
              "By using the Platform, you consent to the collection and use of your data in accordance with the Privacy Policy. If you have concerns about how your data is handled, please contact us.",
            ),
            _buildSection(
              "6. Intellectual Property",
              "All content on the BraveIQ Platform, including but not limited to text, graphics, logos, images, videos, educational materials, and software, is the property of BraveIQ or its licensors and is protected by intellectual property laws.\n\n"
              "You may not copy, reproduce, distribute, or create derivative works of any content without prior written consent. Unauthorized use may result in legal action.",
            ),
            _buildSection(
              "7. Prohibited Activities",
              "While using the Platform, refrain from:\n"
              "- Damaging, disabling, or impairing the Platform's functionality.\n"
              "- Accessing another user’s account without permission.\n"
              "- Distributing malware or harmful software.\n"
              "- Engaging in unlawful or offensive activities.\n"
              "Non-compliance may result in account suspension or termination.",
            ),
            _buildSection(
              "8. Termination of Service",
              "BraveIQ reserves the right to suspend or terminate your account and access to the Platform if you violate these Terms. "
              "If terminated, you lose access to your account data. Payments made are non-refundable.",
            ),
            _buildSection(
              "9. Limitations of Liability",
              "To the fullest extent permitted by law, BraveIQ will not be liable for any indirect or consequential damages, including loss of profits or data, arising from your use or inability to use the Platform.",
            ),
            _buildSection(
              "10. Indemnification",
              "You agree to indemnify and hold BraveIQ harmless from any claims or damages resulting from your use of the Platform or violation of these Terms. This obligation survives the termination of your account.",
            ),
            _buildSection(
              "11. Dispute Resolution",
              "In the event of a dispute, parties agree to resolve issues through informal negotiation first. If unresolved, disputes will be settled through binding arbitration in Nigeria.",
            ),
            _buildSection(
              "12. Governing Law",
              "These Terms are governed by the laws of Nigeria. You agree to submit to the jurisdiction of Nigerian courts for any disputes.",
            ),
            _buildSection(
              "13. Severability",
              "If any provision of these Terms is deemed unenforceable, the remaining provisions will remain in full force and effect.",
            ),
            _buildSection(
              "14. Contact Information",
              "For any questions or concerns, please contact us:\n"
              "- Email: support@braveiq.net\n"
              "- Address: 24, State Industrial Layout, Akure, Nigeria\n"
              "- Phone: +234 803 271 6283",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            content,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
           // textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }
}
