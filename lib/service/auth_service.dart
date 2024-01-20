import 'package:chatkuy/helper/helper.dart';
import 'package:chatkuy/service/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future registerWithEmainAndPassword(
      {required String fullName,
      required String email,
      required String password}) async {
    try {
      User user = (await auth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user!;

      if (user != null) {
        await DatabaseService(uid: user.uid).saveUserData(fullName, email);
        return true;
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future loginWithEmainAndPassword(
      {required String email, required String password}) async {
    try {
      User user = (await auth.signInWithEmailAndPassword(
              email: email, password: password))
          .user!;

      if (user != null) return true;
    } on FirebaseAuthException catch (e) {
      return e.code;
    }
  }

  Future signOut() async {
    try {
      await Helper.saveUserLoggedInStatus(false);
      await Helper.saveUserEmailSF('');
      await Helper.saveUsernameSF('');
      await auth.signOut();
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }
}
