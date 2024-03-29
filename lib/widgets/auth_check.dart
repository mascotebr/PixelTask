import 'package:flutter/material.dart';
import 'package:pixel_tasks/pages/home_page.dart';
import 'package:pixel_tasks/pages/pageview_page.dart';
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
    } else if (auth.userP == null) {
      return const LoginPage();
    } else {
      return const PageViewPage();
    }
  }
}

loading() {
  return const Scaffold(
    body: Center(
        child: SizedBox(
            width: 100, height: 100, child: CircularProgressIndicator())),
  );
}
