import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:special_education/screen/choose_account/choose_account_provider.dart';
import 'package:special_education/screen/dashboard/dashboard_provider.dart';
import 'package:special_education/screen/login/login_provider.dart';
import 'package:special_education/screen/report/report_dashboard_provider.dart';
import 'package:special_education/screen/student/student_dashboard_provider.dart';
import 'package:special_education/screen/tabbar_view.dart';
import 'package:special_education/screen/login/login_view.dart';
import 'package:special_education/screen/teacher/teacher_dashboard_provider.dart';
import 'package:special_education/user_data/user_data.dart';
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
        userDataProvider,
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (_) => ChooseAccountProvider()),
        ChangeNotifierProvider(create: (_) => DashboardProvider()),
        ChangeNotifierProvider(create: (_) => StudentDashboardProvider()),
        ChangeNotifierProvider(create: (_) => TeacherDashboardProvider()),
        ChangeNotifierProvider(create: (_) => ImageUploadProvider()),
        ChangeNotifierProvider(create: (_) => ReportDashboardProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final userData = UserData();

    Widget homeScreen;

    if (userData.isLoggedIn) {
      homeScreen = const HomeScreen();
    } else {
      homeScreen = const LoginPage();
    }

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Special Education',
          home: homeScreen,
          navigatorObservers: [routeObserver],
        );
      },
    );
  }
}


