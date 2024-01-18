import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/design_comp.dart/day_selector.dart';
import 'package:todo_app/design_comp.dart/task_listview.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/providers/task_provider.dart';
import 'package:todo_app/utils/app_colors.dart';
import 'package:uuid/uuid.dart';

class AddTaskPopup extends StatefulWidget {
  @override
  _AddTaskPopupState createState() => _AddTaskPopupState();
}

class _AddTaskPopupState extends State<AddTaskPopup> {
  late TextEditingController _taskTitleController;

  @override
  void initState() {
    super.initState();
    _taskTitleController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, taskProvider, _) {
        final selectedDayTasks = taskProvider.tasks.where((task) => task.day == taskProvider.selectedDay).toList();
        return Container(
          padding: EdgeInsets.only(top:16,bottom: 16,left: 8,right: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Add to do list',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: AppColors.primaryColor),
              ),
              SizedBox(height: 20),
              DaySelectorWidget(),
              SizedBox(height: 24),
              Text("    Activity ${selectedDayTasks.length+1}",style: TextStyle(color: Colors.grey),),
              SizedBox(height: 5,),
              TextField(
              controller: _taskTitleController,
              decoration: InputDecoration(
                hintText: 'Enter task title',
                filled: true,
                fillColor: Colors.grey[200], // Background color
                // contentPadding: EdgeInsets.all(12), // Padding around text
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10), // Rounded border
                  borderSide: BorderSide.none, // No border
                ),
              ),
              // onSubmitted: (taskTitle) {
              //   _addTask(context, taskProvider, taskTitle);
              // },
              ),

              SizedBox(height: 16),
              TaskListViewWidget(),
              GestureDetector(
              onTap: () {
                _addTask(context, taskProvider, _taskTitleController.text.trim());
              },
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8, // 80% of screen width
                padding: EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Color(0xffE06E1A), // Change color based on your preference
                  borderRadius: BorderRadius.circular(30), // Rounded corners
                ),
                child:const Center(
                  child: Text(
                    'ADD',
                    style: TextStyle(
                      color: Colors.white, // Text color
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
            ],
          ),
        );
      },
    );
  }

  void _addTask(BuildContext context, TaskProvider taskProvider, String taskTitle) {
    if (taskTitle.isNotEmpty) {
      final uuid = Uuid();
      final newTask = Task(
        id: uuid.v4(),
        title: taskTitle,
        isCompleted: false,
        day: taskProvider.selectedDay,
      );

      taskProvider.addTask(newTask);
      _taskTitleController.clear();
    }
  }
}
