import 'package:chatkuy/widgets/snackbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

DateTime? currentBackPressTime;

class Helper {
  static String userLoggedInKey = 'LOGGEDINKEY';
  static String userNameKey = 'USERNAMEKEY';
  static String userEmailKey = 'USEREMAILKEY';
  static String userProfilePicture = 'USERPROFILEPICTURE';

  static Future<bool> saveUserLoggedInStatus(bool isLogin) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setBool(userLoggedInKey, isLogin);
  }

  static Future<bool> saveUsernameSF(String username) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userNameKey, username);
  }

  static Future<bool> saveUserEmailSF(String email) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userEmailKey, email);
  }

  static Future<bool> saveProfilePictureSF(String profilePicture) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userProfilePicture, profilePicture);
  }

  static Future<bool?> getUserLoggedInStatus() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getBool(userLoggedInKey);
  }

  static Future<String?> getUserEmailFromSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(userEmailKey);
  }

  static Future<String?> getUsernameFromSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(userNameKey);
  }

  static Future<String?> getProfilePictureFromSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(userProfilePicture);
  }

  static Future sfReload() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    return await localStorage.reload();
  }

  static Future<bool> onWillPop(BuildContext context) {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      showSnackbar(
          context, Colors.green, 'Tekan sekali lagi untuk menutup aplikasi');
      return Future.value(false);
    }
    return Future.value(true);
  }
}
