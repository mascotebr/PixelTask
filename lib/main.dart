import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pixel_tasks/firebase_options.dart';
import 'package:pixel_tasks/services/auth_service.dart';
import 'package:pixel_tasks/services/task_finished_repository.dart';
import 'package:pixel_tasks/services/task_repository.dart';
import 'package:pixel_tasks/widgets/auh_check.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (context) => AuthService()),
      ChangeNotifierProvider(
        create: (context) => TaskRepository(
          auth: context.read<AuthService>(),
        ),
      ),
      ChangeNotifierProvider(
        create: (context) => TaskFinishedRepository(
          auth: context.read<AuthService>(),
        ),
      ),
    ], child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pixel Tasks',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        secondaryHeaderColor: Colors.white,
        fontFamily: 'SF',
      ),
      home: const AuthCheck(),
    );
  }
}
