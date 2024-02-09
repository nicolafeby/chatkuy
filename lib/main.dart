import 'package:chatkuy/constants/app_constant.dart';
import 'package:chatkuy/firebase_options.dart';
import 'package:chatkuy/service/notification_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:chatkuy/router/router.dart' as router;
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: AppConstant.apiKey,
        appId: AppConstant.appId,
        messagingSenderId: AppConstant.messagingSenderId,
        projectId: AppConstant.projectId,
      ),
    );
  } else {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await NotificationService().initNotification();
  }

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (context, child) {
        return MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          onGenerateRoute: router.Router().generateAppRoutes,
          theme: ThemeData(
            appBarTheme: AppBarTheme(
              // backgroundColor: Theme.of(context).primaryColor,
              iconTheme: const IconThemeData(color: Colors.white),
              titleTextStyle: TextStyle(
                color: Colors.white,
                fontSize: 22.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            primaryColor: AppColor.primaryColor,
            scaffoldBackgroundColor: Colors.white, // Colors.white70,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.deepPurple,
              // background: Color(0xFFFFB996),
            ),
            useMaterial3: true,
          ),
        );
      },
    );
  }
}
