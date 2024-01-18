import 'dart:convert';

import 'package:todo_app/main.dart';
import 'package:todo_app/models/task.dart';

class LocalStore {

  static const String isSignedIn = "is_signed_in";
  static const String tasksKey = "tasks";

  static Future<void> saveTasks(List<Task> tasks) async {
    final tasksJson = tasks.map((task) => task.toJson()).toList();
    final tasksString = json.encode(tasksJson);
    await prefs.setString(tasksKey, tasksString);
  }

  static Future<List<Task>> getTasks() async {
    final tasksString = prefs.getString(tasksKey);
    if (tasksString != null && tasksString.isNotEmpty) {
      final tasksJson = json.decode(tasksString) as List<dynamic>;
      final tasks = tasksJson.map((taskJson) => Task.fromJson(taskJson)).toList();
      return tasks;
    } else {
      return [];
    }
  }
}