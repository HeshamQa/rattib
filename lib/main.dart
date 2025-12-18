import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rattib/core/constants/app_colors.dart';
import 'package:rattib/core/constants/app_strings.dart';
import 'package:rattib/core/routes/app_routes.dart';
import 'package:rattib/features/auth/presentation/providers/auth_provider.dart';
import 'package:rattib/features/address/presentation/providers/address_provider.dart';
import 'package:rattib/features/tasks/presentation/providers/task_provider.dart';
import 'package:rattib/features/trips/presentation/providers/trip_provider.dart';
import 'package:rattib/features/badges/presentation/providers/badge_provider.dart';
import 'package:rattib/features/sos/presentation/providers/sos_provider.dart';
import 'package:rattib/features/admin/presentation/providers/admin_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => AddressProvider()),
        ChangeNotifierProvider(create: (_) => TaskProvider()),
        ChangeNotifierProvider(create: (_) => TripProvider()),
        ChangeNotifierProvider(create: (_) => BadgeProvider()),
        ChangeNotifierProvider(create: (_) => SosProvider()),
        ChangeNotifierProvider(create: (_) => AdminProvider()),
      ],
      child: MaterialApp(
        title: AppStrings.appName,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: AppColors.primaryBlue,
          scaffoldBackgroundColor: AppColors.backgroundColor,
          appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.primaryBlue,
            foregroundColor: AppColors.white,
            elevation: 0,
          ),
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.primaryBlue,
            primary: AppColors.primaryBlue,
            secondary: AppColors.lightBlue,
          ),
          useMaterial3: true,
        ),
        home: const AuthWrapper(),
        onGenerateRoute: AppRoutes.generateRoute,
      ),
    );
  }
}

/// Auth Wrapper - Handles initial routing based on auth state
class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _navigated = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        // Show loading while checking auth state
        if (!authProvider.isInitialized) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // Only navigate once
        if (!_navigated) {
          _navigated = true;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _handleNavigation(context, authProvider);
          });
        }

        // Show loading while navigating
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  void _handleNavigation(BuildContext context, AuthProvider authProvider) {
    if (authProvider.isAuthenticated) {
      if (authProvider.isAdmin) {
        // Set admin state in AdminProvider
        final adminProvider = context.read<AdminProvider>();
        if (!adminProvider.isLoggedIn && authProvider.adminId != null) {
          adminProvider.login(authProvider.adminId!);
        }
        // Navigate to admin dashboard
        Navigator.pushReplacementNamed(context, AppRoutes.adminDashboard);
      } else {
        // Navigate to home for regular users
        Navigator.pushReplacementNamed(context, AppRoutes.home);
      }
    } else {
      // Navigate to welcome for unauthenticated users
      Navigator.pushReplacementNamed(context, AppRoutes.welcome);
    }
  }
}
