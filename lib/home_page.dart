import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pixel_tasks/widgets/card_task.dart';
import 'package:pixel_tasks/widgets/dialog_task.dart';
import 'package:pixel_tasks/widgets/silver_pixel.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'model/task.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    readAllTasks();

    super.initState();
  }

  int _selectedIndex = 0;
  List<Task> tasks = <Task>[];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _onCreateTask(Task task) async {
    await writeTask(task);
    tasks = await readTask();
    setState(() {});
  }

  Future<void> _onRemoveTask(Task task) async {
    await removeTask(task);
    tasks = await readTask();
    setState(() {});
  }

  Future<void> readAllTasks() async {
    tasks = await readTask();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff3B4254),
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: CustomScrollView(
        slivers: [
          const SilverPixel(),
          SliverList(
              delegate: SliverChildBuilderDelegate(
            (context, index) {
              return Dismissible(
                key: Key(tasks[index].key),
                background: Container(
                  color: const Color(0xff3B4254),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Icon(
                            Icons.check_circle,
                            color: Colors.green.withOpacity(0.8),
                            size: 32,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                onDismissed: (DismissDirection duration) {
                  _onRemoveTask(tasks[index]);
                },
                child: CardTask(
                  task: tasks[index],
                ),
              );
            },
            childCount: tasks.length,
          ))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialogTask(context, _onCreateTask),
        tooltip: 'New Task',
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.archive), label: ""),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();

  return directory.path;
}

Future<File> get _localFile async {
  final path = await _localPath;
  return File('$path/tasks.txt');
}

Future<File> writeTask(Task task) async {
  final file = await _localFile;
  List<Task> tasks = await readTask();
  tasks.add(task);
  String json = jsonEncode(tasks);
  return file.writeAsString(json);
}

Future<File> removeTask(Task task) async {
  final file = await _localFile;
  List<Task> tasks = await readTask();

  int indexFind = 0;
  int i = 0;
  do {
    if (tasks[i].key == task.key) {
      indexFind = i;
    }
    i++;
  } while (indexFind == 0 && i < tasks.length);

  tasks.removeAt(indexFind);
  String json = jsonEncode(tasks);
  return file.writeAsString(json);
}

Future<List<Task>> readTask() async {
  try {
    final file = await _localFile;
    final contents = await file.readAsString();
    Iterable list = json.decode(contents);
    return list.map((model) => Task.fromJson(model)).toList();
  } catch (e) {
    return <Task>[];
  }
}
