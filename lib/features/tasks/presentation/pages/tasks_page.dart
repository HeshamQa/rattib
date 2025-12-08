import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rattib/core/constants/app_colors.dart';
import 'package:rattib/core/constants/app_strings.dart';
import 'package:rattib/core/routes/app_routes.dart';
import 'package:rattib/core/widgets/loading_widget.dart';
import 'package:rattib/features/auth/presentation/providers/auth_provider.dart';
import 'package:rattib/features/tasks/presentation/providers/task_provider.dart';
import 'package:rattib/features/tasks/presentation/widgets/task_card.dart';

/// Tasks Page
/// View and manage tasks
class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadTasks();
    });
  }

  void _loadTasks() {
    final authProvider = context.read<AuthProvider>();
    final taskProvider = context.read<TaskProvider>();

    if (authProvider.currentUser != null) {
      taskProvider.fetchTasks(authProvider.currentUser!.userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text(AppStrings.tasks),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.addTask).then((_) {
                _loadTasks();
              });
            },
          ),
        ],
      ),
      body: Consumer<TaskProvider>(
        builder: (context, taskProvider, child) {
          if (taskProvider.isLoading) {
            return const LoadingWidget();
          }

          if (taskProvider.tasks.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.task_outlined,
                    size: 80,
                    color: AppColors.grayText.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    AppStrings.noTasksYet,
                    style: TextStyle(
                      fontSize: 18,
                      color: AppColors.grayText.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.addTask)
                          .then((_) => _loadTasks());
                    },
                    child: const Text(AppStrings.addYourFirstTask),
                  ),
                ],
              ),
            );
          }

          // Group tasks by status
          final pendingTasks = taskProvider.getTasksByStatus('Pending');
          final completedTasks = taskProvider.getTasksByStatus('Completed');

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (pendingTasks.isNotEmpty) ...[
                  const Text(
                    'Pending Tasks',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkText,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...pendingTasks.map((task) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: TaskCard(task: task),
                      )),
                  const SizedBox(height: 20),
                ],
                if (completedTasks.isNotEmpty) ...[
                  const Text(
                    'Completed Tasks',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkText,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...completedTasks.map((task) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: TaskCard(task: task),
                      )),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
