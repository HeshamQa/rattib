import 'package:flutter/material.dart';
import 'package:rattib/core/constants/app_colors.dart';

/// Terms and Conditions Page
class TermsConditionsPage extends StatelessWidget {
  const TermsConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text('Terms & Conditions'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              'Terms and Conditions',
              'Welcome to Rattib Mashawerak. By using our app, you agree to these terms and conditions.',
            ),
            _buildSection(
              'Acceptance of Terms',
              'By accessing and using this application, you accept and agree to be bound by the terms and provisions of this agreement.',
            ),
            _buildSection(
              'Use License',
              'Permission is granted to use this application for personal, non-commercial purposes. This license shall automatically terminate if you violate any of these restrictions.',
            ),
            _buildSection(
              'User Responsibilities',
              'You are responsible for:\n\n• Maintaining the confidentiality of your account\n• All activities that occur under your account\n• Ensuring your content does not violate any laws\n• Using the app in accordance with applicable laws',
            ),
            _buildSection(
              'Service Modifications',
              'We reserve the right to modify or discontinue the service at any time without notice. We shall not be liable to you or any third party for any modification or discontinuation.',
            ),
            _buildSection(
              'Limitation of Liability',
              'The app is provided on an "as is" basis. We make no warranties, expressed or implied, and hereby disclaim all other warranties.',
            ),
            _buildSection(
              'Governing Law',
              'These terms shall be governed by and construed in accordance with applicable laws.',
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
