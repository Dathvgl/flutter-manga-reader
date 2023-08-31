import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_crawl/models/user/user.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepository {
  final _firebaseAuth = FirebaseAuth.instance;
  final _googleSignIn = GoogleSignIn();

  UserModel? get currentUser {
    return _firebaseAuth.currentUser == null
        ? null
        : UserModel.copyWith(_firebaseAuth.currentUser!);
  }

  Future<String?> get currentUserIdToken {
    return _firebaseAuth.currentUser?.getIdToken() ?? Future(() => "");
  }

  Stream<UserModel> get user {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      final user = firebaseUser == null
          ? UserModel.empty
          : UserModel.copyWith(firebaseUser);

      return user;
    });
  }

  Future<UserCredential> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      final googleAuth = await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth?.idToken,
        accessToken: googleAuth?.accessToken,
      );

      return await _firebaseAuth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw Exception("${e.code}: ${e.message}");
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> signOut() async {
    try {
      await Future.wait([
        _firebaseAuth.signOut(),
        _googleSignIn.signOut(),
      ]);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
