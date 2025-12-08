import 'package:flutter/material.dart';
import 'package:rattib/features/auth/presentation/pages/welcome_page.dart';
import 'package:rattib/features/auth/presentation/pages/signin_page.dart';
import 'package:rattib/features/auth/presentation/pages/signup_page.dart';
import 'package:rattib/features/home/presentation/pages/home_page.dart';
import 'package:rattib/features/address/presentation/pages/address_page.dart';
import 'package:rattib/features/tasks/presentation/pages/tasks_page.dart';
import 'package:rattib/features/tasks/presentation/pages/add_edit_task_page.dart';
import 'package:rattib/features/tasks/data/models/task_model.dart';
import 'package:rattib/features/trips/presentation/pages/trips_page.dart';
import 'package:rattib/features/trips/presentation/pages/add_edit_trip_page.dart';
import 'package:rattib/features/trips/data/models/trip_model.dart';
import 'package:rattib/features/maps/presentation/pages/map_page.dart';
import 'package:rattib/features/badges/presentation/pages/badges_page.dart';
import 'package:rattib/features/settings/presentation/pages/settings_page.dart';
import 'package:rattib/features/settings/presentation/pages/profile_edit_page.dart';
import 'package:rattib/features/settings/presentation/pages/language_page.dart';
import 'package:rattib/features/settings/presentation/pages/privacy_policy_page.dart';
import 'package:rattib/features/settings/presentation/pages/terms_conditions_page.dart';
import 'package:rattib/features/settings/presentation/pages/about_us_page.dart';
import 'package:rattib/features/settings/presentation/pages/contact_us_page.dart';
import 'package:rattib/features/settings/presentation/pages/help_faqs_page.dart';

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
  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case welcome:
        return _buildRoute(const WelcomePage());
      case signIn:
        return _buildRoute(const SignInPage());
      case signUp:
        return _buildRoute(const SignUpPage());
      case home:
        return _buildRoute(const HomePage());
      case tasks:
        return _buildRoute(const TasksPage());
      case addTask:
        return _buildRoute(const AddEditTaskPage());
      case editTask:
        final task = routeSettings.arguments as TaskModel?;
        return _buildRoute(AddEditTaskPage(task: task));
      case trips:
        return _buildRoute(const TripsPage());
      case addTrip:
        return _buildRoute(const AddEditTripPage());
      case editTrip:
        final trip = routeSettings.arguments as TripModel?;
        return _buildRoute(AddEditTripPage(trip: trip));
      case map:
        return _buildRoute(const MapPage());
      case addresses:
        return _buildRoute(const AddressPage());
      case badges:
        return _buildRoute(const BadgesPage());
      case settings:
        return _buildRoute(const SettingsPage());
      case editProfile:
        return _buildRoute(const ProfileEditPage());
      case language:
        return _buildRoute(const LanguagePage());
      case privacyPolicy:
        return _buildRoute(const PrivacyPolicyPage());
      case termsConditions:
        return _buildRoute(const TermsConditionsPage());
      case aboutUs:
        return _buildRoute(const AboutUsPage());
      case contactUs:
        return _buildRoute(const ContactUsPage());
      case helpFaqs:
        return _buildRoute(const HelpFaqsPage());
      default:
        return _buildRoute(
          Scaffold(
            body: Center(
              child: Text('No route defined for ${routeSettings.name}'),
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
