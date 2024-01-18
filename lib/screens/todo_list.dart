import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/providers/activity_provider.dart';

class TodoList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final todos = Provider.of<ActivityProvider>(context).todos;

    return ListView.builder(
      itemCount: todos.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(todos[index].day + ': ' + todos[index].activity),
        );
      },
    );
  }
}