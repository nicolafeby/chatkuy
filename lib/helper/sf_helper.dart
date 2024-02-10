import 'package:shared_preferences/shared_preferences.dart';

DateTime? currentBackPressTime;

class SfHelper {
  static String userLoggedInKey = 'LOGGEDIN_KEY';
  static String fullNameKey = 'FULL_NAME_KEY';
  static String userEmailKey = 'USER_EMAIL_KEY';
  static String userProfilePictureKey = 'USER_PROFILE_PICTURE';
  static String userNameKey = 'USERNAME_KEY';

  static Future<bool> saveUserLoggedInStatus(bool isLogin) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setBool(userLoggedInKey, isLogin);
  }

  static Future<bool> saveFullNameSF(String fullName) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(fullNameKey, fullName);
  }

  static Future<bool> saveUserEmailSF(String email) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userEmailKey, email);
  }

  static Future<bool> saveProfilePictureSF(String profilePicture) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userProfilePictureKey, profilePicture);
  }

  static Future<bool> saveUsernameSF(String username) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userNameKey, username);
  }

  static Future<bool?> getUserLoggedInStatus() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getBool(userLoggedInKey);
  }

  static Future<String?> getUserEmailFromSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(userEmailKey);
  }

  static Future<String?> getFullNameFromSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(fullNameKey);
  }

  static Future<String?> getProfilePictureFromSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(userProfilePictureKey);
  }

  static Future<String?> getUsernameFromSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(userNameKey);
  }

  static Future sfReload() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    return await localStorage.reload();
  }
}
