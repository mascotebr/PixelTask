import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:pixel_tasks/main.dart';

class AuthException implements Exception {
  String message;
  AuthException(this.message);
}

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? userA;
  bool isLoading = true;

  AuthService() {
    _authCheck();
  }

  _authCheck() {
    _auth.authStateChanges().listen((User? user) {
      userA = (user == null) ? null : user;
      isLoading = false;
      notifyListeners();
    });
  }

  _getUser() {
    userA = _auth.currentUser;
    notifyListeners();
  }

  register(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      _getUser();
    } on FirebaseAuthException catch (e) {
      if (e.code == "weak-password") {
        throw AuthException("Password is too weak!");
      } else if (e.code == 'email-already-in-use') {
        throw AuthException('This email is alreadt used!');
      }
    }
  }

  login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      _getUser();
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        throw AuthException("User not found!");
      } else if (e.code == 'wrong-password') {
        throw AuthException('Wrong password. Try again!');
      }
    }
  }

  logout(BuildContext context) async {
    await _auth.signOut();
    _getUser();
    // ignore: use_build_context_synchronously
    RestartWidget.restartApp(context);
  }
}
