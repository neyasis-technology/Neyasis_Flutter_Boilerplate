import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../bloc/api/list.dart';
import '../constants/app.dart';
import '../constants/app_mode.dart';
import 'home.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    _getApplicationConstants();
    super.initState();
  }

  _getApplicationConstants() async {
    String environmentString = await rootBundle.loadString('.env.json');
    Map environment = jsonDecode(environmentString);
    Application.appMode = AppMode.values[environment["environmentMode"]];
    late String platformKey;
    if (kIsWeb) {
      platformKey = "web";
    } else if (Platform.isAndroid) {
      platformKey = "android";
    } else {
      platformKey = "ios";
    }
    Application.apiBaseUrl =
        environment["apiBaseUrl"][Application.appMode.path];
    Application.versionName =
        environment["versionName"][Application.appMode.path][platformKey];
    Application.versionCode =
        environment["versionCode"][Application.appMode.path][platformKey];
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => HomeScreen()),
      (route) => false,
    );
    listBloc.call(sinkNullObject: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('SPLASH SCREEN'),
      ),
    );
  }
}
