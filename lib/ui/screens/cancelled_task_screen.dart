import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/profile_summary_card.dart';

class CancelledTasksController extends GetxController {
  // Add your controller logic here if needed
}

class CancelledTasksScreen extends StatelessWidget {
  final CancelledTasksController _controller = Get.put(CancelledTasksController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const ProfileSummaryCard(),
            Expanded(
              child: Obx(
                    () => ListView.builder(
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    // You can access and update state using _controller
                    // Example: _controller.someValue
                    // return const TaskItemCard();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
