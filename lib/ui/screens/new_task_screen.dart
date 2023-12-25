import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Data/Models/task_count.dart';
import '../../Data/Models/task_count_summary_list.dart';
import '../../Data/Models/task_list_model.dart';
import '../../Data/network_caller/network_caller.dart';
import '../../Data/network_caller/netwrok_response.dart';
import '../../Data/utility/urls.dart';
import '../widgets/profile_summary_card.dart';
import '../widgets/summary_card.dart';
import '../widgets/task_item_card.dart';
import 'add_new_task_screen.dart';

class NewTasksController extends GetxController {
  RxBool getNewTaskInProgress = false.obs;
  RxBool getTaskCountSummaryInProgress = false.obs;
  Rx<TaskListModel> taskListModel = TaskListModel().obs;
  Rx<TaskCountSummaryListModel> taskCountSummaryListModel =
      TaskCountSummaryListModel().obs;

  Future<void> getTaskCountSummaryList() async {
    getTaskCountSummaryInProgress.value = true;
    update();
    final NetworkResponse response =
    await NetworkCaller().getRequest(Urls.getTaskStatusCount);
    if (response.isSuccess) {
      taskCountSummaryListModel.value =
          TaskCountSummaryListModel.fromJson(response.jsonResponse);
    }
    getTaskCountSummaryInProgress.value = false;
    update();
  }

  Future<void> getNewTaskList() async {
    getNewTaskInProgress.value = true;
    update();
    final NetworkResponse response =
    await NetworkCaller().getRequest(Urls.getNewTasks);
    if (response.isSuccess) {
      taskListModel.value = TaskListModel.fromJson(response.jsonResponse);
    }
    getNewTaskInProgress.value = false;
    update();
  }
}

class NewTasksScreen extends GetView<NewTasksController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final response = await Get.to(() => const AddNewTaskScreen());

          if (response != null && response == true) {
            controller.getNewTaskList();
            controller.getTaskCountSummaryList();
          }
        },
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const ProfileSummaryCard(),
            Obx(
                  () => Visibility(
                visible: !controller.getTaskCountSummaryInProgress.value &&
                    (controller.taskCountSummaryListModel.value.taskCountList?.isNotEmpty ??
                        false),
                replacement: const LinearProgressIndicator(),
                child: SizedBox(
                  height: 120,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.taskCountSummaryListModel.value.taskCountList?.length ?? 0,
                    itemBuilder: (context, index) {
                      TaskCount taskCount =
                      controller.taskCountSummaryListModel.value.taskCountList![index];
                      return FittedBox(
                        child: SummaryCard(
                          count: taskCount.sum.toString(),
                          title: taskCount.sId ?? '',
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            Expanded(
              child: Obx(
                    () => Visibility(
                  visible: !controller.getNewTaskInProgress.value,
                  replacement: const Center(child: CircularProgressIndicator()),
                  child: RefreshIndicator(
                    onRefresh: () => controller.getNewTaskList(),
                    child: ListView.builder(
                      itemCount: controller.taskListModel.value.taskList?.length ?? 0,
                      itemBuilder: (context, index) {
                        return TaskItemCard(
                          task: controller.taskListModel.value.taskList![index],
                          onStatusChange: () {
                            controller.getNewTaskList();
                          },
                          showProgress: (inProgress) {
                            controller.getNewTaskInProgress.value = inProgress;
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
