import 'dart:convert';
import 'dart:io';

import 'app_mode.dart';
import 'helpers.dart';

main() async {
  Map environment = jsonDecode(await File('../.env.json').readAsString());
  String bundleId = '';
  int versionCode = 1;
  String versionName = '';
  String appName = environment["applicationName"];

  ProjectScriptAppMode appMode = ProjectScriptAppMode.values[environment["environmentMode"]];
  switch (appMode) {
    case ProjectScriptAppMode.development:
      bundleId = environment["bundleId"]["development"]["ios"];
      versionCode = environment["versionCode"]["development"]["ios"];
      versionName = environment["versionName"]["development"]["ios"];
      appName += "-DEV";
      break;
    case ProjectScriptAppMode.production:
      bundleId = environment["bundleId"]["production"]["ios"];
      versionCode = environment["versionCode"]["production"]["ios"];
      versionName = environment["versionName"]["production"]["ios"];
      break;
    case ProjectScriptAppMode.uat:
      bundleId = environment["bundleId"]["uat"]["ios"];
      versionCode = environment["versionCode"]["uat"]["ios"];
      versionName = environment["versionName"]["uat"]["ios"];
      appName += "-UAT";
      break;
    case ProjectScriptAppMode.test:
      bundleId = environment["bundleId"]["test"]["ios"];
      versionCode = environment["versionCode"]["test"]["ios"];
      versionName = environment["versionName"]["test"]["ios"];
      appName += "-TEST";
      break;
    default:
      await ProjectScriptHelper.sendScriptErrorMessageOnXCode("Please set your environment app mode in .env.json file");
      break;
  }

   ProjectScriptHelper.setInfoPListObj('CFBundleShortVersionString', versionName);
   ProjectScriptHelper.setInfoPListObj('CFBundleVersion', versionCode);
   ProjectScriptHelper.setInfoPListObj('CFBundleDisplayName', appName);
   ProjectScriptHelper.setInfoPListObj('CFBundleIdentifier', bundleId);
   ProjectScriptHelper.setInfoPListObj('PRODUCT_BUNDLE_IDENTIFIER', bundleId);
}
