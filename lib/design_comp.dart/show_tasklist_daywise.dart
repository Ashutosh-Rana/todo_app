import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/providers/task_provider.dart';
import 'package:todo_app/utils/app_colors.dart';

void showTaskListPopup(BuildContext context, String selectedDay) {
  final taskProvider = Provider.of<TaskProvider>(context, listen: false);

  // Filter tasks for the selected day
  List<Task> tasksForSelectedDay =
      taskProvider.tasks.where((task) => task.day == selectedDay).toList();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        insetPadding: EdgeInsets.all(25),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              selectedDay + " Activities",
              style: TextStyle(
                color: AppColors.primaryColor,
                fontSize: 20,
                fontWeight: FontWeight.bold
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop(); // Close the popup
              },
              child: Icon(
                Icons.close,
                color: AppColors.primaryColor,
                size: 28,
              ),
            ),
          ],
        ),
        content: Container(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.35,
            width: MediaQuery.of(context).size.width * 0.9,
            child: ListView.builder(
              itemCount: tasksForSelectedDay.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                      '${index + 1}. ${tasksForSelectedDay[index].title}',style: TextStyle(
                        fontSize: 20
                      ),),
                  // Add any other task details you want to display
                );
              },
            ),
          ),
        ),
      );
    },
  );
}
