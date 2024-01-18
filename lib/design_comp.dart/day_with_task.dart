import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/design_comp.dart/show_tasklist_daywise.dart';
import 'package:todo_app/providers/task_provider.dart';

class DaysWithTasksListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final List<String> daysWithTasks = taskProvider.daysWithTasks;

    // Reorder days from Sunday to Saturday
    daysWithTasks.sort((a, b) {
      final daysOrder = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
      return daysOrder.indexOf(a) - daysOrder.indexOf(b);
    });

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: daysWithTasks.map((day) {
          return Center(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                "  " + day,
                style: TextStyle(color: Colors.black, fontSize: 20),
              ),
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  // Handle day selection and show the task list for the selected day
                  showTaskListPopup(context, day);
                },
                child: Container(
                  alignment: Alignment.centerLeft,
                  height: 50,
                  width: MediaQuery.of(context).size.width * .95,
                  padding: EdgeInsets.only(left: 12, right: 12),
                  decoration: BoxDecoration(
                    color: Color(0xffF7F7F7), // Change color based on selection
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: EdgeInsets.only(bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Activity 1 2 3",
                        style: TextStyle(
                          color: Color(0xffA4A4A4),
                          fontSize: 20,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          taskProvider.deleteTasksForDay(day);
                        },
                        child: Icon(
                          Icons.close,
                          color: Color(0xffE06E1A),
                          size: 28,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ]),
          );
        }).toList(),
      ),
    );
  }
}
