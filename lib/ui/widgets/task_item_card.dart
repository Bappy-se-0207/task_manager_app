import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Data/Models/task.dart';
import '../../Data/network_caller/network_caller.dart';
import '../../Data/utility/urls.dart';

enum TaskStatus {
  New,
  Progress,
  Completed,
  Cancelled,
}

class TaskController extends GetxController {
  final showProgress = false.obs;

  Future<void> updateTaskStatus(Task task, String status) async {
    showProgress.value = true;
    final response = await NetworkCaller()
        .getRequest(Urls.updateTaskStatus(task.sId ?? '', status));
    if (response.isSuccess) {
      // Assuming you have a function to update the task status
      // You can call that function here
    }
    showProgress.value = false;
  }
}

class TaskItemCard extends StatelessWidget {
  final Task task;
  final TaskController taskController = Get.find();

  TaskItemCard({
    Key? key,
    required this.task,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              task.title ?? '',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            Text(task.description ?? ''),
            Text('Date : ${task.createdDate}'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Chip(
                  label: Text(
                    task.status ?? 'New',
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.blue,
                ),
                Wrap(
                  children: [
                    IconButton(
                      onPressed: () {
                        // Handle delete logic here
                      },
                      icon: const Icon(Icons.delete_forever_outlined),
                    ),
                    IconButton(
                      onPressed: () {
                        taskController.updateTaskStatus(task, showUpdateStatusModal);
                      },
                      icon: const Icon(Icons.edit),
                    ),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  void showUpdateStatusModal() {
    List<ListTile> items = TaskStatus.values
        .map((e) => ListTile(
      title: Text(e.toString().split('.').last),
      onTap: () {
        taskController.updateTaskStatus(task, e.toString().split('.').last);
        Get.back();
      },
    ))
        .toList();

    Get.defaultDialog(
      title: 'Update status',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: items,
      ),
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
          },
          child: const Text(
            'Cancel',
            style: TextStyle(
              color: Colors.blueGrey,
            ),
          ),
        ),
      ],
    );
  }
}
