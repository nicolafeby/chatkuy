import 'package:chatkuy/helper/sf_helper.dart';
import 'package:chatkuy/service/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
