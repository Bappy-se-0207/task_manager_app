import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/profile_summary_card.dart';

class CompletedTasksController extends GetxController {
  // Add any state or logic needed for this screen
}

class CompletedTasksScreen extends StatelessWidget {
  final CompletedTasksController _controller = Get.put(CompletedTasksController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const ProfileSummaryCard(),
            Expanded(
              child: GetBuilder<CompletedTasksController>(
                builder: (controller) {
                  return ListView.builder(
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      // You can access the controller's state and methods here
                      // Example: controller.someState or controller.someMethod()
                      // return const TaskItemCard();
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
