import 'dart:developer';
import 'dart:io';

import 'package:chatkuy/helper/helper.dart';
import 'package:chatkuy/mixin/app_mixin.dart';
import 'package:chatkuy/presentation/edit_profile/edit_profile_page.dart';
import 'package:chatkuy/router/router_constant.dart';
import 'package:chatkuy/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileArgument {
  const ProfileArgument({
    required this.email,
    required this.username,
    required this.imageProfile,
  });

  final String email;
  final String imageProfile;
  final String username;
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({
    Key? key,
    // required this.argument,
  }) : super(key: key);

  // final ProfileArgument argument;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with AppMixin {
  AuthService authService = AuthService();
  String _email = '';
  File? _image;
  String _profileImage = '';
  String _username = '';

  @override
  void initState() {
    Helper.sfReload();
    _getUserData();
    super.initState();
  }

  _getUserData() async {
    await Helper.getUserEmailFromSF().then((value) {
      setState(() {
        _email = value!;
      });
    });
    await Helper.getUsernameFromSF().then((value) {
      setState(() {
        _username = value!;
      });
    });
    await Helper.getProfilePictureFromSF().then((value) {
      setState(() {
        _profileImage = value!;
      });
    });
    _image = File(_profileImage);
  }

  @override
  Widget build(BuildContext context) {
    log(_profileImage);
    return Scaffold(
      appBar: _buildAppbar(),
      body: _buildBody(),
    );
  }

  Widget _buildSignoutButton() {
    return TextButton(
      onPressed: () => showSignOutConfirmation(context,
          authService: authService), //authService.signOut(),
      child: Text(
        'Keluar',
        style: Theme.of(context)
            .textTheme
            .titleLarge
            ?.copyWith(color: Colors.red, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: EdgeInsets.all(16.r),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _profileImage.isEmpty
              ? Icon(
                  Icons.account_circle,
                  size: 150,
                  color: Colors.grey[700],
                )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(500.h),
                  child: Image.file(
                    _image!,
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
                _username,
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
                _email,
                style: const TextStyle(fontSize: 17),
              ),
            ],
          ),
          SizedBox(height: 42.h),
          _buildSignoutButton(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppbar() {
    return AppBar(
      backgroundColor: Theme.of(context).primaryColor,
      elevation: 0,
      title: const Text("Profile"),
      actions: [
        GestureDetector(
          onTap: () => Navigator.pushNamed(
            context,
            RouterConstant.editProfilePage,
            arguments: EditProfileArgument(
              fullName: _username,
              email: _email,
              profileImage: _profileImage,
            ),
          ),
          child: const Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Icon(Icons.edit),
          ),
        ),
      ],
    );
  }
}
