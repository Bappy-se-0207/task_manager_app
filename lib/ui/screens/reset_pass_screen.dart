import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager_project/ui/screens/pin_varification_screen.dart';

import '../widgets/body_background.dart';
import 'login_screen.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({Key? key}) : super(key: key);

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  void _confirmButtonPressed() {
    // Add your logic for handling password confirmation here
    // For example, you can check if passwords match and meet the required criteria
    Get.to(const PinVerificationScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BodyBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 80,
                  ),
                  Text(
                    'Set Password',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  const Text(
                    'Minimum password length should be more than 8 letters',
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  TextFormField(
                    controller: passwordController,
                    decoration: const InputDecoration(
                      hintText: 'Password',
                    ),
                  ),
                  TextFormField(
                    controller: confirmPasswordController,
                    decoration: const InputDecoration(
                      hintText: 'Confirm Password',
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _confirmButtonPressed,
                      child: const Text('Confirm'),
                    ),
                  ),
                  const SizedBox(
                    height: 48,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Have an account?',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black54,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Get.offAll(() => const LoginScreen());
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
    );
  }
}
