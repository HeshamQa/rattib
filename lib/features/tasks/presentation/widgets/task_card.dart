import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rattib/core/constants/app_colors.dart';
import 'package:rattib/core/routes/app_routes.dart';
import 'package:rattib/core/utils/helpers.dart';
import 'package:rattib/features/auth/presentation/providers/auth_provider.dart';
import 'package:rattib/features/tasks/data/models/task_model.dart';
import 'package:rattib/features/tasks/presentation/providers/task_provider.dart';

/// Task Card Widget
/// Displays task information
class TaskCard extends StatelessWidget {
  final TaskModel task;

  const TaskCard({
    super.key,
    required this.task,
  });

  void _toggleTaskStatus(BuildContext context) async {
    final authProvider = context.read<AuthProvider>();
    final taskProvider = context.read<TaskProvider>();

    final newStatus = task.status == 'Pending' ? 'Completed' : 'Pending';

    final success = await taskProvider.updateTask(
      taskId: task.taskId,
      userId: authProvider.currentUser!.userId,
      title: task.title,
      description: task.description,
      dueDate: task.dueDate,
      location: task.location,
      latitude: task.latitude,
      longitude: task.longitude,
      status: newStatus,
    );

    if (context.mounted && success) {
      Helpers.showSuccess(context, 'Task status updated');
    }
  }

  void _deleteTask(BuildContext context) async {
    final confirmed = await Helpers.showConfirmDialog(
      context,
      title: 'Delete Task',
      message: 'Are you sure you want to delete this task?',
      confirmText: 'Delete',
    );

    if (confirmed && context.mounted) {
      final authProvider = context.read<AuthProvider>();
      final taskProvider = context.read<TaskProvider>();

      final success = await taskProvider.deleteTask(
        task.taskId,
        authProvider.currentUser!.userId,
      );

      if (context.mounted && success) {
        Helpers.showSuccess(context, 'Task deleted successfully');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isCompleted = task.status == 'Completed';

    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoutes.editTask,
          arguments: task,
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isCompleted
                ? AppColors.successGreen.withOpacity(0.3)
                : AppColors.borderColor,
          ),
        ),
        child: Row(
          children: [
            // Checkbox
            Checkbox(
              value: isCompleted,
              onChanged: (_) => _toggleTaskStatus(context),
              activeColor: AppColors.successGreen,
            ),
            const SizedBox(width: 12),
            // Task details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.darkText,
                      decoration: isCompleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                  if (task.description != null &&
                      task.description!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      task.description!,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.grayText,
                        decoration: isCompleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  if (task.dueDate != null) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          size: 14,
                          color: AppColors.iconColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          task.dueDate!,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.grayText,
                          ),
                        ),
                      ],
                    ),
                  ],
                  if (task.location != null && task.location!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 14,
                          color: AppColors.iconColor,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            task.location!,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.grayText,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            // Delete button
            IconButton(
              icon: const Icon(Icons.delete_outline),
              color: Colors.red,
              onPressed: () => _deleteTask(context),
            ),
          ],
        ),
      ),
    );
  }
}
