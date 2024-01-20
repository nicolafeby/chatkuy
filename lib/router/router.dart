import 'package:chatkuy/helper/helper.dart';
import 'package:chatkuy/presentation/chat/chat_page.dart';
import 'package:chatkuy/presentation/home/home_page.dart';
import 'package:chatkuy/presentation/login/login_page.dart';
import 'package:chatkuy/presentation/profile/profile_page.dart';
import 'package:chatkuy/presentation/register/register_page.dart';
import 'package:chatkuy/presentation/splash/splash_screen.dart';
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
      case RouterConstant.homePage:
        return const HomePage();
      case RouterConstant.profilePage:
        return ProfilePage(argument: settings.arguments as ProfileArgument);
      case RouterConstant.chatPage:
        return ChatPage(argument: settings.arguments as ChatArgument);
      default:
        return const SplashScreenPage();
    }
  }

  Route? generateAppRoutes(RouteSettings settings) {
    Widget getRoutedWidget = getPageRoute(settings);
    return generateRouter(getRoutedWidget, settings);
  }
}
