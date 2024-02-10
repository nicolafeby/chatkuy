import 'package:chatkuy/helper/sf_helper.dart';
import 'package:chatkuy/service/database_service.dart';
import 'package:chatkuy/service/firestore_service.dart';
import 'package:chatkuy/service/notif_service.dart';
import 'package:chatkuy/service/storage_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future registerWithEmainAndPassword({
    required String fullName,
    required String userName,
    required String email,
    required String password,
    required String profilePicture,
  }) async {
    try {
      User? user = (await auth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user;

      if (user != null) {
        await DatabaseService(uid: user.uid).saveUserData(
          fullName,
          email,
          profilePicture,
          userName,
        );
        return true;
      }
    } on FirebaseAuthException catch (e) {
      return e.code;
    }
  }

  Future registerAccount({
    required String fullName,
    required String userName,
    required String email,
    required String password,
    required Uint8List? profilePicture,
    required NotificationsService notifications,
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
          name: fullName,
        );

        return true;
      }
    } on FirebaseAuthException catch (e) {
      return e.code;
      // final snackBar = SnackBar(content: Text(e.message!));
      // ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
      return e.code;
    }
  }

  Future signOut() async {
    try {
      await auth.signOut();
      await SfHelper.saveUserLoggedInStatus(false);
      await SfHelper.saveUserEmailSF('');
      await SfHelper.saveFullNameSF('');
      await SfHelper.saveProfilePictureSF('');
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }
}
