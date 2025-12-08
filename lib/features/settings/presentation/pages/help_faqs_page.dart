import 'package:flutter/material.dart';
import 'package:rattib/core/constants/app_colors.dart';

/// Help & FAQs Page
class HelpFaqsPage extends StatelessWidget {
  const HelpFaqsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text('Help & FAQs'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Frequently Asked Questions',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.darkText,
              ),
            ),
            const SizedBox(height: 20),
            _buildFaqItem(
              'How do I add a new task?',
              'Tap the Tasks tab in the bottom navigation, then tap the + button in the app bar. Fill in the task details and tap Save.',
            ),
            _buildFaqItem(
              'How do I plan a trip?',
              'Go to the Trips tab and tap the + button. Enter your destination, start date, end date, and status, then save.',
            ),
            _buildFaqItem(
              'How do I view my tasks on a map?',
              'Navigate to the Map tab from the home page. All tasks with location data will be displayed as markers on the map.',
            ),
            _buildFaqItem(
              'What are badges and how do I earn them?',
              'Badges are achievements you earn by completing tasks and trips. Visit the Badges page to see all available badges and track your progress.',
            ),
            _buildFaqItem(
              'How do I manage my addresses?',
              'Tap on any address category from the home page (Home, Work, Restaurants, etc.) to add, view, or delete addresses.',
            ),
            _buildFaqItem(
              'Can I edit my profile information?',
              'Yes! Go to Settings and tap on the edit icon next to your profile to update your name and email.',
            ),
            _buildFaqItem(
              'How do I delete a task or trip?',
              'Swipe left on any task or trip card, or tap the card and use the delete button.',
            ),
            _buildFaqItem(
              'Is my data secure?',
              'Yes, we take data security seriously. All your information is stored securely and protected. Read our Privacy Policy for more details.',
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primaryBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Column(
                children: [
                  Icon(
                    Icons.help_outline,
                    size: 48,
                    color: AppColors.primaryBlue,
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Need More Help?',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkText,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Contact our support team through the Contact Us page for additional assistance.',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.grayText,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFaqItem(String question, String answer) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ExpansionTile(
        title: Text(
          question,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.darkText,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              answer,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.grayText,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
