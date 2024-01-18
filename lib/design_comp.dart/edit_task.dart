import 'package:flutter/material.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/utils/app_colors.dart';

class EditTaskDialog extends StatefulWidget {
  final Task task;

  EditTaskDialog({required this.task});

  @override
  _EditTaskDialogState createState() => _EditTaskDialogState();
}

class _EditTaskDialogState extends State<EditTaskDialog> {
  late TextEditingController _titleController;
  late bool _isCompleted;
  late String id;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _isCompleted = widget.task.isCompleted;
    id = widget.task.id;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      backgroundColor: AppColors.secondaryColor,
      title: Text('Edit Task'),
      content: Container(
        // color: AppColors.tertiaryColor,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              autofocus: true,
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Task Title',
                labelStyle: TextStyle(color: AppColors.blackColor),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.blackColor),
                ),
              ),
              cursorColor: AppColors.blackColor,
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Text('Completed:'),
                Checkbox(
                  value: _isCompleted,
                  onChanged: (value) {
                    setState(() {
                      _isCompleted = value ?? false;
                    });
                  },
                  activeColor: AppColors.blackColor,
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Cancel editing
          },
          style: TextButton.styleFrom(
            backgroundColor: AppColors.primaryColor, // Primary color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0), // Rounded corners
            ),
          ),
          child: Text(
            'Cancel',
            style: TextStyle(
              color: AppColors.tertiaryColor, // Text color
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            // Save edited task
            final editedTask = Task(
              id: id,
              title: _titleController.text,
              isCompleted: _isCompleted,
              day: widget.task.day,
            );

            Navigator.of(context).pop(editedTask);
          },
          style: TextButton.styleFrom(
            backgroundColor: AppColors.primaryColor, // Primary color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0), // Rounded corners
            ),
          ),
          child: Text(
            'Save',
            style: TextStyle(
              color: AppColors.tertiaryColor, // Text color
            ),
          ),
        ),
      ],
    );
  }
}
