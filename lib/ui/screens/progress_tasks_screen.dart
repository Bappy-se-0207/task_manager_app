import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Data/Models/task_list_model.dart';
import '../../Data/network_caller/network_caller.dart';
import '../../Data/network_caller/netwrok_response.dart';
import '../../Data/utility/urls.dart';
import '../widgets/profile_summary_card.dart';
import '../widgets/task_item_card.dart';

class ProgressTasksController extends GetxController {
  var getProgressTaskInProgress = false.obs;
  var taskListModel = TaskListModel().obs;

  Future<void> getProgressTaskList() async {
    getProgressTaskInProgress.value = true;
    final NetworkResponse response =
    await NetworkCaller().getRequest(Urls.getProgressTasks);
    if (response.isSuccess) {
      taskListModel.value = TaskListModel.fromJson(response.jsonResponse);
    }
    getProgressTaskInProgress.value = false;
  }

  @override
  void onInit() {
    super.onInit();
    getProgressTaskList();
  }
}

class ProgressTasksScreen extends StatelessWidget {
  final ProgressTasksController controller = Get.put(ProgressTasksController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const ProfileSummaryCard(),
            Expanded(
              child: Obx(
                    () => Visibility(
                  visible: !controller.getProgressTaskInProgress.value,
                  replacement: const Center(child: CircularProgressIndicator()),
                  child: RefreshIndicator(
                    onRefresh: () => controller.getProgressTaskList(),
                    child: ListView.builder(
                      itemCount: controller.taskListModel.value.taskList?.length ?? 0,
                      itemBuilder: (context, index) {
                        return TaskItemCard(
                          task: controller.taskListModel.value.taskList![index],
                          onStatusChange: () {
                            controller.getProgressTaskList();
                          },
                          showProgress: (inProgress) {
                            controller.getProgressTaskInProgress.value = inProgress;
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
