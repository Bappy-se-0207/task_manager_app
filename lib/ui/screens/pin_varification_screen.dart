import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:task_manager_project/ui/screens/reset_pass_screen.dart';

import '../widgets/body_background.dart';
import 'login_screen.dart';

class PinVerificationController extends GetxController {
  final RxString pin = ''.obs;

  void onPinChanged(String value) {
    pin.value = value;
  }

  void onPinCompleted(String value) {
    print("Completed");
    // You can add additional logic here when pin is completed
  }

  void verifyPin() {
    Get.to(() => const ResetPasswordScreen());
  }
}

class PinVerificationScreen extends StatelessWidget {
  final PinVerificationController controller = Get.put(PinVerificationController());

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
                    'Pin Verification',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  const Text(
                    'A 6 digit OTP will be sent to your email address',
                    style: TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Obx(() => PinCodeTextField(
                    length: 6,
                    obscureText: false,
                    animationType: AnimationType.fade,
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(5),
                      fieldHeight: 50,
                      fieldWidth: 40,
                      activeFillColor: Colors.white,
                      activeColor: Colors.green,
                      selectedFillColor: Colors.white,
                      inactiveFillColor: Colors.white,
                    ),
                    animationDuration: const Duration(milliseconds: 300),
                    enableActiveFill: true,
                    onCompleted: controller.onPinCompleted,
                    onChanged: controller.onPinChanged,
                    beforeTextPaste: (text) {
                      return true;
                    },
                    appContext: context,
                  )),
                  const SizedBox(
                    height: 16,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: controller.verifyPin,
                      child: const Text('Verify'),
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
