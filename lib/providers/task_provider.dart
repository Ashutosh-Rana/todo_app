import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/models/task.dart';
import 'package:uuid/uuid.dart';

class TaskProvider extends ChangeNotifier {
  static const String tasksKey = 'tasks';
  List<Task> tasks = [];
  String selectedDay = 'Sunday'; // Default day

  // void addTask(Task task) {
  //   tasks.add(task);
  //   notifyListeners();
  // }

  void editTask(String taskId, Task updatedTask) async {
  final index = tasks.indexWhere((task) => task.id == taskId);

  if (index != -1) {
    tasks[index] = updatedTask;
    await saveTasks();
    notifyListeners();
  }
}

  void deleteTask(String taskId) async {
    tasks.removeWhere((task) => task.id == taskId);
    await saveTasks();
    notifyListeners();
  }

  void setSelectedDay(String day) {
    selectedDay = day;
    notifyListeners();
  }

  List<String> get daysWithTasks {
    // Replace this logic with your actual implementation
    List<String> daysWithTasks = [];

    for (var task in tasks) {
      if (!daysWithTasks.contains(task.day)) {
        daysWithTasks.add(task.day);
      }
    }
    return daysWithTasks;
  }

  Future<void> initializeProvider() async {
    await loadTasks();
  }

  Future<void> addTask(Task task) async {
    final uuid = Uuid();
    task.id = uuid.v4(); // Assign a unique ID to the task
    tasks.add(task);
    await saveTasks();
    notifyListeners();
  }

  Future<void> loadTasks() async {
    final String? tasksJson = prefs.getString(tasksKey);
    if (tasksJson != null) {
      // print(tasksJson);
      final List<dynamic> tasksList = jsonDecode(tasksJson);
      // print(tasksList);
      tasks = tasksList.map((task) => Task.fromJson(task)).toList();
    }
    notifyListeners();
  }

  Future<void> saveTasks() async {
    final List<Map<String, dynamic>> tasksJson =
        tasks.map((task) => task.toJson()).toList();

    prefs.setString(tasksKey, jsonEncode(tasksJson));
  }

  void deleteTasksForDay(String day) async {
    tasks.removeWhere((task) => task.day == day);
    await saveTasks();
    notifyListeners();
  }
}
