import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
           
              const SizedBox(height: 10),
              const Text(
                'Last Updated: December 12, 2024',
                style: TextStyle(
                  fontSize: 16.0,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 20),
              _buildSection(
                'Consent',
                'By using BraveIQ, you agree to the terms outlined in this Privacy Policy. You can withdraw your consent at any time by reaching out to us. However, withdrawing consent may limit your access to some features or services on our Platform, as we rely on certain data to deliver an optimal user experience.',
              ),
              _buildSection(
                'Information We Collect',
                'We collect various types of data to provide and improve our services. The data collected includes:',
              ),
              _buildSubSection(
                '1. Profile Data',
                'This includes information you provide when you create an account, such as your name, email, username, and contact information. We use this to personalize your experience and help you access your account.',
              ),
              _buildSubSection(
                '2. Usage Data',
                'We collect data about your activities on the Platform, such as content you view or interact with, the time spent on each section, and interaction types. This helps us understand usage patterns to enhance our services.',
              ),
              _buildSubSection(
                '3. Device Data',
                'This includes information like your IP address, device type, and operating system, which helps us troubleshoot and optimize your experience across different devices.',
              ),
              _buildSubSection(
                '4. Camera and Storage Permissions',
                'We request permission to access your camera and storage, but only for specific purposes:\n\n'
                '- Camera: Allows you to scan documents or submit assignments directly.\n'
                '- Storage: Enables file uploads, downloads, and saving materials for offline use.',
              ),
              _buildSection(
                'How We Use Your Data',
                'Your data helps us improve and personalize your experience. Specifically, we use it for:\n'
                '- Account creation and management\n'
                '- Delivering personalized content and suggestions\n'
                '- Ensuring secure transactions and communication\n'
                '- Monitoring and enhancing our services based on usage patterns\n'
                '- Notifying you about updates, offers, and relevant content',
              ),
              _buildSection(
                'Your Legal Rights',
                'You have the right to manage your data with BraveIQ in several ways:',
              ),
              _buildSubSection(
                '1. Access',
                'You have the right to request access to your data (a "data subject access request"). This allows you to receive a copy of your data and ensure we are lawfully processing it. There may be an administrative fee associated with fulfilling your request.',
              ),
              _buildSubSection(
                '2. Correction',
                'If you find any inaccurate or incomplete information in your profile, you can request correction. We may verify the accuracy of the new data you provide before updating it in our records.',
              ),
              _buildSubSection(
                '3. Erasure',
                'You have the right to request deletion of your data when there is no longer a valid reason for us to keep it. We may decline to erase certain data for legal or contractual reasons, which we will inform you of if applicable.',
              ),
              _buildSubSection(
                '4. Object to Processing',
                'If we process your data based on legitimate interests and you believe it impacts your rights, you may object. This also applies if we use your data for direct marketing. We may sometimes demonstrate that our grounds for processing your data override your rights.',
              ),
              _buildSubSection(
                '5. Data Portability',
                'Request the transfer of your data to you or another service provider. We provide data in a commonly used, machine-readable format. Please note that this right applies only to data processed by automated means with your consent or for contract purposes. An administrative fee may apply.',
              ),
              _buildSubSection(
                '6. Withdraw Consent',
                'If you have given consent for data processing, you can withdraw it at any time. This will not affect processing done prior to withdrawal. Be aware that withdrawing consent may restrict your access to certain services. We will inform you of any limitations if this applies.',
              ),
              _buildSection(
                'Security Measures',
                'We use industry-standard security measures, including encryption, secure servers, and access controls, to protect your data. Although we strive to protect your information, no method is entirely secure, and you should also take steps, such as using strong passwords, to protect your account.',
              ),
              _buildSection(
                'Data Retention',
                'Your data will be retained for as long as necessary to fulfill the purposes outlined in this Privacy Policy, including legal obligations. Once your account is deleted, we will securely erase or anonymize your data unless retention is required by law.',
              ),
              _buildSection(
                'Children’s Privacy',
                'Our Platform is intended for users over 13 years of age. We do not knowingly collect data from children under 13. If we learn that we have inadvertently collected data from a child under 13, we will promptly delete it. Parents can contact us to request deletion of their child’s data if necessary.',
              ),
              _buildSection(
                'Changes to This Privacy Policy',
                'We may update this Privacy Policy periodically. We will notify you about significant changes via email or through our app. By continuing to use the Platform after changes are made, you agree to the updated terms.',
              ),
              _buildSection(
                'Contact Information',
                'If you have any questions or need more details on this policy, please contact us:\n'
                '- Email: support@braveiq.net\n'
                '- Address: 24, State Industrial Layout, Akure, Nigeria\n'
                '- Phone: +234 803 271 6283',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            content,
            style: const TextStyle(fontSize: 16.0),
          ),
        ],
      ),
    );
  }

  Widget _buildSubSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, top: 8.0, bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            content,
            style: const TextStyle(fontSize: 16.0),
          ),
        ],
      ),
    );
  }
}
