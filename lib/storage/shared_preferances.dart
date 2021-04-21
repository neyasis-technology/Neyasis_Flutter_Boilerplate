import 'package:neyasis_flutter_boilerplate/model/storage/user_information.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSharedPreferences {
  static Future<SharedPreferences> get _SP async => await SharedPreferences.getInstance();

  static Future<UserInformation?> getUserInformation() async {
    SharedPreferences sp = await _SP;
    String? userInformation = sp.getString("__USER_INFORMATION__");
    if (userInformation == null) return null;
    return UserInformation.fromStorage(userInformation);
  }

  static Future<void> setUserInformation(UserInformation userInformation) async {
    SharedPreferences sp = await _SP;
    await sp.setString("__USER_INFORMATION__", userInformation.toJSON(userInformation));
  }
}
