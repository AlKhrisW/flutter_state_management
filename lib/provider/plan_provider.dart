import 'package:flutter/material.dart';
import '../models/data_layer.dart';

// langkah 1 start
class PlanProvider extends InheritedNotifier<ValueNotifier<List<Plan>>> {
  const PlanProvider({super.key, required Widget child, required ValueNotifier<List<Plan>> notifier}) : super(child: child, notifier: notifier);

  static ValueNotifier<List<Plan>> of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<PlanProvider>()!.notifier!;
  }
}
// langkah 1 end