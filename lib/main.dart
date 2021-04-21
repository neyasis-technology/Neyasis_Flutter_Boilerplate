import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:neyasis_flutter_boilerplate/constants/app.dart';
import 'package:neyasis_flutter_boilerplate/constants/colors.dart';
import 'package:neyasis_flutter_boilerplate/helpers/functions.dart';
import 'package:neyasis_flutter_boilerplate/screens/splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  runApp(EasyLocalization(
    supportedLocales: [Locale("tr"), Locale("en")],
    path: 'assets/translations', // <-- change the path of the translation files
    fallbackLocale: Locale('tr'),
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(390, 844),
      builder: () {
        return MaterialApp(
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          debugShowCheckedModeBanner: false,
          navigatorKey: Application.navigatorKey,
          title: Application.name,
          theme: Theme.of(context).copyWith(
            primaryColor: AppColor.main,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: SplashScreen(),
        );
      },
    );
  }
}
