import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:pixel_tasks/services/auth_service.dart';
import 'package:pixel_tasks/utils/bodys_util.dart';
import 'package:provider/provider.dart';

import '../utils/design_util.dart';

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

  FocusNode passwordFocus = FocusNode();

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
    return BodysUtil.bodyResponsiveHome(
        context,
        Scaffold(
          backgroundColor: DesignUtil.gray,
          body: Stack(
            fit: StackFit.expand,
            children: loginContainer(32),
          ),
        ),

        //Windows

        Scaffold(
          backgroundColor: DesignUtil.gray,
          appBar: AppBar(
            toolbarHeight: 0,
            backgroundColor: Colors.transparent,
          ),
          body: Stack(
            fit: StackFit.expand,
            children: loginContainer(MediaQuery.of(context).size.width * 0.25),
          ),
        ));
  }

  List<Widget> loginContainer(double padding) {
    return [
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
                          padding: EdgeInsets.only(
                              top: 64, left: padding, right: padding),
                          child: TextFormField(
                            controller: email,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: DesignUtil.gray.withOpacity(0.5),
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
                            onEditingComplete: () {
                              FocusScope.of(context)
                                  .requestFocus(passwordFocus);
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Is not a email";
                              }
                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 24.0, left: padding, right: padding),
                          child: TextFormField(
                            controller: password,
                            focusNode: passwordFocus,
                            obscureText: true,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: DesignUtil.gray.withOpacity(0.5),
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
                            onEditingComplete: () {
                              if (formKey.currentState!.validate()) {
                                if (isLogin) {
                                  login();
                                }
                              }
                            },
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
                        !loading
                            ? Container(
                                margin:
                                    const EdgeInsets.only(top: 48, bottom: 16),
                                width: MediaQuery.of(context).size.width * 0.5,
                                height: 45,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: const Color(0xff424C5E),
                                ),
                                child: TextButton(
                                  child: Text(
                                    actionButton,
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 20),
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
                              )
                            : Container(
                                margin:
                                    const EdgeInsets.only(top: 48, bottom: 16),
                                height: 45,
                                width: 45,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Colors.transparent),
                                child: const CircularProgressIndicator(
                                  color: Colors.white,
                                )),
                        TextButton(
                            onPressed: () => setFormAction(!isLogin),
                            child: Text(toggleButton))
                      ],
                    ))),
          ),
        ),
      )
    ];
  }
}
