import 'package:easy_localization/easy_localization.dart';
import 'package:neyasis_flutter_boilerplate/components/alert/alert.dart';
import 'package:neyasis_flutter_boilerplate/components/alert/type.dart';
import 'package:neyasis_flutter_boilerplate/constants/app.dart';
import 'package:neyasis_flutter_boilerplate/constants/colors.dart';

class AppDialogs {
  static handleOnPress(Function()? onPress) {
    if (onPress == null) return;
    onPress();
  }

  static showSuccess(String message, {Function()? onPress}) async {
    AppAlert.show(
      Application.context,
      subtitle: message,
      onPress: (_) {
        handleOnPress(onPress);
        return true;
      },
      style: AppAlertType.success,
      confirmButtonText: tr("global.ok"),
      confirmButtonColor: AppColor.green,
    );
  }

  static showError(String message, {Function()? onPress}) async {
    AppAlert.show(
      Application.context,
      onPress: (_) {
        handleOnPress(onPress);
        return true;
      },
      subtitle: message,
      style: AppAlertType.error,
      confirmButtonText: tr("global.ok"),
      confirmButtonColor: AppColor.red,
    );
  }

  static showWarning(String message, {required Function() onPress}) async {
    AppAlert.show(
      Application.context,
      onPress: (isConfirmed) {
        if (isConfirmed) {
          onPress();
        }
        return true;
      },
      subtitle: message,
      style: AppAlertType.confirm,
      confirmButtonText: tr("global.yes"),
      confirmButtonColor: AppColor.green,
      cancelButtonColor: AppColor.red,
      cancelButtonText: tr("global.no"),
      showCancelButton: true,
    );
  }
}
