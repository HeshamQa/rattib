import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rattib/core/constants/app_colors.dart';
import 'package:rattib/core/widgets/loading_widget.dart';
import 'package:rattib/features/auth/presentation/providers/auth_provider.dart';
import 'package:rattib/features/badges/presentation/providers/badge_provider.dart';
import 'package:rattib/features/badges/presentation/widgets/badge_card.dart';

/// Badges Page
/// View achievements and badges
class BadgesPage extends StatefulWidget {
  const BadgesPage({super.key});

  @override
  State<BadgesPage> createState() => _BadgesPageState();
}

class _BadgesPageState extends State<BadgesPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadBadges();
    });
  }

  void _loadBadges() {
    final authProvider = context.read<AuthProvider>();
    final badgeProvider = context.read<BadgeProvider>();

    if (authProvider.currentUser != null) {
      badgeProvider.fetchAllBadges();
      badgeProvider.fetchUserBadges(authProvider.currentUser!.userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text('Achievements & Badges'),
      ),
      body: Consumer<BadgeProvider>(
        builder: (context, badgeProvider, child) {
          if (badgeProvider.isLoading) {
            return const LoadingWidget();
          }

          if (badgeProvider.allBadges.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.emoji_events_outlined,
                    size: 80,
                    color: AppColors.grayText.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No badges available',
                    style: TextStyle(
                      fontSize: 18,
                      color: AppColors.grayText.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            );
          }

          // Separate earned and unearned badges
          final earnedBadges = badgeProvider.userBadges;
          final unearnedBadges = badgeProvider.allBadges
              .where((badge) => !badgeProvider.hasEarnedBadge(badge.badgeId))
              .toList();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Stats Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primaryBlue,
                        AppColors.lightBlue,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Text(
                            '${earnedBadges.length}',
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: AppColors.white,
                            ),
                          ),
                          const Text(
                            'Earned',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.white,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: 1,
                        height: 50,
                        color: AppColors.white.withOpacity(0.3),
                      ),
                      Column(
                        children: [
                          Text(
                            '${badgeProvider.allBadges.length}',
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: AppColors.white,
                            ),
                          ),
                          const Text(
                            'Total',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Earned Badges
                if (earnedBadges.isNotEmpty) ...[
                  const Text(
                    'Earned Badges',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkText,
                    ),
                  ),
                  const SizedBox(height: 12),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.85,
                    ),
                    itemCount: earnedBadges.length,
                    itemBuilder: (context, index) {
                      return BadgeCard(
                        badge: earnedBadges[index],
                        isEarned: true,
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                ],
                // Locked Badges
                if (unearnedBadges.isNotEmpty) ...[
                  const Text(
                    'Locked Badges',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkText,
                    ),
                  ),
                  const SizedBox(height: 12),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.85,
                    ),
                    itemCount: unearnedBadges.length,
                    itemBuilder: (context, index) {
                      return BadgeCard(
                        badge: unearnedBadges[index],
                        isEarned: false,
                      );
                    },
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
