import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:neyasis_flutter_boilerplate/components/alert/cancel.dart';
import 'package:neyasis_flutter_boilerplate/components/alert/confirm.dart';
import 'package:neyasis_flutter_boilerplate/components/alert/success.dart';
import 'package:neyasis_flutter_boilerplate/components/alert/type.dart';
import 'package:neyasis_flutter_boilerplate/constants/colors.dart';
import 'package:neyasis_flutter_boilerplate/helpers/device_info.dart';
typedef bool AppAlertOnPress(bool isConfirm);

class AppAlertOptions {
  final String? title;
  final String? subtitle;
  final AppAlertOnPress? onPress;
  final Color? confirmButtonColor;
  final Color? cancelButtonColor;
  final String? confirmButtonText;
  final String? cancelButtonText;
  final bool? showCancelButton;
  final AppAlertType? style;

  AppAlertOptions(
      {this.showCancelButton: false,
      this.title,
      this.subtitle,
      this.onPress,
      this.cancelButtonColor,
      this.cancelButtonText,
      this.confirmButtonColor,
      this.confirmButtonText,
      this.style});
}

class AppAlertDialog extends StatefulWidget {
  final Curve? curve;
  final AppAlertOptions options;
  AppAlertDialog({
    required this.options,
    this.curve,
  }) : assert(options != null);

  @override
  State<StatefulWidget> createState() {
    return new AppAlertDialogState();
  }
}

class AppAlertDialogState extends State<AppAlertDialog> with SingleTickerProviderStateMixin, AppAlert {
  late AnimationController controller;
  late Animation<double> tween;
  late AppAlertOptions _options;

  @override
  void initState() {
    _options = widget.options;
    controller = new AnimationController(vsync: this);
    tween = new Tween(begin: 0.0, end: 1.0).animate(controller);
    controller.animateTo(1.0, duration: new Duration(milliseconds: 300), curve: widget.curve ?? AppAlert.showCurve);
    AppAlert._state = this;
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    AppAlert._state = null;
    super.dispose();
  }

  @override
  void didUpdateWidget(AppAlertDialog oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  void confirm() {
    if (_options.onPress != null && _options.onPress!(true) == false) return;
    Navigator.pop(context);
  }

  void cancel() {
    if (_options.onPress != null && _options.onPress!(false) == false) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> listOfChildren = [];
    switch (_options.style) {
      case AppAlertType.success:
        listOfChildren.add(new SizedBox(
          width: 64.0,
          height: 64.0,
          child: new SuccessView(),
        ));
        break;
      case AppAlertType.confirm:
        listOfChildren.add(new SizedBox(
          width: 64.0,
          height: 64.0,
          child: new ConfirmView(),
        ));
        break;
      case AppAlertType.error:
        listOfChildren.add(new SizedBox(
          width: 64.0,
          height: 64.0,
          child: new CancelView(),
        ));
        break;
      case AppAlertType.loading:
        listOfChildren.add(new SizedBox(
          width: 64.0,
          height: 64.0,
          child: new Center(
            child: new CircularProgressIndicator(),
          ),
        ));
        break;
    }

    if (_options.title != null) {
      listOfChildren.add(Container(
        padding: EdgeInsets.only(
          left: DeviceInfo.width(5),
          right: DeviceInfo.width(5),
        ),
        child: new Text(
          _options.title!,
          style: new TextStyle(fontSize: ScreenUtil().setSp(24), color: new Color(0xff575757)),
        ),
      ));
    }

    if (_options.subtitle != null) {
      listOfChildren.add(new Padding(
        padding: new EdgeInsets.only(top: 20.0, bottom: 10.0, left: 10.0, right: 10.0),
        child: new Text(
          _options.subtitle!,
          textAlign: TextAlign.center,
          style: new TextStyle(fontSize: ScreenUtil().setSp(15), color: new Color(0xff797979)),
        ),
      ));
    }

    if (_options.style != AppAlertType.loading) {
      if (_options.showCancelButton ?? false) {
        listOfChildren.add(new Padding(
          padding: new EdgeInsets.only(top: 15.0),
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new FlatButton(
                height: DeviceInfo.height(5),
                minWidth: DeviceInfo.width(35),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(DeviceInfo.height(5)),
                ),
                onPressed: cancel,
                color: AppColor.red,
                child: new Text(
                  _options.cancelButtonText ?? AppAlert.cancelText,
                  style: new TextStyle(color: Colors.white, fontSize: ScreenUtil().setSp(15)),
                ),
              ),
              new SizedBox(
                width: 10.0,
              ),
              new FlatButton(
                height: DeviceInfo.height(5),
                minWidth: DeviceInfo.width(35),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(DeviceInfo.height(5)),
                ),
                onPressed: confirm,
                color: AppColor.green,
                child: new Text(
                  _options.confirmButtonText ?? AppAlert.confirmText,
                  style: new TextStyle(color: Colors.white, fontSize: ScreenUtil().setSp(15)),
                ),
              ),
            ],
          ),
        ));
      } else {
        listOfChildren.add(new Padding(
          padding: new EdgeInsets.only(top: 10.0),
          child: new FlatButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(DeviceInfo.height(5)),
            ),
            height: DeviceInfo.height(5),
            minWidth: DeviceInfo.width(35),
            onPressed: confirm,
            color: _options.confirmButtonColor ?? AppAlert.success,
            child: new Text(
              _options.confirmButtonText ?? AppAlert.successText,
              style: new TextStyle(color: Colors.white, fontSize: ScreenUtil().setSp(15)),
            ),
          ),
        ));
      }
    }

    return new Center(
        child: new AnimatedBuilder(
            animation: controller,
            builder: (c, w) {
              return new ScaleTransition(
                scale: tween,
                child: new ClipRRect(
                  borderRadius: new BorderRadius.all(new Radius.circular(10.0)),
                  child: new Container(
                      color: Colors.white,
                      width: double.infinity,
                      child: new Padding(
                        padding: new EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 20.0),
                        child: new Column(
                          mainAxisSize: MainAxisSize.min,
                          children: listOfChildren,
                        ),
                      )),
                ),
              );
            }));
  }

  void update(AppAlertOptions options) {
    setState(() {
      _options = options;
    });
  }
}

abstract class AppAlert {
  static Color success = new Color(0xffAEDEF4);
  static Color danger = new Color(0xffDD6B55);
  static Color cancel = new Color(0xffD0D0D0);

  static String successText = "OK";
  static String confirmText = "Confirm";
  static String cancelText = "Cancel";

  static Curve showCurve = Curves.bounceOut;

  static AppAlertDialogState? _state;

  static void show(BuildContext context,
      {Curve? curve,
      String? title,
      String? subtitle,
      bool? showCancelButton: false,
      AppAlertOnPress? onPress,
      Color? cancelButtonColor,
      Color? confirmButtonColor,
      String? cancelButtonText,
      String? confirmButtonText,
      AppAlertType? style}) {
    AppAlertOptions options = new AppAlertOptions(
        showCancelButton: showCancelButton,
        title: title,
        subtitle: subtitle,
        style: style,
        onPress: onPress,
        confirmButtonColor: confirmButtonColor,
        confirmButtonText: confirmButtonText,
        cancelButtonText: cancelButtonText,
        cancelButtonColor: confirmButtonColor);
    if (_state != null) {
      _state!.update(options);
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return new Container(
              color: Colors.transparent,
              child: new Padding(
                padding: new EdgeInsets.all(40.0),
                child: new Scaffold(
                  backgroundColor: Colors.transparent,
                  body: new AppAlertDialog(curve: curve, options: options),
                ),
              ),
            );
          });
    }
  }
}
