import 'package:flutter/material.dart';
import 'package:rattib/core/constants/app_colors.dart';
import 'package:rattib/core/widgets/custom_button.dart';
import 'package:rattib/core/widgets/custom_text_field.dart';
import 'package:rattib/core/utils/validators.dart';
import 'package:rattib/core/utils/helpers.dart';

/// Contact Us Page
class ContactUsPage extends StatefulWidget {
  const ContactUsPage({super.key});

  @override
  State<ContactUsPage> createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      Helpers.dismissKeyboard(context);
      setState(() => _isLoading = true);

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      setState(() => _isLoading = false);

      if (mounted) {
        Helpers.showSuccess(
          context,
          'Message sent successfully! We\'ll get back to you soon.',
        );
        _formKey.currentState!.reset();
        _nameController.clear();
        _emailController.clear();
        _subjectController.clear();
        _messageController.clear();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text('Contact Us'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                const Text(
                  'Get in Touch',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkText,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Have a question or feedback? We\'d love to hear from you!',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.grayText,
                  ),
                ),
                const SizedBox(height: 24),
                // Name Field
                CustomTextField(
                  controller: _nameController,
                  labelText: 'Name',
                  hintText: 'Enter your name',
                  prefixIcon: const Icon(Icons.person),
                  validator: (value) =>
                      Validators.validateRequired(value, fieldName: 'Name'),
                ),
                const SizedBox(height: 16),
                // Email Field
                CustomTextField(
                  controller: _emailController,
                  labelText: 'Email',
                  hintText: 'Enter your email',
                  prefixIcon: const Icon(Icons.email),
                  keyboardType: TextInputType.emailAddress,
                  validator: Validators.validateEmail,
                ),
                const SizedBox(height: 16),
                // Subject Field
                CustomTextField(
                  controller: _subjectController,
                  labelText: 'Subject',
                  hintText: 'Enter subject',
                  prefixIcon: const Icon(Icons.subject),
                  validator: (value) =>
                      Validators.validateRequired(value, fieldName: 'Subject'),
                ),
                const SizedBox(height: 16),
                // Message Field
                CustomTextField(
                  controller: _messageController,
                  labelText: 'Message',
                  hintText: 'Enter your message',
                  prefixIcon: const Icon(Icons.message),
                  maxLines: 5,
                  validator: (value) =>
                      Validators.validateRequired(value, fieldName: 'Message'),
                ),
                const SizedBox(height: 32),
                // Submit Button
                CustomButton(
                  text: 'Send Message',
                  onPressed: _submitForm,
                  isLoading: _isLoading,
                ),
                const SizedBox(height: 24),
                // Contact Info
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      _buildContactInfo(
                        Icons.email,
                        'support@rattibmashawerak.com',
                      ),
                      const SizedBox(height: 12),
                      _buildContactInfo(
                        Icons.phone,
                        '+966 XX XXX XXXX',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContactInfo(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          color: AppColors.primaryBlue,
          size: 20,
        ),
        const SizedBox(width: 12),
        Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.darkText,
          ),
        ),
      ],
    );
  }
}
