import 'package:chatkuy/presentation/login/login_page.dart';
import 'package:chatkuy/presentation/register/register_page.dart';
import 'package:chatkuy/router/router_constant.dart';
import 'package:flutter/material.dart';

class Router {
  Route generateRouter(Widget page, RouteSettings settings) {
    return MaterialPageRoute(
      settings: settings,
      builder: (context) => getPageRoute(settings),
    );
  }

  Widget getPageRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouterConstant.loginPage:
        return const LoginPage();
      case RouterConstant.registerPage:
        return const RegisterPage();
      default:
        return const LoginPage();
    }
  }

  Route? generateAppRoutes(RouteSettings settings) {
    Widget getRoutedWidget = getPageRoute(settings);
    return generateRouter(getRoutedWidget, settings);
  }
}
