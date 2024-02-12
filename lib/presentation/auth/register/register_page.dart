import 'dart:developer';

import 'package:chatkuy/constants/app_constant.dart';
import 'package:chatkuy/helper/sf_helper.dart';
import 'package:chatkuy/presentation/base/base_page.dart';
import 'package:chatkuy/router/router_constant.dart';
import 'package:chatkuy/service/auth_service.dart';
import 'package:chatkuy/service/media_service.dart';
import 'package:chatkuy/service/notif_service.dart';
import 'package:chatkuy/widgets/text_input_decoration.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  static final notifications = NotificationsService();

  final FocusNode _focusNode = FocusNode();

  AuthService authService = AuthService();
  final confirmPasswordController = TextEditingController();
  final emailController = TextEditingController();
  Uint8List? file;
  final formKey = GlobalKey<FormState>();
  final fullNameController = TextEditingController();
  bool? isUsernameAvailable;
  bool? isEmailAvailable;
  final passwordController = TextEditingController();
  final usernameController = TextEditingController();

  Future signUp() async {
    var navigator = Navigator.of(context);
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;
    if (file == null) {
      const snackBar =
          SnackBar(content: Text('Please select a profile picture'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    await authService
        .registerAccount(
      fullName: fullNameController.text.trim(),
      userName: usernameController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
      profilePicture: file,
    )
        .then((value) async {
      if (value == true) {
        await SfHelper.saveUserLoggedInStatus(true);
        await SfHelper.saveUserEmailSF(emailController.text.trim());
        await SfHelper.saveFullNameSF(fullNameController.text.trim());
        await SfHelper.saveUsernameSF(usernameController.text.trim());

        navigator.pushNamedAndRemoveUntil(
            RouterConstant.basePage, (route) => false,
            arguments: const BasePageArg(route: BasePageRoute.chat));
        await notifications.requestPermission();
        await notifications.getToken();
      }
    });
  }

  Future<bool> _checkEmail(String email) async {
    final CollectionReference userCollection =
        FirebaseFirestore.instance.collection('users');
    QuerySnapshot querySnapshot =
        await userCollection.where('email', isEqualTo: email).get();
    return querySnapshot.docs.isEmpty;
  }

  Future<bool> _checkUsername(String userName) async {
    final CollectionReference userCollection =
        FirebaseFirestore.instance.collection('users');
    QuerySnapshot querySnapshot =
        await userCollection.where('userName', isEqualTo: userName).get();
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
        onPressed: signUp, //register,
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
          _checkUsername(val).then((value) {
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
      controller: passwordController,
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
        setState(() {});
      },
    );
  }

  Widget _buildConfirmationPassword() {
    return TextFormField(
      controller: confirmPasswordController,
      textInputAction: TextInputAction.next,
      obscureText: true,
      decoration: textInputDecoration.copyWith(
          labelText: "Konfirmasi Password",
          prefixIcon: Icon(
            Icons.lock,
            color: Theme.of(context).primaryColor,
          )),
      validator: (val) =>
          passwordController.text != confirmPasswordController.text
              ? 'Passwords do not match'
              : null,
      onChanged: (val) {
        setState(() {});
      },
    );
  }

  Widget _buildEmail() {
    return TextFormField(
      focusNode: _focusNode,
      controller: emailController,
      textInputAction: TextInputAction.next,
      decoration: textInputDecoration.copyWith(
        labelText: "Email",
        prefixIcon: Icon(
          Icons.email,
          color: Theme.of(context).primaryColor,
        ),
      ),
      onChanged: (val) {
        _checkEmail(val).then((value) {
          isEmailAvailable = value;
          log('email already takken');
        });
        setState(() {});
      },
      validator: (val) {
        if (isEmailAvailable == false) {
          return "Email sudah dipakai";
        } else if (val!.isNotEmpty) {
          return null;
        } else {
          return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
          ).hasMatch(val)
              ? null
              : "Please enter a valid email";
        }
      },
    );
  }

  Widget _buildFullname() {
    return TextFormField(
      controller: fullNameController,
      textInputAction: TextInputAction.next,
      decoration: textInputDecoration.copyWith(
          labelText: "Full Name",
          prefixIcon: Icon(
            Icons.person,
            color: Theme.of(context).primaryColor,
          )),
      onChanged: (val) {
        setState(() {});
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
      onTap: () async {
        final pickedImage = await MediaService.pickImage();
        setState(() => file = pickedImage!);
      },
      child: file != null
          ? CircleAvatar(
              radius: 50,
              backgroundImage: MemoryImage(file!),
            )
          : const CircleAvatar(
              radius: 50,
              backgroundColor: AppColor.primaryColor,
              child: Icon(
                Icons.add_a_photo,
                size: 50,
                color: Colors.white,
              ),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const Text(
                  "ChatKuy",
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Create your account now to chat and explore",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
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
                const SizedBox(height: 15),
                _buildConfirmationPassword(),
                const SizedBox(height: 20),
                _buildRegisterButton(),
                SizedBox(height: 24.h),
                Text.rich(
                  TextSpan(
                    text: "Already have an account? ",
                    style: const TextStyle(color: Colors.black, fontSize: 14),
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
