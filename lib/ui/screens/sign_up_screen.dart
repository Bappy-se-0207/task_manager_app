import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Data/network_caller/network_caller.dart';
import '../../Data/network_caller/netwrok_response.dart';
import '../../Data/utility/urls.dart';
import '../widgets/body_background.dart';
import '../widgets/snack_message.dart';

class SignUpController extends GetxController {
  final TextEditingController emailTEController = TextEditingController();
  final TextEditingController firstNameTEController = TextEditingController();
  final TextEditingController lastNameTEController = TextEditingController();
  final TextEditingController mobileTEController = TextEditingController();
  final TextEditingController passwordTEController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final RxBool signUpInProgress = false.obs;

  Future<void> signUp() async {
    if (formKey.currentState!.validate()) {
      signUpInProgress.value = true;
      final NetworkResponse response = await NetworkCaller().postRequest(
        Urls.registration,
        body: {
          "firstName": firstNameTEController.text.trim(),
          "lastName": lastNameTEController.text.trim(),
          "email": emailTEController.text.trim(),
          "password": passwordTEController.text,
          "mobile": mobileTEController.text.trim(),
        },
      );
      signUpInProgress.value = false;

      if (response.isSuccess) {
        clearTextFields();
        showSnackMessage('Account has been created! Please login.');
      } else {
        showSnackMessage('Account creation failed! Please try again.', true);
      }
    }
  }

  void clearTextFields() {
    emailTEController.clear();
    firstNameTEController.clear();
    lastNameTEController.clear();
    mobileTEController.clear();
    passwordTEController.clear();
  }
}

class SignUpScreen extends GetView<SignUpController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BodyBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: SingleChildScrollView(
              child: Form(
                key: controller.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 80,
                    ),
                    Text(
                      'Join With Us',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    TextFormField(
                      controller: controller.emailTEController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        hintText: 'Email',
                      ),
                      validator: (String? value) {
                        // Validation logic remains unchanged
                      },
                    ),
                    // ... (Repeat for other form fields)
                    const SizedBox(
                      height: 16,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Obx(
                            () => Visibility(
                          visible: !controller.signUpInProgress.value,
                          replacement: const Center(
                            child: CircularProgressIndicator(),
                          ),
                          child: ElevatedButton(
                            onPressed: controller.signUp,
                            child: const Icon(Icons.arrow_circle_right_outlined),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 48,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Have an account?",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black54),
                        ),
                        TextButton(
                          onPressed: () {
                            Get.back(); // Using GetX for navigation
                          },
                          child: const Text(
                            'Sign In',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
