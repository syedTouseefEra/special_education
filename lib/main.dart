import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:special_education/provider/login/login_provider.dart';
import 'package:special_education/screen/tabbar_view.dart';
import 'package:special_education/screen/dashboard/dashboard_view.dart';
import 'package:special_education/screen/login/login_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GetStorage.init('user');
  await GetStorage.init('registered');

  runApp(
    ChangeNotifierProvider(
      create: (_) => LoginProvider()..loadUserData(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(375, 812),
      child: Consumer<LoginProvider>(
        builder: (context, loginProvider, _) {
          Widget homeScreen;

          if (loginProvider.userData != null) {
            homeScreen = HomeScreen();
          } else {
            homeScreen = LoginPage();
          }

          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Special Education',
            // theme: ThemeData(primarySwatch: Colors.pink),
            home: homeScreen,
          );
        },
      ),
    );
  }
}
