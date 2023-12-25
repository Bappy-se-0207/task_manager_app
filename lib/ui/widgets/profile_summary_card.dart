import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../controllers/auth_controller.dart';
import '../screens/edit_task_screen.dart';
import '../screens/login_screen.dart';

class ProfileSummaryCard extends StatelessWidget {
  const ProfileSummaryCard({
    Key? key,
    this.enableOnTap = true,
  }) : super(key: key);

  final bool enableOnTap;

  @override
  Widget build(BuildContext context) {
    Uint8List imageBytes =
        const Base64Decoder().convert(AuthController.user?.photo ?? '');

    return ListTile(
      onTap: () {
        if (enableOnTap) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const EditProfileScreen(),
            ),
          );
        }
      },
      leading: CircleAvatar(
        child: AuthController.user?.photo == null
            ? const Icon(Icons.person)
            : ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Image.memory(
                  imageBytes,
                  fit: BoxFit.cover,
                ),
              ),
      ),
      title: Text(
        fullName,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
      subtitle: Text(
        AuthController.user?.email ?? '',
        style: const TextStyle(color: Colors.white),
      ),
      trailing: IconButton(
        onPressed: () async {
          await AuthController.clearAuthData();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        },
        icon: const Icon(Icons.logout),
      ),
      tileColor: Colors.green,
    );
  }

  String get fullName {
    return '${AuthController.user?.firstName ?? ''} ${AuthController.user?.lastName ?? ''}';
  }
}
