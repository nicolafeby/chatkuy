import 'dart:io';

import 'package:chatkuy/presentation/profile/profile_page.dart';
import 'package:chatkuy/router/router_constant.dart';
import 'package:chatkuy/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeDrawerWidget extends StatelessWidget {
  final String username;
  final String email;
  final AuthService authService;
  final String profileImage;
  const HomeDrawerWidget({
    super.key,
    required this.username,
    required this.email,
    required this.authService,
    required this.profileImage,
  });

  @override
  Widget build(BuildContext context) {
    final image = File(profileImage);
    return Drawer(
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 50),
        children: <Widget>[
          profileImage.isEmpty
              ? Icon(
                  Icons.account_circle,
                  size: 150,
                  color: Colors.grey[700],
                )
              : Image.file(
                  image,
                  fit: BoxFit.fill,
                ),
          SizedBox(height: 15.h),
          Text(
            username,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 30.h),
          Divider(height: 2.h),
          ListTile(
            onTap: () {},
            selectedColor: Theme.of(context).primaryColor,
            selected: true,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            leading: const Icon(Icons.group),
            title: const Text(
              "Chat",
              style: TextStyle(color: Colors.black),
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.pushReplacementNamed(
                context,
                RouterConstant.profilePage,
                arguments: ProfileArgument(
                    email: email,
                    username: username,
                    imageProfile: profileImage),
              );
            },
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            leading: const Icon(Icons.group),
            title: const Text(
              "Profile",
              style: TextStyle(color: Colors.black),
            ),
          ),
          ListTile(
            onTap: () async {
              showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("Logout"),
                      content: const Text("Are you sure you want to logout?"),
                      actions: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.cancel,
                            color: Colors.red,
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            final navigator = Navigator.of(context);
                            await authService.signOut();
                            navigator.pushNamedAndRemoveUntil(
                                RouterConstant.loginPage, (route) => false);
                          },
                          icon: const Icon(
                            Icons.done,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    );
                  });
            },
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            leading: const Icon(Icons.exit_to_app),
            title: const Text(
              "Logout",
              style: TextStyle(color: Colors.black),
            ),
          )
        ],
      ),
    );
  }
}
