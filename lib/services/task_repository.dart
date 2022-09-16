import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pixel_tasks/model/task.dart';
import 'package:pixel_tasks/services/auth_service.dart';
import 'package:pixel_tasks/utils/connectivity_util.dart';
import 'package:pixel_tasks/utils/dbfirestore_util.dart';

class TaskRepository extends ChangeNotifier {
  final List<Task> list = [];
  late FirebaseFirestore db;
  late AuthService auth;

  TaskRepository({required this.auth}) {
    _startRepository();
  }

  _startRepository() async {
    await _startFirestore();
    await _readTasks();
  }

  _startFirestore() {
    db = DBFirestore.get();
  }

  _readTasks() async {
    if (auth.userP != null && list.isEmpty) {
      if (await ConnectivityUtil.verify()) {
        final snapshot =
            await db.collection('users/${auth.userA!.uid}/tasks').get();
        list.addAll(
            snapshot.docs.map((doc) => Task.fromJson(doc.data())).toList());
      } else {
        list.addAll(await _readTasksDoc());
      }
      notifyListeners();
    }
  }

  save(Task task) async {
    int index = -1;
    for (var i = 0; i < list.length; i++) {
      //Edit task
      if (list[i].key == task.key) {
        list[i] = task;
        index = i;
      }
    }
    if (index == -1) {
      list.add(task);
    }

    if (await ConnectivityUtil.verify()) {
      db.collection("users/${auth.userA!.uid}/tasks").doc(task.key).set({
        'key': task.key,
        'title': task.title,
        'description': task.description,
        'date': task.date?.toIso8601String(),
        'isDaily': task.isDaily,
        'difficulty': task.difficulty.toString(),
        'lastFinish': task.lastFinish?.toIso8601String(),
        'repeat': task.repeat
      });
    }

    _writeTaskDoc(task);

    notifyListeners();
  }

  saveAll(List<Task> tasks) {
    // ignore: avoid_function_literals_in_foreach_calls
    tasks.forEach((task) async {
      if (!list.any((atual) => atual.key == task.key)) {
        list.add(task);
        db.collection("users/${auth.userA!.uid}/tasks").doc(task.key).set({
          'key': task.key,
          'title': task.title,
          'description': task.description,
          'date': task.date,
          'isDaily': task.isDaily,
          'difficulty': task.difficulty,
          'lastFinish': task.lastFinish,
          'repeat': task.repeat
        });
      }
    });
    notifyListeners();
  }

  remove(Task task) async {
    await db
        .collection('users/${auth.userA!.uid}/tasks')
        .doc(task.key)
        .delete();
    list.remove(task);
    notifyListeners();
  }

  //Documents
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/tasks.txt');
  }

  Future<File> _writeTaskDoc(Task task) async {
    final file = await _localFile;
    String json = jsonEncode(list);
    return file.writeAsString(json);
  }

  Future<File> editTask(Task task) async {
    final file = await _localFile;

    int indexFind = 0;
    int i = 0;
    do {
      if (list[i].key == task.key) {
        indexFind = i;
      }
      i++;
    } while (indexFind == 0 && i < list.length);

    list[indexFind] = task;

    String json = jsonEncode(list);
    return file.writeAsString(json);
  }

  Future<File> deleteTask(Task task) async {
    final file = await _localFile;

    int indexFind = 0;
    int i = 0;
    do {
      if (list[i].key == task.key) {
        indexFind = i;
      }
      i++;
    } while (indexFind == 0 && i < list.length);

    list.removeAt(indexFind);

    String json = jsonEncode(list);
    return file.writeAsString(json);
  }

  Future<List<Task>> _readTasksDoc() async {
    try {
      final file = await _localFile;
      final contents = await file.readAsString();
      Iterable list = json.decode(contents);
      List<Task> tasks = list.map((model) => Task.fromJson(model)).toList();

      tasks.sort(((a, b) => a.date!.compareTo(b.date!)));

      return tasks;
    } catch (e) {
      return <Task>[];
    }
  }
}
