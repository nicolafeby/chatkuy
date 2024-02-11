import 'dart:developer';

import 'package:chatkuy/helper/sf_helper.dart';
import 'package:chatkuy/main.dart';
import 'package:chatkuy/service/firestore_service.dart';
import 'package:chatkuy/service/storage_service.dart';
import 'package:chatkuy/widgets/snackbar_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future login({
    required String email,
    required String password,
  }) async {
    try {
      User? user = (await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      ))
          .user;

      if (user != null) return true;

      await FirebaseFirestoreService.updateUserData(
        {'lastActive': DateTime.now()},
      );
    } on FirebaseAuthException catch (e) {
      navigatorKey.currentState?.pop();
      // log(e.message!);
      showSnackbar(navigatorKey.currentContext!, Colors.red, e.message!);
      // if (mounted) {
      //   showSnackbar(context, Colors.red, e.message.toString());
      // }
      // final snackBar = SnackBar(content: Text(e.message!));
      // sm.showSnackBar(snackBar);
    }
  }

  Future registerAccount({
    required String fullName,
    required String userName,
    required String email,
    required String password,
    required Uint8List? profilePicture,
  }) async {
    try {
      User? user = (await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      ))
          .user;

      String? image = await FirebaseStorageService.uploadImage(
          profilePicture!, 'image/profile/${user!.uid}');

      if (user != null) {
        await FirebaseFirestoreService.createUser(
          image: image,
          email: user.email ?? '',
          uid: user.uid,
          fullName: fullName,
          userName: userName,
        );

        return true;
      }
    } on FirebaseAuthException catch (e) {
      // return e.code;
      navigatorKey.currentState?.pop();
      log(e.message!);
      showSnackbar(navigatorKey.currentContext!, Colors.red, e.message!);
      // final snackBar = SnackBar(content: Text(e.message!));
      // ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(snackBar);
    }
  }

  Future loginWithEmainAndPassword(
      {required String email, required String password}) async {
    try {
      User? user = (await auth.signInWithEmailAndPassword(
              email: email, password: password))
          .user;

      if (user != null) return true;
    } on FirebaseAuthException catch (e) {
      // return e.code;
      log(e.message!);
      showSnackbar(navigatorKey.currentContext!, Colors.red, e.message!);
    }
  }

  Future signOut() async {
    try {
      await auth.signOut();
      await SfHelper.saveUserLoggedInStatus(false);
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }
}
