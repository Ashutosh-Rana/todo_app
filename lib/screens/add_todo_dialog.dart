import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/providers/activity_provider.dart';

class AddTodoDialog extends StatefulWidget {
  @override
  State<AddTodoDialog> createState() => _AddTodoDialogState();
}

class _AddTodoDialogState extends State<AddTodoDialog> {
  late List<TextEditingController> _activityControllers;
  late List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _initializeControllersAndFocusNodes();
  }

  void _initializeControllersAndFocusNodes() {
    final todoProvider = Provider.of<ActivityProvider>(context, listen: false);
    _activityControllers = List.generate(
        todoProvider.getActivityCount(todoProvider.selectedDay!),
        (_) => TextEditingController());
    _focusNodes = List.generate(
        todoProvider.getActivityCount(todoProvider.selectedDay!),
        (_) => FocusNode());
  }

  void _updateControllersAndFocusNodes() {
    final todoProvider = Provider.of<ActivityProvider>(context, listen: false);
    _activityControllers = List.generate(
        todoProvider.getActivityCount(todoProvider.selectedDay!),
        (_) => TextEditingController());
    _focusNodes = List.generate(
        todoProvider.getActivityCount(todoProvider.selectedDay!),
        (_) => FocusNode());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateControllersAndFocusNodes();
  }

  @override
  Widget build(BuildContext context) {
    final todoProvider = Provider.of<ActivityProvider>(context);

    double screenHeight = MediaQuery.of(context).size.height;
    double dialogHeight = screenHeight * 0.7;

    return AlertDialog(
      title: Text('Add Todo'),
      content: Container(
        height: dialogHeight,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (var day in [
                      'Sun',
                      'Mon',
                      'Tue',
                      'Wed',
                      'Thu',
                      'Fri',
                      'Sat'
                    ])
                      ElevatedButton(
                        onPressed: () {
                          todoProvider.setSelectedDay(day);
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            todoProvider.selectedDay == day
                                ? Colors.orange
                                : Colors.white,
                          ),
                        ),
                        child: Text(day),
                      ),
                  ],
                ),
              ),
              SizedBox(height: 16), // Add vertical spacing
              for (int i = 0; i < _activityControllers.length; i++)
                TextField(
                  controller: _activityControllers[i],
                  focusNode: _focusNodes[i],
                  decoration: InputDecoration(
                    labelText: 'Activity ${i + 1}',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              SizedBox(height: 16), // Add vertical spacing
              ElevatedButton(
                onPressed: () {
                  // Adding the activities to the provider
                  final todoProvider =
                      Provider.of<ActivityProvider>(context, listen: false);
                  // Clear all previous activities
                  todoProvider.clearTodos(todoProvider.selectedDay!);

                  // Add the new activities
                  for (int i = 0; i < _activityControllers.length; i++) {
                    final activity = _activityControllers[i].text;
                    if (activity.isNotEmpty) {
                      todoProvider.addTodo(
                        todoProvider.selectedDay!,
                        activity,
                      );
                    }
                  }

                  // Add a new blank text field
                  _activityControllers.add(TextEditingController());
                  _focusNodes.add(FocusNode());

                  // Incrementing the activity count
                  todoProvider
                      .incrementActivityCount(todoProvider.selectedDay!);
                  setState(() {
                    // Set focus to the newly added text field
                    FocusScope.of(context).requestFocus(_focusNodes.last);
                  });
                },
                child: Text('Add'),
              ),
              SizedBox(height: 16),

              ElevatedButton(
                onPressed: () {
                  // Adding the activities to the provider
                  final todoProvider =
                      Provider.of<ActivityProvider>(context, listen: false);

                  // Clear all previous activities
                  todoProvider.clearTodos(todoProvider.selectedDay!);

                  // Add the new activities
                  for (int i = 0; i < _activityControllers.length; i++) {
                    final activity = _activityControllers[i].text;
                    if (activity.isNotEmpty) {
                      todoProvider.addTodo(
                        todoProvider.selectedDay!,
                        activity,
                      );
                    }
                  }
                  Navigator.pop(context);
                },
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
