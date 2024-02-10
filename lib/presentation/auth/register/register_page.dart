import 'dart:developer';

import 'package:chatkuy/constants/app_constant.dart';
import 'package:chatkuy/helper/sf_helper.dart';
import 'package:chatkuy/presentation/base/base_page.dart';
import 'package:chatkuy/router/router_constant.dart';
import 'package:chatkuy/service/auth_service.dart';
import 'package:chatkuy/service/database_service.dart';
import 'package:chatkuy/widgets/snackbar_widget.dart';
import 'package:chatkuy/widgets/text_input_decoration.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  AuthService authService = AuthService();
  String email = '';
  final formKey = GlobalKey<FormState>();
  String fullName = '';
  String password = '';
  String profilePicture = '';
  String userName = '';
  bool? isUsernameAvailable;

  bool _isLoading = false;

  void register() async {
    var navigator = Navigator.of(context);
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await authService
          .registerWithEmainAndPassword(
        email: email,
        fullName: fullName,
        password: password,
        profilePicture: profilePicture,
        userName: userName,
      )
          .then((value) async {
        if (value == true) {
          // saving the shared preference state
          await SfHelper.saveUserLoggedInStatus(true);
          await SfHelper.saveUserEmailSF(email);
          await SfHelper.saveFullNameSF(fullName);
          await SfHelper.saveUsernameSF(userName);
          await SfHelper.saveProfilePictureSF(profilePicture);
          navigator.pushReplacementNamed(
            RouterConstant.basePage,
            arguments: const BasePageArg(route: BasePageRoute.chat),
          );
        } else {
          showSnackbar(context, Colors.red, value);
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }

  Future<bool> _checkUsername(String userName) async {
    final CollectionReference userCollection =
        FirebaseFirestore.instance.collection('users');
    QuerySnapshot querySnapshot =
        await userCollection.where('username', isEqualTo: userName).get();
    return querySnapshot.docs.isEmpty;
  }

  Widget _buildRegisterButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor,
            elevation: 0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30))),
        onPressed: register,
        child: const Text(
          "Register",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildUsername() {
    return TextFormField(
      textInputAction: TextInputAction.next,
      decoration: textInputDecoration.copyWith(
          labelText: "Username",
          prefixIcon: Icon(
            Icons.note,
            color: Theme.of(context).primaryColor,
          )),
      onChanged: (val) {
        setState(() {
          userName = val;
          _checkUsername(userName).then((value) {
            isUsernameAvailable = value;
            log('Username is available: $isUsernameAvailable');
          });
        });
      },
      validator: (val) {
        if (isUsernameAvailable == false) {
          return "Username sudah dipakai";
        } else if (val!.isNotEmpty) {
          return null;
        } else {
          return "Name cannot be empty";
        }
      },
    );
  }

  Widget _buildPassword() {
    return TextFormField(
      textInputAction: TextInputAction.next,
      obscureText: true,
      decoration: textInputDecoration.copyWith(
          labelText: "Password",
          prefixIcon: Icon(
            Icons.lock,
            color: Theme.of(context).primaryColor,
          )),
      validator: (val) {
        if (val!.length < 6) {
          return "Password must be at least 6 characters";
        } else {
          return null;
        }
      },
      onChanged: (val) {
        setState(() {
          password = val;
        });
      },
    );
  }

  Widget _buildEmail() {
    return TextFormField(
      textInputAction: TextInputAction.next,
      decoration: textInputDecoration.copyWith(
        labelText: "Email",
        prefixIcon: Icon(
          Icons.email,
          color: Theme.of(context).primaryColor,
        ),
      ),
      onChanged: (val) {
        setState(() {
          email = val;
        });
      },
      validator: (val) {
        return RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
        ).hasMatch(val!)
            ? null
            : "Please enter a valid email";
      },
    );
  }

  Widget _buildFullname() {
    return TextFormField(
      textInputAction: TextInputAction.next,
      decoration: textInputDecoration.copyWith(
          labelText: "Full Name",
          prefixIcon: Icon(
            Icons.person,
            color: Theme.of(context).primaryColor,
          )),
      onChanged: (val) {
        setState(() {
          fullName = val;
        });
      },
      validator: (val) {
        if (val!.isNotEmpty) {
          return null;
        } else {
          return "Name cannot be empty";
        }
      },
    );
  }

  Widget _buildAddProfileImage() {
    return GestureDetector(
      onTap: () {}, //=> _pickImage(),
      child: Container(
        height: 100.r,
        width: 100.r,
        decoration: BoxDecoration(
          color: Colors.grey[700],
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.camera_enhance,
          color: Colors.white,
          size: 24.r,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor),
            )
          : SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        "ChatKuy",
                        style: TextStyle(
                            fontSize: 40, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Create your account now to chat and explore",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w400),
                      ),
                      // Image.asset("assets/images/register.png"),
                      SizedBox(height: 24.h),
                      _buildAddProfileImage(),
                      SizedBox(height: 24.h),
                      _buildFullname(),
                      const SizedBox(height: 15),
                      _buildUsername(),
                      const SizedBox(height: 15),
                      _buildEmail(),
                      const SizedBox(height: 15),
                      _buildPassword(),
                      const SizedBox(height: 20),
                      _buildRegisterButton(),
                      SizedBox(height: 24.h),
                      Text.rich(
                        TextSpan(
                          text: "Already have an account? ",
                          style: const TextStyle(
                              color: Colors.black, fontSize: 14),
                          children: <TextSpan>[
                            TextSpan(
                              text: "Login now",
                              style: const TextStyle(
                                color: AppColor.primaryColor,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.pushReplacementNamed(
                                    context,
                                    RouterConstant.loginPage,
                                  );
                                },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
