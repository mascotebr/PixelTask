import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:pixel_tasks/services/auth_service.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final email = TextEditingController();
  final password = TextEditingController();

  bool isLogin = true;
  late String title;
  late String toggleButton;
  late String actionButton;

  bool loading = false;

  @override
  void initState() {
    super.initState();
    setFormAction(true);
  }

  setFormAction(bool action) {
    setState(() {
      isLogin = action;
      if (isLogin) {
        title = 'Welcome to Pixel Task';
        actionButton = 'Login';
        toggleButton = 'Sign up';
      } else {
        title = 'Create your account';
        actionButton = 'Create';
        toggleButton = 'Back to login';
      }
    });
  }

  login() async {
    setState(() => loading = true);
    try {
      await context.read<AuthService>().login(email.text, password.text);
    } on AuthException catch (e) {
      setState(() => loading = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  register() async {
    setState(() => loading = true);
    try {
      await context.read<AuthService>().register(email.text, password.text);
    } on AuthException catch (e) {
      setState(() => loading = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff3B4254),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("images/background/background.gif"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          ClipRRect(
            // Clip it cleanly.
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                color: Colors.black.withOpacity(0.4),
                alignment: Alignment.center,
                child: SingleChildScrollView(
                    child: Form(
                        key: formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              title,
                              style: const TextStyle(
                                  fontSize: 35,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 64.0, left: 32, right: 32),
                              child: TextFormField(
                                controller: email,
                                style: const TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                    filled: true,
                                    fillColor: const Color(0xff3B4254)
                                        .withOpacity(0.5),
                                    labelText: 'Email',
                                    labelStyle:
                                        const TextStyle(color: Colors.white),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          width: 2, color: Colors.white10),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          width: 2, color: Colors.white54),
                                      borderRadius: BorderRadius.circular(15),
                                    )),
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Is not a email";
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 24.0, left: 32, right: 32),
                              child: TextFormField(
                                controller: password,
                                obscureText: true,
                                style: const TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                    filled: true,
                                    fillColor: const Color(0xff3B4254)
                                        .withOpacity(0.5),
                                    labelText: 'Password',
                                    labelStyle:
                                        const TextStyle(color: Colors.white),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          width: 2, color: Colors.white10),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          width: 2, color: Colors.white54),
                                      borderRadius: BorderRadius.circular(15),
                                    )),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Type the password";
                                  } else if (value.length < 6) {
                                    return "The password have 6 or more caracters";
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Container(
                              margin:
                                  const EdgeInsets.only(top: 48, bottom: 16),
                              width: MediaQuery.of(context).size.width * 0.5,
                              height: 45,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: const Color(0xff424C5E),
                              ),
                              child: TextButton(
                                child: !loading
                                    ? Text(
                                        actionButton,
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      )
                                    : const CircularProgressIndicator(
                                        color: Colors.white,
                                      ),
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    if (isLogin) {
                                      login();
                                    } else {
                                      register();
                                    }
                                  }
                                },
                              ),
                            ),
                            TextButton(
                                onPressed: () => setFormAction(!isLogin),
                                child: Text(toggleButton))
                          ],
                        ))),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
