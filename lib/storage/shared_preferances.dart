import '../model/storage/user_information.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSharedPreferences {
  static Future<SharedPreferences> get _sp async =>
      await SharedPreferences.getInstance();

  static Future<UserInformation?> getUserInformation() async {
    SharedPreferences sp = await _sp;
    String? userInformation = sp.getString("__USER_INFORMATION__");
    if (userInformation == null) return null;
    return UserInformation.fromStorage(userInformation);
  }

  static Future<void> setUserInformation(
      UserInformation userInformation) async {
    SharedPreferences sp = await _sp;
    await sp.setString(
        "__USER_INFORMATION__", userInformation.toJSON(userInformation));
  }
}
