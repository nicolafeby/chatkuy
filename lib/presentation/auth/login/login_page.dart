import 'package:chatkuy/constants/app_constant.dart';
import 'package:chatkuy/helper/sf_helper.dart';
import 'package:chatkuy/presentation/base/base_page.dart';
import 'package:chatkuy/router/router_constant.dart';
import 'package:chatkuy/service/auth_service.dart';
import 'package:chatkuy/service/notif_service.dart';
import 'package:chatkuy/widgets/custom_button_widget.dart';
import 'package:chatkuy/widgets/text_input_decoration.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  static final notifications = NotificationsService();

  AuthService authService = AuthService();
  String email = "";
  final emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  String password = "";
  final passwordController = TextEditingController();

  final bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  // login() async {
  //   final navigator = Navigator.of(context);
  //   if (formKey.currentState!.validate()) {
  //     setState(() {
  //       _isLoading = true;
  //     });
  //     await authService
  //         .loginWithEmainAndPassword(email: email, password: password)
  //         .then((value) async {
  //       if (value == true) {
  //         QuerySnapshot snapshot =
  //             await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
  //                 .gettingUserData(email);
  //         // saving the values to our shared preferences
  //         await SfHelper.saveUserLoggedInStatus(true);
  //         await SfHelper.saveUserEmailSF(email);
  //         await SfHelper.saveFullNameSF(snapshot.docs[0]['fullName']);
  //         await SfHelper.saveProfilePictureSF(snapshot.docs[0]['profilePic']);
  //         navigator.pushReplacementNamed(RouterConstant.basePage,
  //             arguments: const BasePageArg(route: BasePageRoute.chat));
  //       } else {
  //         showSnackbar(context, Colors.red, value);
  //         setState(() {
  //           _isLoading = false;
  //         });
  //       }
  //     });
  //   }
  // }

  Future signIn() async {
    final navigator = Navigator.of(context);
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    authService
        .login(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    )
        .then((value) async {
      if (value == true) {
        await SfHelper.saveUserLoggedInStatus(true);
        navigator.pushNamedAndRemoveUntil(
            RouterConstant.basePage, (route) => false,
            arguments: const BasePageArg(route: BasePageRoute.chat));
        await notifications.requestPermission();
        await notifications.getToken();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
                        const Text("Login now to see what they are talking!",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w400)),
                        Image.asset("assets/images/login.png"),
                        TextFormField(
                          controller: emailController,
                          decoration: textInputDecoration.copyWith(
                              labelText: "Email",
                              prefixIcon: Icon(
                                Icons.email,
                                color: Theme.of(context).primaryColor,
                              )),
                          onChanged: (val) {
                            setState(() {
                              email = val;
                            });
                          },

                          // check tha validation
                          validator: (val) {
                            return RegExp(
                                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(val!)
                                ? null
                                : "Please enter a valid email";
                          },
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          controller: passwordController,
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
                        ),
                        const SizedBox(height: 20),
                        _buildForgotPassword(),
                        SizedBox(height: 20.h),
                        CustomButtonWidget(
                          text: 'Sign In',
                          onPressed: signIn,
                        ),
                        SizedBox(height: 24.h),
                        Text.rich(TextSpan(
                          text: "Don't have an account? ",
                          style: const TextStyle(
                              color: Colors.black, fontSize: 14),
                          children: <TextSpan>[
                            TextSpan(
                                text: "Register here",
                                style: const TextStyle(
                                  color: AppColor.primaryColor,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.pushReplacementNamed(
                                      context,
                                      RouterConstant.registerPage,
                                    );
                                  }),
                          ],
                        )),
                      ],
                    )),
              ),
            ),
    );
  }

  Widget _buildForgotPassword() {
    return Row(
      children: [
        const Spacer(),
        GestureDetector(
          child: Text(
            'Forgot Password?',
            style: TextStyle(
              decoration: TextDecoration.underline,
              color: Theme.of(context).colorScheme.secondary,
              fontSize: 14.sp,
            ),
          ),
          onTap: () => Navigator.pushNamed(
            context,
            RouterConstant.forgotPasswordPage,
          ),
        ),
      ],
    );
  }
}
