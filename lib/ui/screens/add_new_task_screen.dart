import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Data/network_caller/network_caller.dart';
import '../../Data/network_caller/network_response.dart';
import '../../Data/utility/urls.dart';
import '../widgets/body_background.dart';
import '../widgets/profile_summary_card.dart';
import '../widgets/snack_message.dart';

class AddNewTaskScreen extends GetView<AddNewTaskController> {
  const AddNewTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const ProfileSummaryCard(),
            Expanded(
              child: BodyBackground(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: controller.formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 32,
                          ),
                          Text(
                            'Add New Task',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          TextFormField(
                            controller: controller.subjectTEController,
                            decoration: const InputDecoration(hintText: 'Subject'),
                            validator: (String? value) {
                              if (value?.trim().isEmpty ?? true) {
                                return 'Enter your subject';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          TextFormField(
                            controller: controller.descriptionTEController,
                            maxLines: 8,
                            decoration: const InputDecoration(
                                hintText: 'Description'),
                            validator: (String? value) {
                              if (value?.trim().isEmpty ?? true) {
                                return 'Enter your description';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: Obx(() {
                              return Visibility(
                                visible: !controller.createTaskInProgress,
                                replacement: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                                child: ElevatedButton(
                                  onPressed: controller.createTask,
                                  child: const Icon(Icons.arrow_circle_right_outlined),
                                ),
                              );
                            }),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class AddNewTaskController extends GetxController {
  final TextEditingController subjectTEController = TextEditingController();
  final TextEditingController descriptionTEController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final RxBool createTaskInProgress = false.obs;
  final RxBool newTaskAdded = false.obs;

  void createTask() async {
    if (formKey.currentState!.validate()) {
      createTaskInProgress.value = true;

      final NetworkResponse response = await NetworkCaller().postRequest(
        Urls.createNewTask,
        body: {
          "title": subjectTEController.text.trim(),
          "description": descriptionTEController.text.trim(),
          "status": "New",
        },
      );

      createTaskInProgress.value = false;

      if (response.isSuccess) {
        newTaskAdded.value = true;
        subjectTEController.clear();
        descriptionTEController.clear();
        showSnackMessage(Get.context!, 'New task added!');
      } else {
        showSnackMessage(Get.context!, 'Create new task failed! Try again.', true);
      }
    }
  }

  @override
  void dispose() {
    descriptionTEController.dispose();
    subjectTEController.dispose();
    super.dispose();
  }
}
