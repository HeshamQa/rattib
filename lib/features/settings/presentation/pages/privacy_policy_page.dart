import 'package:flutter/material.dart';
import 'package:rattib/core/constants/app_colors.dart';

/// Privacy Policy Page
class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text('Privacy & Cookie Policy'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              'Privacy Policy',
              'Rattib Mashawerak is committed to protecting your privacy. This Privacy Policy explains how we collect, use, and safeguard your information when you use our mobile application.',
            ),
            _buildSection(
              'Information We Collect',
              'We collect information that you provide directly to us, including:\n\n• Name and email address\n• Tasks and trip information\n• Location data for map features\n• Usage statistics and preferences',
            ),
            _buildSection(
              'How We Use Your Information',
              'We use the information we collect to:\n\n• Provide and improve our services\n• Organize your tasks and trips\n• Display location-based features\n• Send notifications about your activities\n• Analyze app usage and performance',
            ),
            _buildSection(
              'Data Security',
              'We implement appropriate security measures to protect your personal information. However, no method of transmission over the internet is 100% secure.',
            ),
            _buildSection(
              'Cookie Policy',
              'Our app may use cookies and similar technologies to enhance your experience and collect usage information.',
            ),
            _buildSection(
              'Contact Us',
              'If you have questions about this Privacy Policy, please contact us through the app\'s Contact Us page.',
            ),
            const SizedBox(height: 16),
            Text(
              'Last updated: ${DateTime.now().year}',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.grayText.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.darkText,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.grayText,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
