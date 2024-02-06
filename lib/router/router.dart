import 'package:chatkuy/presentation/auth/login/login_page.dart';
import 'package:chatkuy/presentation/auth/register/register_page.dart';
import 'package:chatkuy/presentation/chat/page/chat_page.dart';
import 'package:chatkuy/presentation/edit_profile/edit_profile_page.dart';
import 'package:chatkuy/presentation/group_info/page/group_info_page.dart';
import 'package:chatkuy/presentation/home/page/home_page.dart';
import 'package:chatkuy/presentation/profile/profile_page.dart';
import 'package:chatkuy/presentation/search/search_page.dart';
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
        return ProfilePage(
          argument: settings.arguments as ProfileArgument,
        );
      case RouterConstant.chatPage:
        return ChatPage(
          argument: settings.arguments as ChatArgument,
        );
      case RouterConstant.groupInfoPage:
        return GroupInfo(
          argument: settings.arguments as GroupInfoArgument,
        );
      case RouterConstant.searchPage:
        return const SearchPage();
      case RouterConstant.editProfilePage:
        return EditProfilePage(
          argument: settings.arguments as EditProfileArgument,
        );
      default:
        return const SplashScreenPage();
    }
  }

  Route? generateAppRoutes(RouteSettings settings) {
    Widget getRoutedWidget = getPageRoute(settings);
    return generateRouter(getRoutedWidget, settings);
  }
}
