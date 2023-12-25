import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager_project/ui/screens/sign_up_screen.dart';
import '../../Data/Models/user_model.dart';
import '../../Data/network_caller/network_caller.dart';
import '../../Data/network_caller/netwrok_response.dart';
import '../../Data/utility/urls.dart';
import '../controllers/auth_controller.dart';
import '../widgets/body_background.dart';
import '../widgets/snack_message.dart';
import 'forgot_password_screen.dart';
import 'main_bottom_nav_screen.dart';

class LoginScreen extends GetWidget<AuthController> {
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BodyBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 80,
                    ),
                    Text(
                      'Get Started with',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    TextFormField(
                      controller: _emailTEController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        hintText: 'Email',
                      ),
                      validator: (String? value) {
                        if (value?.trim().isEmpty ?? true) {
                          return 'Enter valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      controller: _passwordTEController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        hintText: 'Password',
                      ),
                      validator: (String? value) {
                        if (value?.isEmpty ?? true) {
                          return 'Enter valid password';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Obx(
                            () => ElevatedButton(
                          onPressed: controller.loginInProgress.value
                              ? null
                              : () => login(),
                          child: const Icon(Icons.arrow_circle_right_outlined),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 48,
                    ),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          Get.to(() => const ForgotPasswordScreen());
                        },
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Don't have an account?",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black54),
                        ),
                        TextButton(
                          onPressed: () {
                            Get.to(() => const SignUpScreen());
                          },
                          child: const Text(
                            'Sign Up',
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

  Future<void> login() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    controller.setLoginInProgress(true);

    NetworkResponse response = await NetworkCaller().postRequest(Urls.login,
        body: {
          'email': _emailTEController.text.trim(),
          'password': _passwordTEController.text,
        },
        isLogin: true);

    controller.setLoginInProgress(false);

    if (response.isSuccess) {
      await AuthController.saveUserInformation(
        response.jsonResponse['token'],
        UserModel.fromJson(response.jsonResponse['data']),
      );
      Get.offAll(() => const MainBottomNavScreen());
    } else {
      if (response.statusCode == 401) {
        showSnackMessage('Please check email/password');
      } else {
        showSnackMessage('Login failed. Try again');
      }
    }
  }

  @override
  void dispose() {
    _emailTEController.dispose();
    _passwordTEController.dispose();
    super.dispose();
  }
}
