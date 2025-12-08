import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rattib/core/constants/app_colors.dart';
import 'package:rattib/core/constants/app_strings.dart';
import 'package:rattib/core/widgets/custom_button.dart';
import 'package:rattib/core/widgets/custom_text_field.dart';
import 'package:rattib/core/utils/validators.dart';
import 'package:rattib/core/utils/helpers.dart';
import 'package:rattib/features/auth/presentation/providers/auth_provider.dart';
import 'package:rattib/features/tasks/data/models/task_model.dart';
import 'package:rattib/features/tasks/presentation/providers/task_provider.dart';

/// Add/Edit Task Page
/// Create or update a task
class AddEditTaskPage extends StatefulWidget {
  final TaskModel? task;

  const AddEditTaskPage({
    super.key,
    this.task,
  });

  @override
  State<AddEditTaskPage> createState() => _AddEditTaskPageState();
}

class _AddEditTaskPageState extends State<AddEditTaskPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _dueDateController = TextEditingController();

  bool get isEditMode => widget.task != null;

  @override
  void initState() {
    super.initState();
    if (isEditMode) {
      _titleController.text = widget.task!.title;
      _descriptionController.text = widget.task!.description ?? '';
      _locationController.text = widget.task!.location ?? '';
      _dueDateController.text = widget.task!.dueDate ?? '';
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _dueDateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _dueDateController.text = Helpers.formatDate(picked);
      });
    }
  }

  Future<void> _saveTask() async {
    if (_formKey.currentState!.validate()) {
      Helpers.dismissKeyboard(context);

      final authProvider = context.read<AuthProvider>();
      final taskProvider = context.read<TaskProvider>();

      bool success;

      if (isEditMode) {
        success = await taskProvider.updateTask(
          taskId: widget.task!.taskId,
          userId: authProvider.currentUser!.userId,
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          dueDate: _dueDateController.text.trim().isNotEmpty
              ? _dueDateController.text.trim()
              : null,
          location: _locationController.text.trim().isNotEmpty
              ? _locationController.text.trim()
              : null,
          status: widget.task!.status,
        );
      } else {
        success = await taskProvider.createTask(
          userId: authProvider.currentUser!.userId,
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          dueDate: _dueDateController.text.trim().isNotEmpty
              ? _dueDateController.text.trim()
              : null,
          location: _locationController.text.trim().isNotEmpty
              ? _locationController.text.trim()
              : null,
        );
      }

      if (!mounted) return;

      if (success) {
        Helpers.showSuccess(
          context,
          isEditMode ? 'Task updated successfully' : 'Task created successfully',
        );
        Navigator.pop(context);
      } else {
        Helpers.showError(
          context,
          taskProvider.errorMessage ?? 'Failed to save task',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: Text(isEditMode ? 'Edit Task' : AppStrings.addTask),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Title Field
                CustomTextField(
                  controller: _titleController,
                  labelText: AppStrings.taskTitle,
                  hintText: 'Enter task title',
                  prefixIcon: const Icon(Icons.task),
                  validator: (value) =>
                      Validators.validateRequired(value, fieldName: 'Title'),
                ),
                const SizedBox(height: 16),
                // Description Field
                CustomTextField(
                  controller: _descriptionController,
                  labelText: AppStrings.description,
                  hintText: 'Enter task description',
                  prefixIcon: const Icon(Icons.description),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                // Due Date Field
                CustomTextField(
                  controller: _dueDateController,
                  labelText: AppStrings.dueDate,
                  hintText: 'Select due date',
                  prefixIcon: const Icon(Icons.calendar_today),
                  readOnly: true,
                  onTap: _selectDate,
                ),
                const SizedBox(height: 16),
                // Location Field
                CustomTextField(
                  controller: _locationController,
                  labelText: AppStrings.location,
                  hintText: 'Enter location',
                  prefixIcon: const Icon(Icons.location_on),
                ),
                const SizedBox(height: 32),
                // Save Button
                Consumer<TaskProvider>(
                  builder: (context, taskProvider, child) {
                    return CustomButton(
                      text: isEditMode ? AppStrings.save : AppStrings.addTask,
                      onPressed: _saveTask,
                      isLoading: taskProvider.isLoading,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
