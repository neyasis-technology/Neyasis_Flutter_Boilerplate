import 'dart:io';

class ProjectScriptHelper {
  static setInfoPListObj(String key, dynamic value) {
    ProcessResult result = Process.runSync("pwd", []);
    sendScriptErrorMessageOnXCode(result.stdout);
    // ProcessResult result2 = Process.runSync("cat", ["${result.stdout.toString().trim()}/../ios/Runner/Info.plist"]);
    // sendScriptErrorMessageOnXCode(result2.stdout);
    // print("${result.stdout.toString().trim()}../ios/Runner/Info.plist");
    final List<String> runCommand = [
      '"Set $key $value"',
      '"${result.stdout.toString().trim()}/../ios/Runner/Info.plist"'
    ];
    ProcessResult result3 =
        Process.runSync("/usr/libexec/PlistBuddy -c", runCommand);
    sendScriptErrorMessageOnXCode(result3.stdout.toString());
    if (result3.stderr.toString().length > 0) {
      sendScriptErrorMessageOnXCode(result3.stderr.toString());
    }
  }

  static sendScriptErrorMessageOnXCode(String message) {
    print("error: $message");
  }
}
