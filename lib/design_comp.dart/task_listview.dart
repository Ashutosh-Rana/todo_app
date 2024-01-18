import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/design_comp.dart/edit_task.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/providers/task_provider.dart';
import 'package:todo_app/utils/app_colors.dart';

class TaskListViewWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final List<Task> tasksForSelectedDay = taskProvider.tasks
        .where((task) => task.day == taskProvider.selectedDay)
        .toList();

    return Expanded(
      child: ListView.builder(
        itemCount: tasksForSelectedDay.length,
        itemBuilder: (context, index) {
          final task = tasksForSelectedDay[index];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "    Activity ${index + 1}",
                style: TextStyle(color: Colors.grey),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                height: 90,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors
                      .secondaryColor, // Change color based on your preference
                  borderRadius: BorderRadius.circular(12), // Rounded corners
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      title: Text(task.title),
                      subtitle: Text(
                          'Status: ${task.isCompleted ? 'Completed' : 'Incomplete'}'),
                      trailing: GestureDetector(
                          onTap: () {
                            taskProvider.deleteTask(task.id);
                          },
                          child: Icon(
                            Icons.close,
                            color: Color(0xffE06E1A),
                            size: 28,
                            weight: 4,
                          )),
                      onTap: () async {
                        final editedTask = await showDialog(
                          context: context,
                          builder: (context) {
                            return EditTaskDialog(task: task);
                          },
                        );

                        if (editedTask != null) {
                          taskProvider.editTask(task.id, editedTask);
                        }
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left:22.0),
                      child: Text(
                        "Tap to edit",
                        style: TextStyle(
                          color: Colors.black,
                          fontStyle: FontStyle.italic,
                          fontSize: 8
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              )
            ],
          );
        },
      ),
    );
  }
}
