import 'dart:developer';

import 'package:chatkuy/widgets/custom_button_widget.dart';
import 'package:chatkuy/widgets/text_input_decoration.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool? isEmailAvailable;

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future verifyEmail() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());

      const snackBar =
          SnackBar(content: Text('Reset Password Email has been Sent.'));
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      Navigator.of(context).popUntil((route) => route.isFirst);
    } on FirebaseAuthException catch (e) {
      final snackBar = SnackBar(content: Text(e.message!));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Future<bool> _checkEmail(String email) async {
    final CollectionReference userCollection =
        FirebaseFirestore.instance.collection('users');
    QuerySnapshot querySnapshot =
        await userCollection.where('email', isEqualTo: email).get();
    return querySnapshot.docs.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Theme.of(context).primaryColor,
          title: const Text('Reset Password'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  const SizedBox(height: 60),
                  const FlutterLogo(size: 120),
                  const SizedBox(height: 40),
                  const Text(
                    'You will receive an email to\nreset your password.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24),
                  ),
                  const SizedBox(height: 20),
                  _buildEmail(),
                  const SizedBox(height: 20),
                  CustomButtonWidget(
                    text: 'Reset Password',
                    onPressed: verifyEmail,
                  )
                ],
              ),
            ),
          ),
        ),
      );

  Widget _buildEmail() {
    return TextFormField(
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
          return "Email tidak terdaftar";
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
}
