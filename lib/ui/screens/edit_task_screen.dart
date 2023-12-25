import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../Data/Models/user_model.dart';
import '../../Data/network_caller/network_caller.dart';
import '../../Data/network_caller/netwrok_response.dart';
import '../../Data/utility/urls.dart';
import '../controllers/auth_controller.dart';
import '../widgets/body_background.dart';
import '../widgets/profile_summary_card.dart';
import '../widgets/snack_message.dart';

class EditProfileScreen extends StatelessWidget {
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _firstNameTEController = TextEditingController();
  final TextEditingController _lastNameTEController = TextEditingController();
  final TextEditingController _mobileTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();

  final RxBool _updateProfileInProgress = false.obs;
  final Rx<XFile?> photo = Rx<XFile?>(null);

  @override
  Widget build(BuildContext context) {
    _initializeControllers();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const ProfileSummaryCard(
              enableOnTap: false,
            ),
            Expanded(
              child: BodyBackground(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 32,
                        ),
                        Text(
                          'Update Profile',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        _photoPickerField(),
                        const SizedBox(
                          height: 8,
                        ),
                        _buildTextFormField(
                          controller: _emailTEController,
                          hintText: 'Email',
                          validator: (value) {
                            if (value.trim().isEmpty) {
                              return 'Enter your email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        _buildTextFormField(
                          controller: _firstNameTEController,
                          hintText: 'First name',
                          validator: (value) {
                            if (value.trim().isEmpty) {
                              return 'Enter your first name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        _buildTextFormField(
                          controller: _lastNameTEController,
                          hintText: 'Last name',
                          validator: (value) {
                            if (value.trim().isEmpty) {
                              return 'Enter your last name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        _buildTextFormField(
                          controller: _mobileTEController,
                          hintText: 'Mobile',
                          validator: (value) {
                            if (value.trim().isEmpty) {
                              return 'Enter your mobile number';
                            }
                            if (value.trim().length != 11) {
                              return 'Mobile number must be 11 digits long';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        _buildTextFormField(
                          controller: _passwordTEController,
                          hintText: 'Password (optional)',
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Enter your password';
                            }
                            if (value.length < 6) {
                              return 'Enter password more than 6 letters';
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
                                () => Visibility(
                              visible: !_updateProfileInProgress.value,
                              replacement: const Center(
                                child: CircularProgressIndicator(),
                              ),
                              child: ElevatedButton(
                                onPressed: _updateProfile,
                                child: const Icon(Icons.arrow_circle_right_outlined),
                              ),
                            ),
                          ),
                        ),
                      ],
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

  void _initializeControllers() {
    _emailTEController.text = AuthController.user?.email ?? '';
    _firstNameTEController.text = AuthController.user?.firstName ?? '';
    _lastNameTEController.text = AuthController.user?.lastName ?? '';
    _mobileTEController.text = AuthController.user?.mobile ?? '';
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String hintText,
    required FormFieldValidator<String>? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(hintText: hintText),
      validator: validator,
    );
  }

  Future<void> _updateProfile() async {
    _updateProfileInProgress.value = true;
    String? photoInBase64;
    Map<String, dynamic> inputData = {
      "firstName": _firstNameTEController.text.trim(),
      "lastName": _lastNameTEController.text.trim(),
      "email": _emailTEController.text.trim(),
      "mobile": _mobileTEController.text.trim(),
    };

    if (_passwordTEController.text.isNotEmpty) {
      inputData['password'] = _passwordTEController.text;
    }

    if (photo.value != null) {
      List<int> imageBytes = await photo.value!.readAsBytes();
      photoInBase64 = base64Encode(imageBytes);
      inputData['photo'] = photoInBase64;
    }

    final NetworkResponse response = await NetworkCaller().postRequest(
      Urls.updateProfile,
      body: inputData,
    );
    _updateProfileInProgress.value = false;

    if (response.isSuccess) {
      AuthController.updateUserInformation(UserModel(
        email: _emailTEController.text.trim(),
        firstName: _firstNameTEController.text.trim(),
        lastName: _lastNameTEController.text.trim(),
        mobile: _mobileTEController.text.trim(),
        photo: photoInBase64 ?? AuthController.user?.photo,
      ));
      showSnackMessage(context, 'Update profile success!');
    } else {
      showSnackMessage(context, 'Update profile failed. Try again.');
    }
  }

  Widget _photoPickerField() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              height: 50,
              decoration: const BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                ),
              ),
              alignment: Alignment.center,
              child: const Text(
                'Photo',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: InkWell(
              onTap: () async {
                final XFile? image = await ImagePicker().pickImage(
                  source: ImageSource.camera,
                  imageQuality: 50,
                );
                if (image != null) {
                  photo.value = image;
                }
              },
              child: Container(
                padding: const EdgeInsets.only(left: 16),
                child: Obx(
                      () => Visibility(
                    visible: photo.value == null,
                    replacement: Text(photo.value?.name ?? ''),
                    child: const Text('Select a photo'),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
