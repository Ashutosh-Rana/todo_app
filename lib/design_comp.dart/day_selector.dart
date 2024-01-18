import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/providers/task_provider.dart';

class DaySelectorWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final List<String> days = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: days.map((day) {
          final isSelected = taskProvider.selectedDay == day;

          return GestureDetector(
            onTap: () {
              taskProvider.setSelectedDay(day);
            },
            child: Container(
              width: 59,
              height: 27,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected ? Color(0xffE06E1A) : Colors.grey, // Change color based on selection
                borderRadius: BorderRadius.circular(5),
              ),
              margin: EdgeInsets.only(right: 8),
              child: Text(
                day.substring(0, 3),
                style: TextStyle(
                  color: Colors.white, // Change text color based on selection
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
