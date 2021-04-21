import 'package:flutter/material.dart';
import 'package:neyasis_flutter_boilerplate/constants/app_mode.dart';

class Application {
  static GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();
  static int versionCode = 0; //Updated from env.json file.
  static String versionName = ""; //Updated from env.json file.
  static String name = "Neyasis Boilerplate"; //Updated from env.json file.
  static String apiBaseUrl = ""; ///Updated from env.json file.
  static AppMode appMode = AppMode.unknown; //Updated from env.json file.

  static get context => navigatorKey.currentContext;
}
