import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pixel_tasks/firebase_options.dart';
import 'package:pixel_tasks/myapp.dart';
import 'package:pixel_tasks/services/auth_service.dart';
import 'package:pixel_tasks/services/char_repository.dart';
import 'package:pixel_tasks/services/task_finished_repository.dart';
import 'package:pixel_tasks/services/task_repository.dart';
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
        create: (context) => CharRepository(
          auth: context.read<AuthService>(),
        ),
      ),
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
    ], child: const RestartWidget(child: MyApp())),
  );
}

class RestartWidget extends StatefulWidget {
  const RestartWidget({Key? key, required this.child}) : super(key: key);

  final Widget child;

  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_RestartWidgetState>()?.restartApp();
  }

  @override
  State<RestartWidget> createState() => _RestartWidgetState();
}

class _RestartWidgetState extends State<RestartWidget> {
  Key key = UniqueKey();

  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: key,
      child: widget.child,
    );
  }
}
