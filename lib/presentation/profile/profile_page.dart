import 'dart:io';

import 'package:chatkuy/presentation/edit_profile/edit_profile_page.dart';
import 'package:chatkuy/router/router_constant.dart';
import 'package:chatkuy/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileArgument {
  final String username;
  final String email;
  final String imageProfile;

  const ProfileArgument({
    required this.email,
    required this.username,
    required this.imageProfile,
  });
}

class ProfilePage extends StatefulWidget {
  final ProfileArgument argument;
  const ProfilePage({Key? key, required this.argument}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  AuthService authService = AuthService();
  File? image;

  @override
  void initState() {
    image = File(widget.argument.imageProfile);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        title: const Text("Profile"),
        actions: [
          GestureDetector(
            onTap: () => Navigator.pushNamed(
              context,
              RouterConstant.editProfilePage,
              arguments: EditProfileArgument(
                fullName: widget.argument.username,
                email: widget.argument.email,
                profileImage: widget.argument.imageProfile,
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: Icon(Icons.edit),
            ),
          ),
        ],
      ),
      drawer: Drawer(
          child: ListView(
        padding: EdgeInsets.symmetric(vertical: 50.h),
        children: <Widget>[
          Icon(
            Icons.account_circle,
            size: 150,
            color: Colors.grey[700],
          ),
          SizedBox(height: 15.h),
          Text(
            widget.argument.username,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 30.h),
          Divider(height: 2.h),
          ListTile(
            onTap: () {
              Navigator.pushNamed(context, RouterConstant.homePage);
            },
            contentPadding:
                EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
            leading: const Icon(Icons.group),
            title: const Text(
              "Groups",
              style: TextStyle(color: Colors.black),
            ),
          ),
          ListTile(
            onTap: () {},
            selected: true,
            selectedColor: Theme.of(context).primaryColor,
            contentPadding:
                EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
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
                EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
            leading: const Icon(Icons.exit_to_app),
            title: const Text(
              "Logout",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          )
        ],
      )),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 170.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            widget.argument.imageProfile.isEmpty
                ? Icon(
                    Icons.account_circle,
                    size: 150,
                    color: Colors.grey[700],
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(500.h),
                    child: Image.file(
                      image!,
                      height: 150.r,
                      width: 150.r,
                      fit: BoxFit.cover,
                    ),
                  ),
            SizedBox(height: 15.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Full Name", style: TextStyle(fontSize: 17)),
                Text(
                  widget.argument.username,
                  style: const TextStyle(fontSize: 17),
                ),
              ],
            ),
            Divider(height: 20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Email", style: TextStyle(fontSize: 17)),
                Text(
                  widget.argument.email,
                  style: const TextStyle(fontSize: 17),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
