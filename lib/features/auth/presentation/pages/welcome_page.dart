import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rattib/core/constants/app_colors.dart';
import 'package:rattib/core/constants/app_strings.dart';
import 'package:rattib/core/widgets/custom_button.dart';
import 'package:rattib/core/routes/app_routes.dart';
import 'package:rattib/features/auth/presentation/providers/auth_provider.dart';

/// Welcome Page
/// First screen when app launches
class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  void _handleGetStarted(BuildContext context) {
    final authProvider = context.read<AuthProvider>();
    if (authProvider.isAuthenticated) {
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.signIn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/logo.jpeg"),
            fit: BoxFit.fill,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/unnamed.png",
                    width: 350,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
              const Spacer(flex: 2),
              // Welcome
              const Text(
                AppStrings.welcome,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: AppColors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              // Description
              Text(
                AppStrings.welcomeDescription,
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.white.withOpacity(0.9),
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              // Get Started Button
              Consumer<AuthProvider>(
                builder: (context, authProvider, child) {
                  return CustomButton(
                    text: AppStrings.letsGetStarted,
                    onPressed: authProvider.isInitialized
                        ? () => _handleGetStarted(context)
                        : null,
                    isLoading: !authProvider.isInitialized,
                    color: AppColors.white,
                    textColor: AppColors.primaryBlue,
                  );
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
