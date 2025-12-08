import 'package:flutter/material.dart';
import 'package:rattib/core/constants/app_colors.dart';
import 'package:rattib/core/constants/app_strings.dart';

/// About Us Page
class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text('About Us'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App Logo/Icon
            Center(
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.maps_ugc,
                  size: 80,
                  color: AppColors.primaryBlue,
                ),
              ),
            ),
            const SizedBox(height: 24),
            // App Name
            Center(
              child: Text(
                AppStrings.appName,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkText,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                'Version 1.0.0',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.grayText.withOpacity(0.7),
                ),
              ),
            ),
            const SizedBox(height: 32),
            _buildSection(
              'Our Mission',
              'Rattib Mashawerak helps you organize your daily tasks and trips efficiently using smart location-based features and intuitive planning tools.',
            ),
            _buildSection(
              'What We Offer',
              '• Task Management - Keep track of your daily tasks with location support\n\n• Trip Planning - Plan and organize your trips with ease\n\n• Smart Maps - Visualize your tasks and trips on an interactive map\n\n• Achievements - Earn badges and track your productivity\n\n• Easy Organization - Categorize addresses for quick access',
            ),
            _buildSection(
              'Our Vision',
              'To help people lead more organized and productive lives by providing intelligent task and trip management solutions.',
            ),
            _buildSection(
              'Contact Information',
              'For support and inquiries, please use the Contact Us page in the app settings.',
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                '© ${DateTime.now().year} Rattib Mashawerak. All rights reserved.',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.grayText.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
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
