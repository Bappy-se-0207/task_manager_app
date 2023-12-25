import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager_project/ui/screens/progress_tasks_screen.dart';

import 'cancelled_task_screen.dart';
import 'completed_task_screen.dart';
import 'new_task_screen.dart';

class MainBottomNavScreen extends StatelessWidget {
  final RxInt selectedIndex = 0.obs;

  final List<Widget> _screens = const [
    NewTasksScreen(),
    ProgressTasksScreen(),
    CompletedTasksScreen(),
    CancelledTasksScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => _screens[selectedIndex.value]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex.value,
        onTap: (index) => selectedIndex.value = index,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.abc), label: 'New'),
          BottomNavigationBarItem(
              icon: Icon(Icons.change_circle_outlined), label: 'In Progress'),
          BottomNavigationBarItem(icon: Icon(Icons.done), label: 'Completed'),
          BottomNavigationBarItem(icon: Icon(Icons.close), label: 'Cancelled'),
        ],
      ),
    );
  }
}
