import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(MyApp());
}

class Task {
  final int id;
  final String title;
  final String description;
  bool isCompleted;

  Task({
    required this.id,
    required this.title,
    required this.description,
    this.isCompleted = false,
  });
}

class TaskController extends GetxController {
  final List<Task> tasks = <Task>[].obs;

  void addTask(Task task) {
    tasks.add(task);
  }

  void toggleTaskCompletion(int taskId) {
    final task = tasks.firstWhere((t) => t.id == taskId);
    task.isCompleted = !task.isCompleted;
  }

  void deleteTask(int taskId) {
    tasks.removeWhere((t) => t.id == taskId);
  }
}

class TaskListScreen extends StatelessWidget {
  final TaskController taskController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Task Manager')),
      body: GetBuilder<TaskController>(
        builder: (controller) {
          return ListView.builder(
            itemCount: controller.tasks.length,
            itemBuilder: (context, index) {
              final task = controller.tasks[index];
              return ListTile(
                title: Text(task.title),
                subtitle: Text(task.description),
                trailing: Checkbox(
                  value: task.isCompleted,
                  onChanged: (_) => controller.toggleTaskCompletion(task.id),
                ),
                onLongPress: () => controller.deleteTask(task.id),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed('/addTask'),
        child: Icon(Icons.add),
      ),
    );
  }
}

class AddTaskScreen extends StatelessWidget {
  final TaskController taskController = Get.find();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  void _addTask() {
    final title = titleController.text;
    final description = descriptionController.text;
    if (title.isNotEmpty && description.isNotEmpty) {
      final newTask = Task(
        id: DateTime.now().millisecondsSinceEpoch,
        title: title,
        description: description,
      );
      taskController.addTask(newTask);
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Task')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _addTask,
              child: Text('Add Task'),
            ),
          ],
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Task Manager',
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => TaskListScreen()),
        GetPage(name: '/addTask', page: () => AddTaskScreen()),
      ],
      home: TaskListScreen(),
    );
  }
}
