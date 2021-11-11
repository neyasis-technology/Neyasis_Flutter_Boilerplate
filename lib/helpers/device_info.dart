import 'package:flutter/material.dart';
import '../constants/app.dart';

class DeviceInfo {
  static double width(double width) {
    return MediaQuery.of(Application.context).size.width / 100.0 * width;
  }

  static double height(double height) {
    return MediaQuery.of(Application.context).size.height / 100.0 * height;
  }
}
