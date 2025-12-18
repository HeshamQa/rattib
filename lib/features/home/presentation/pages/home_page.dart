import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:rattib/core/constants/app_colors.dart';
import 'package:rattib/core/constants/app_strings.dart';
import 'package:rattib/core/routes/app_routes.dart';
import 'package:rattib/features/auth/presentation/providers/auth_provider.dart';
import 'package:rattib/features/home/presentation/widgets/home_action_card.dart';
import 'package:rattib/features/sos/presentation/providers/sos_provider.dart';

/// Home Page
/// Main dashboard with navigation and quick actions
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 1; // Start with Home (middle button)

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadSosContacts();
    });
  }

  void _loadSosContacts() {
    final authProvider = context.read<AuthProvider>();
    final userId = authProvider.currentUser?.userId;
    if (userId != null) {
      context.read<SosProvider>().loadContacts(userId);
    }
  }

  void _handleSosPress() {
    final sosProvider = context.read<SosProvider>();

    if (sosProvider.contacts.isEmpty) {
      // No contacts - redirect to add contacts
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.orange),
              SizedBox(width: 8),
              Expanded(
                child: Text('No Emergency Contacts'),
              ),
            ],
          ),
          content: const Text(
            'You haven\'t added any emergency contacts yet. Would you like to add contacts now?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, AppRoutes.sos);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
              ),
              child: const Text('Add Contacts',style: TextStyle(color: Colors.white),),
            ),
          ],
        ),
      );
      return;
    }

    // Show SOS action dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.emergency, color: AppColors.sosRed),
            SizedBox(width: 8),
            Expanded(
              child: Text('SOS Emergency'),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Choose an action to contact your emergency contacts:',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            ...sosProvider.contacts.map((contact) => Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppColors.primaryBlue.withOpacity(0.1),
                  child: Text(
                    contact.name.isNotEmpty ? contact.name[0].toUpperCase() : '?',
                    style: const TextStyle(color: AppColors.primaryBlue),
                  ),
                ),
                title: Text(contact.name),
                subtitle: Text(contact.phone),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.call, color: Colors.green),
                      onPressed: () => _makeCall(contact.phone),
                    ),
                    IconButton(
                      icon: const Icon(Icons.message, color: AppColors.primaryBlue),
                      onPressed: () => _sendSms(contact.phone),
                    ),
                  ],
                ),
              ),
            )),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              _callAllContacts(sosProvider.contacts);
            },
            icon: const Icon(Icons.call, size: 18),
            label: const Text('Call All'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              _smsAllContacts(sosProvider.contacts);
            },
            icon: const Icon(Icons.message, size: 18),
            label: const Text('SMS All'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.sosRed,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _makeCall(String phone) async {
    final uri = Uri.parse('tel:$phone');
      await launchUrl(uri);

  }

  Future<void> _sendSms(String phone) async {
    final uri = Uri.parse('sms:$phone?body=Emergency! I need help. Please contact me urgently.');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _callAllContacts(List contacts) async {
      await _makeCall(contacts.first.phone);
  }

  Future<void> _smsAllContacts(List contacts) async {
    final phones = contacts.map((c) => c.phone).join(',');
    final uri = Uri.parse('sms:$phones?body=Emergency! I need help. Please contact me urgently.');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

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
        automaticallyImplyLeading: false,
        title: const Text(
          AppStrings.appName,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),

        actions: [
          // SOS Emergency Button
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            decoration: BoxDecoration(
              color: AppColors.sosRed,
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              icon: const Icon(Icons.emergency_share_outlined, color: Colors.white, size: 22),
              onPressed: _handleSosPress,
              tooltip: 'SOS Emergency',
            ),
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
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
                prefixIcon: const Icon(
                  Icons.search,
                  color: AppColors.iconColor,
                ),
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
            // SOS Button
            // App logo/icon
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/unnamed.png",
                  width: 210,
                  fit: BoxFit.contain,
                ),
              ],
            ),
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
