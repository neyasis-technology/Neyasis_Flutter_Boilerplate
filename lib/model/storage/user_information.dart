import 'dart:convert';

import 'package:neyasis_flutter_boilerplate/helpers/functions.dart';
import 'package:neyasis_flutter_boilerplate/model/bloc/api/login/response.dart';

class UserInformation {
  String token;
  String refreshToken;
  String fullname;
  int id;

  UserInformation({
    required this.token,
    required this.refreshToken,
    required this.fullname,
    required this.id,
  });

  factory UserInformation.fromLoginResponse(LoginResponseBM loginResponseBM) {
    Map<String, dynamic> claims = AppFunctions.jwtParser(loginResponseBM.token);
    return UserInformation(
      token: loginResponseBM.token,
      refreshToken: loginResponseBM.refreshToken,
      fullname: claims["username"],
      id: claims["id"],
    );
  }

  factory UserInformation.fromStorage(String storageValue) {
    Map<String, String> storageObject = jsonDecode(storageValue);
    Map<String, dynamic> claims = AppFunctions.jwtParser(storageObject["token"] ?? "");
    return UserInformation(
      token: storageObject["token"] ?? "",
      refreshToken: storageObject["refreshToken"] ?? "",
      fullname: claims["username"],
      id: claims["id"],
    );
  }

  String toJSON(UserInformation userInformation) {
    return jsonEncode({
      "token": userInformation.token,
      "refreshToken": userInformation.refreshToken,
    });
  }
}
