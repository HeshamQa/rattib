import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rattib/core/constants/app_colors.dart';
import 'package:rattib/core/constants/app_strings.dart';
import 'package:rattib/core/routes/app_routes.dart';
import 'package:rattib/features/auth/presentation/providers/auth_provider.dart';
import 'package:rattib/features/home/presentation/widgets/home_action_card.dart';
import 'package:rattib/features/home/presentation/widgets/sos_button.dart';

/// Home Page
/// Main dashboard with navigation and quick actions
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 1; // Start with Home (middle button)

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigate based on selected index
    switch (index) {
      case 0:
        // Profile - Navigate to settings
        Navigator.pushNamed(context, AppRoutes.settings);
        break;
      case 1:
        // Home - Already here
        break;
      case 2:
        // Map
        Navigator.pushNamed(context, AppRoutes.map);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text(
          AppStrings.appName,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // TODO: Implement notifications
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.settings);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome message
            Text(
              '${AppStrings.welcome} ${authProvider.currentUser?.name ?? 'User'}!',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.darkText,
              ),
            ),
            const SizedBox(height: 20),
            // Search bar
            TextField(
              decoration: InputDecoration(
                hintText: AppStrings.searchHere,
                prefixIcon: const Icon(Icons.search, color: AppColors.iconColor),
                filled: true,
                fillColor: AppColors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
            const SizedBox(height: 30),
            // SOS Button
            const SOSButton(),
            const SizedBox(height: 30),
            // App logo/icon
            Center(
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.location_on,
                  size: 50,
                  color: AppColors.primaryBlue,
                ),
              ),
            ),
            const SizedBox(height: 30),
            // Action cards
            HomeActionCard(
              icon: Icons.task_alt,
              title: AppStrings.addTasks,
              color: AppColors.primaryBlue,
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.tasks);
              },
            ),
            const SizedBox(height: 16),
            HomeActionCard(
              icon: Icons.map_outlined,
              title: AppStrings.addTrips,
              color: AppColors.lightBlue,
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.trips);
              },
            ),
            const SizedBox(height: 16),
            HomeActionCard(
              icon: Icons.emoji_events_outlined,
              title: AppStrings.achievementsAndBadges,
              color: AppColors.warningOrange,
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.badges);
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map_outlined),
            activeIcon: Icon(Icons.map),
            label: 'Map',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.activeIconColor,
        unselectedItemColor: AppColors.iconColor,
        onTap: _onItemTapped,
      ),
    );
  }
}
