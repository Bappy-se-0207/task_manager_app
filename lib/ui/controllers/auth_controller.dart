import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Data/Models/user_model.dart';

class AuthController extends GetxController {
  static AuthController get to => Get.find();

  RxString? token = ''.obs;
  Rx<UserModel?> user = Rx<UserModel?>(null);

  Future<void> saveUserInformation(String t, UserModel model) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString('token', t);
    await sharedPreferences.setString('user', jsonEncode(model.toJson()));
    token = t.obs;
    user.value = model;
  }

  Future<void> updateUserInformation(UserModel model) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString('user', jsonEncode(model.toJson()));
    user.value = model;
  }

  Future<void> initializeUserCache() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    token = sharedPreferences.getString('token')?.obs;
    user.value = UserModel.fromJson(
        jsonDecode(sharedPreferences.getString('user') ?? '{}'));
  }

  Future<bool> checkAuthState() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.containsKey('token')) {
      await initializeUserCache();
      return true;
    }
    return false;
  }

  Future<void> clearAuthData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.clear();
    token = ''.obs;
    user.value = null;
  }
}
