import 'package:chatkuy/helper/sf_helper.dart';
import 'package:chatkuy/mixin/app_mixin.dart';
import 'package:chatkuy/presentation/profile/edit_profile/edit_profile_page.dart';
import 'package:chatkuy/provider/firebase_provider.dart';
import 'package:chatkuy/router/router_constant.dart';
import 'package:chatkuy/service/auth_service.dart';
import 'package:chatkuy/widgets/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class ProfileArgument {
  const ProfileArgument({
    required this.email,
    required this.fullName,
    required this.imageProfile,
  });

  final String email;
  final String imageProfile;
  final String fullName;
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

  String image = '';
  String fullName = '';
  String userName = '';
  String email = '';

  @override
  void initState() {
    Provider.of<FirebaseProvider>(context, listen: false)
        .getUserById(FirebaseAuth.instance.currentUser!.uid);
    SfHelper.sfReload();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
        child: Consumer<FirebaseProvider>(
          builder: (context, value, child) {
            image = value.user?.image ?? '';
            userName = value.user?.userName ?? '';
            fullName = value.user?.name ?? '';
            email = value.user?.email ?? '';

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(500.r),
                  child: CustomCachedNetworkImage(
                    height: 120.r,
                    width: 120.r,
                    imageUrl: value.user?.image,
                  ),
                ),
                SizedBox(height: 15.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Full Name", style: TextStyle(fontSize: 17)),
                    Text(
                      value.user?.name ?? '',
                      style: const TextStyle(fontSize: 17),
                    ),
                  ],
                ),
                Divider(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Username", style: TextStyle(fontSize: 17)),
                    Text(
                      value.user?.userName ?? '',
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
                      value.user?.email ?? '',
                      style: const TextStyle(fontSize: 17),
                    ),
                  ],
                ),
                SizedBox(height: 42.h),
                _buildSignoutButton(),
              ],
            );
          },
        ));
  }

  PreferredSizeWidget _buildAppbar() {
    return AppBar(
      backgroundColor: Theme.of(context).primaryColor,
      elevation: 0,
      centerTitle: true,
      title: const Text("Profile"),
      actions: [
        GestureDetector(
          onTap: () => Navigator.pushNamed(
            context,
            RouterConstant.editProfilePage,
            arguments: EditProfileArgument(
              fullName: fullName,
              email: email,
              profileImage: image,
              userName: userName,
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
