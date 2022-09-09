import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pixel_tasks/main.dart';
import 'package:pixel_tasks/model/user_pixel.dart';
import 'package:pixel_tasks/utils/connectivity_util.dart';

class AuthException implements Exception {
  String message;
  AuthException(this.message);
}

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? userA;
  UserPixel? userP;
  bool isLoading = true;

  AuthService() {
    verifyConnected();
  }

  verifyConnected() async {
    if (await ConnectivityUtil.verify()) {
      _authCheck();
    } else {
      _authDoc();
    }
  }

  _authCheck() {
    _auth.authStateChanges().listen((User? user) {
      userA = (user == null) ? null : user;
      userP = (user == null) ? null : UserPixel(email: user.email);
      isLoading = false;
      notifyListeners();
    });
  }

  _getUser() async {
    userA = _auth.currentUser;
    userP = (_auth.currentUser == null)
        ? null
        : UserPixel(email: _auth.currentUser!.email);
    writeUser(userP!);
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
    if (await ConnectivityUtil.verify()) {
      await _auth.signOut();
    }

    _getUser();
    // ignore: use_build_context_synchronously
    RestartWidget.restartApp(context);
  }

  //Documents

  _authDoc() async {
    userP = await _readUserDoc();
    isLoading = false;
    notifyListeners();
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/user.txt');
  }

  Future<void> writeUser(UserPixel? user) async {
    if (user == null) {
      await _deleteUserDoc();
      return;
    }
    final file = await _localFile;
    String json = jsonEncode(user);
    await file.writeAsString(json);
    userP = user;
  }

  Future<void> _deleteUserDoc() async {
    final file = await _localFile;
    await file.delete();
  }

  Future<UserPixel?> _readUserDoc() async {
    try {
      final file = await _localFile;
      final contents = await file.readAsString();
      dynamic obj = json.decode(contents);
      return UserPixel.fromJson(obj);
    } catch (e) {
      return null;
    }
  }
}
