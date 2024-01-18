import 'package:flutter/material.dart';
import 'package:todo_app/models/todo.dart';

class ActivityProvider extends ChangeNotifier{
  List<Todo> todos = [];
  String? selectedDay="Sun";

  Map<String, int> activityCounts = {}; // Map to store activity counts for each day
  Map<String, List<TextEditingController>> controllersMap = {};
  Map<String, List<FocusNode>> focusNodesMap = {};
  Map<String, List<Todo>> todosMap = {};

  ActivityProvider() {
    // Initialize with an example day
    setSelectedDay('Sun');
  }

  // void addTodo(String day, List<String> activities) {
  //   for (var activity in activities) {
  //     todos.add(Todo(day, activity));
  //   }
  //   notifyListeners();
  // }

  void addTodo(String day, String activity) {
    _initializeTodosForDay(day);
    todosMap[day]!.add(Todo(day, activity));
    notifyListeners();
  }

  void setSelectedDay(String day) {
    selectedDay = day;
    _initializeControllersAndFocusNodes(day); 
    _initializeTodosForDay(day);
    notifyListeners();
  }

  List<String> get daysWithTasks {
    return todosMap.keys.where((day) => todosMap[day]!.isNotEmpty).toList();
  }

  List<Todo> todosForDay(String day) {
    return todosMap[day] ?? [];
  }

  void _initializeTodosForDay(String day) {
    if (!todosMap.containsKey(day)) {
      todosMap[day] = [];
    }
  }

  int getActivityCount(String day) {
    return activityCounts[day] ?? 1; // Default to 1 if not set
  } 

  void incrementActivityCount(String day) {
    activityCounts.update(day, (count) => count + 1, ifAbsent: () => 1);
    notifyListeners();
  }

  void decrementActivityCount(String day) {
    if (activityCounts[day] != null && activityCounts[day]! > 1) {
      activityCounts.update(day, (count) => count - 1);
      notifyListeners();
    }
  }

  List<TextEditingController> getControllers(String day) {
    return controllersMap[day]!;
  }

  List<FocusNode> getFocusNodes(String day) {
    return focusNodesMap[day]!;
  }

  void _initializeControllersAndFocusNodes(String day) {
    if (!controllersMap.containsKey(day)) {
      controllersMap[day] = [TextEditingController()];
      focusNodesMap[day] = [FocusNode()];
    }
  }

  void addControllers(String day, List<TextEditingController> controllers) {
    controllersMap[day] = controllers;
    notifyListeners();
  }

  // Dispose of controllers and focus nodes when no longer needed
  void disposeControllersAndFocusNodes(String day) {
    controllersMap[day]?.forEach((controller) => controller.dispose());
    focusNodesMap[day]?.forEach((focusNode) => focusNode.dispose());
    controllersMap.remove(day);
    focusNodesMap.remove(day);
  }

  // Add this method to clear todos for a specific day
  // Add this method to clear todos for a specific day
  void clearTodos(String day) {
    todos.removeWhere((todo) => todo.day == day);
    notifyListeners();
  }
}