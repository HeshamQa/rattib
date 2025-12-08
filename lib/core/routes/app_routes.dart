import 'package:flutter/material.dart';
import 'package:rattib/features/auth/presentation/pages/welcome_page.dart';
import 'package:rattib/features/auth/presentation/pages/signin_page.dart';
import 'package:rattib/features/auth/presentation/pages/signup_page.dart';
import 'package:rattib/features/home/presentation/pages/home_page.dart';

/// App Routes
/// Centralized route definitions for navigation
class AppRoutes {
  // Route names
  static const String welcome = '/welcome';
  static const String signIn = '/signin';
  static const String signUp = '/signup';
  static const String home = '/home';
  static const String tasks = '/tasks';
  static const String addTask = '/add-task';
  static const String editTask = '/edit-task';
  static const String trips = '/trips';
  static const String addTrip = '/add-trip';
  static const String editTrip = '/edit-trip';
  static const String map = '/map';
  static const String addresses = '/addresses';
  static const String badges = '/badges';
  static const String settings = '/settings';
  static const String language = '/language';
  static const String privacyPolicy = '/privacy-policy';
  static const String termsConditions = '/terms-conditions';
  static const String aboutUs = '/about-us';
  static const String contactUs = '/contact-us';
  static const String helpFaqs = '/help-faqs';
  static const String editProfile = '/edit-profile';

  // Route generator
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case welcome:
        return _buildRoute(const WelcomePage());
      case signIn:
        return _buildRoute(const SignInPage());
      case signUp:
        return _buildRoute(const SignUpPage());
      case home:
        return _buildRoute(const HomePage());
      case tasks:
        return _buildRoute(const Placeholder());
      case addTask:
        return _buildRoute(const Placeholder());
      case trips:
        return _buildRoute(const Placeholder());
      case addTrip:
        return _buildRoute(const Placeholder());
      case map:
        return _buildRoute(const Placeholder());
      case addresses:
        return _buildRoute(const Placeholder());
      case badges:
        return _buildRoute(const Placeholder());
      case settings:
        return _buildRoute(const Placeholder());
      default:
        return _buildRoute(
          Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }

  // Helper method to build routes
  static MaterialPageRoute _buildRoute(Widget page) {
    return MaterialPageRoute(builder: (_) => page);
  }
}
