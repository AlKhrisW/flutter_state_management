import '../models/data_layer.dart';
import 'package:flutter/material.dart';
import '../provider/plan_provider.dart';

class PlanScreen extends StatefulWidget {
  // langkah 3 start
  final Plan plan;
  const PlanScreen({super.key, required this.plan});
  // langkah 3 end

  @override
  State createState() => _PlanScreenState();
}

// langkah 5 start
class _PlanScreenState extends State<PlanScreen> {
  late ScrollController scrollController;
  Plan get plan => widget.plan;
  // langkah 5 end

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController()
      ..addListener(() {
        FocusScope.of(context).requestFocus(FocusNode());
      });
  }
  
  // langkah 7 start
  @override
  Widget build(BuildContext context) {
    ValueNotifier<List<Plan>> plansNotifier = PlanProvider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          plan.name)),
      body: ValueListenableBuilder<List<Plan>>(
        valueListenable: plansNotifier,
        builder: (context, plans, child) {
          Plan currentPlan = plans.firstWhere((p) => p.name == plan.name);
          return Column(
            children: [
              Expanded(child: _buildList(currentPlan, plansNotifier)),
              SafeArea(child: Text(currentPlan.completenessMessage)),
            ],
          );
        },
      ),
      floatingActionButton: _buildAddTaskButton(context, plansNotifier),
    );
  }

  Widget _buildAddTaskButton(BuildContext context, ValueNotifier<List<Plan>> planNotifier) {
    return FloatingActionButton(
      backgroundColor: Colors.deepPurple,
      child: const Icon(Icons.add),
      onPressed: () {
        Plan currentPlan = planNotifier.value
            .firstWhere((p) => p.name == widget.plan.name, orElse: () => widget.plan);

        int planIndex =
            planNotifier.value.indexWhere((p) => p.name == currentPlan.name);

        List<Task> updatedTasks = List<Task>.from(currentPlan.tasks)
          ..add(const Task());

        // update notifier agar rebuild
        planNotifier.value = List<Plan>.from(planNotifier.value)
          ..[planIndex] = Plan(
            name: currentPlan.name,
            tasks: updatedTasks,
          );
      },
    );
  }
  // langkah 7 end

  Widget _buildList(Plan plan, ValueNotifier<List<Plan>> planNotifier) {
    return ListView.builder(
      controller: scrollController,
      itemCount: plan.tasks.length,
      itemBuilder: (context, index) => _buildTaskTile(plan, plan.tasks[index], index, planNotifier),
    );
  }

  // langkah 8 start
  Widget _buildTaskTile(Plan plan, Task task, int index, ValueNotifier<List<Plan>> planNotifier) {
    return ListTile(
      leading: Checkbox(
        value: task.complete,
        onChanged: (selected) {
          int planIndex =
              planNotifier.value.indexWhere((p) => p.name == plan.name);

          List<Task> updatedTasks = List<Task>.from(plan.tasks)
            ..[index] = Task(
              description: task.description,
              complete: selected ?? false,
            );

          planNotifier.value = List<Plan>.from(planNotifier.value)
            ..[planIndex] = Plan(
              name: plan.name,
              tasks: updatedTasks,
            );
        },
      ),
      title: TextFormField(
        initialValue: task.description,
        onChanged: (text) {
          int planIndex =
              planNotifier.value.indexWhere((p) => p.name == plan.name);

          List<Task> updatedTasks = List<Task>.from(plan.tasks)
            ..[index] = Task(
              description: text,
              complete: task.complete,
            );

          planNotifier.value = List<Plan>.from(planNotifier.value)
            ..[planIndex] = Plan(
              name: plan.name,
              tasks: updatedTasks,
            );
        },
      ),
    );
  }
  // langkah 8 end

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}