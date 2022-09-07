import 'package:flutter/material.dart';
import 'package:pixel_tasks/widgets/auh_check.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pixel Tasks',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        secondaryHeaderColor: Colors.white,
        fontFamily: 'SF',
      ),
      home: const AuthCheck(),
    );
  }
}
