import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:pixel_tasks/model/task.dart';
import 'package:pixel_tasks/services/auth_service.dart';
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
    if (auth.userA != null && list.isEmpty) {
      final snapshot =
          await db.collection('users/${auth.userA!.uid}/tasks').get();
      list.addAll(
          snapshot.docs.map((doc) => Task.fromJson(doc.data())).toList());
      notifyListeners();
    }
  }

  save(Task task) {
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

    db.collection("users/${auth.userA!.uid}/tasks").doc(task.key).set({
      'key': task.key,
      'title': task.title,
      'description': task.description,
      'date': task.date?.toIso8601String(),
      'isDaily': task.isDairy,
      'difficulty': task.difficulty.toString(),
      'lastFinish': task.lastFinish?.toIso8601String(),
      'repeat': task.repeat
    });
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
          'isDaily': task.isDairy,
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
}
