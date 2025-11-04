import './task.dart';

class Plan {
  final String name;
  final List<Task> tasks;
  
  const Plan({this.name = '', this.tasks = const []});
  // langkah 3 start
  int get completedCount => tasks.where((task) => task.complete).length;

  String get completenessMessage => '$completedCount out of ${tasks.length} tasks';
  // langkah 3 end
}