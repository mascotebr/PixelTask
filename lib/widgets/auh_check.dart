import 'package:flutter/material.dart';
import 'package:pixel_tasks/pages/home_page.dart';
import 'package:pixel_tasks/services/auth_service.dart';
import 'package:provider/provider.dart';

import '../pages/login_page.dart';

class AuthCheck extends StatefulWidget {
  const AuthCheck({Key? key}) : super(key: key);

  @override
  State<AuthCheck> createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  @override
  Widget build(BuildContext context) {
    AuthService auth = context.watch<AuthService>();

    if (auth.isLoading) {
      return loading();
    } else if (auth.userA == null) {
      return const LoginPage();
    } else {
      return const HomePage();
    }
  }
}

loading() {
  return const Scaffold(
    body: Center(child: CircularProgressIndicator()),
  );
}
