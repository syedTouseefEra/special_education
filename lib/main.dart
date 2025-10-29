import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:special_education/provider/login/login_provider.dart';
import 'package:special_education/screen/student/student_dashboard_provider.dart';
import 'package:special_education/screen/tabbar_view.dart';
import 'package:special_education/screen/dashboard/dashboard_view.dart';
import 'package:special_education/screen/login/login_view.dart';
import 'package:special_education/screen/teacher/teacher_dashboard_provider.dart';
import 'package:special_education/utils/image_upload_provider.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await FlutterDownloader.initialize(
    debug: true,
    ignoreSsl: true,
  );

  await GetStorage.init('user');
  await GetStorage.init('registered');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginProvider()..loadUserData()),
        ChangeNotifierProvider(create: (_) => StudentDashboardProvider()),
        ChangeNotifierProvider(create: (_) => TeacherDashboardProvider()),
        ChangeNotifierProvider(create: (_) => ImageUploadProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(375, 812),
      builder: (context, child) => Consumer<LoginProvider>(
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
            home: homeScreen,
            navigatorObservers: [routeObserver],
          );
        },
      ),
    );
  }
}


