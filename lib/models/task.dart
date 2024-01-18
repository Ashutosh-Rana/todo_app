class Task {
  String id;
  String title;
  bool isCompleted;
  String day;

  Task({
    required this.id,
    required this.title,
    required this.isCompleted,
    required this.day,
  });

  // Convert Task to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'isCompleted': isCompleted,
      'day': day,
    };
  }

  // Create Task from JSON
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      isCompleted: json['isCompleted'],
      day: json['day'],
    );
  }
}