import 'dart:developer';

import 'package:chatkuy/helper/helper.dart';
import 'package:chatkuy/constants/app_constant.dart';
import 'package:chatkuy/presentation/home/home_page.dart';
import 'package:chatkuy/presentation/login/login_page.dart';
import 'package:chatkuy/router/router_constant.dart';
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
    await Firebase.initializeApp();
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
          onGenerateRoute: router.Router().generateAppRoutes,
          theme: ThemeData(
            primaryColor: AppColor.primaryColor,
            scaffoldBackgroundColor: Colors.white,
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
        );
      },
    );
  }
}
