import 'package:chatkuy/helper/helper.dart';
import 'package:chatkuy/presentation/home/home_page.dart';
import 'package:chatkuy/presentation/login/login_page.dart';
import 'package:chatkuy/presentation/register/register_page.dart';
import 'package:chatkuy/shared/app_constant.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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
  bool _isSignIn = false;
  @override
  void initState() {
    super.initState();
    getUserLiggedInStatus();
  }

  getUserLiggedInStatus() async {
    await Helper.getUserLoggedInStatus().then((value) {
      if (value != null) {
        _isSignIn = value;
      }
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: AppColor.primaryColor,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: _isSignIn ? const HomePage() : const LoginPage(),
    );
  }
}
