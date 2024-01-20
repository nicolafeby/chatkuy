import 'dart:async';

import 'package:chatkuy/constants/app_constant.dart';
import 'package:chatkuy/helper/helper.dart';
import 'package:chatkuy/router/router_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({super.key});

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  bool _isLogin = false;

  @override
  void initState() {
    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(
        context,
        _isLogin ? RouterConstant.homePage : RouterConstant.loginPage,
      );
    });
    getUserLiggedInStatus();
    super.initState();
  }

  getUserLiggedInStatus() async {
    await Helper.getUserLoggedInStatus().then((value) {
      if (value != null) {
        _isLogin = value;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FractionallySizedBox(
          widthFactor: 1.sw,
          heightFactor: 1.sh,
          child: Lottie.asset(
            'assets/lotties/splash.json',
          ),
        ),
      ),
    );
  }
}
