import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:pixel_tasks/model/Difficulty.dart';

import '../model/task.dart';

class TaskUtil {
  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  static Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/tasks.txt');
  }

  static Future<File> get _localFileFinish async {
    final path = await _localPath;
    return File('$path/tasks_finished.txt');
  }

  static Future<File> writeTask(Task task) async {
    final file = await _localFile;
    List<Task> tasks = await readTasks();
    tasks.add(task);
    String json = jsonEncode(tasks);
    return file.writeAsString(json);
  }

  static Future<File> writeTaskFinish(Task task) async {
    final file = await _localFile;
    List<Task> tasks = await readTasks();

    int indexFind = 0;
    int i = 0;
    do {
      if (tasks[i].key == task.key) {
        indexFind = i;
      }
      i++;
    } while (indexFind == 0 && i < tasks.length);

    tasks[indexFind].lastFinish = DateTime.now();
    task.lastFinish = DateTime.now();

    if (!task.isDaily) tasks.removeAt(indexFind);

    String json = jsonEncode(tasks);
    file.writeAsString(json);

    final fileFinish = await _localFileFinish;
    List<Task> tasksFinished = await readTasksFinished();
    tasksFinished.add(task);
    json = jsonEncode(tasksFinished);
    return fileFinish.writeAsString(json);
  }

  static Future<File> editTask(Task task) async {
    final file = await _localFile;
    List<Task> tasks = await readTasks();

    int indexFind = 0;
    int i = 0;
    do {
      if (tasks[i].key == task.key) {
        indexFind = i;
      }
      i++;
    } while (indexFind == 0 && i < tasks.length);

    tasks[indexFind] = task;

    String json = jsonEncode(tasks);
    return file.writeAsString(json);
  }

  static Future<File> deleteTask(Task task) async {
    final file = await _localFile;
    List<Task> tasks = await readTasks();

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

  static Future<List<Task>> readTasks() async {
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

  static Future<List<Task>> readTasksFinished() async {
    try {
      final file = await _localFileFinish;
      final contents = await file.readAsString();
      Iterable list = json.decode(contents);
      return list.map((model) => Task.fromJson(model)).toList();
    } catch (e) {
      return <Task>[];
    }
  }

  static Difficulty getDifficulty(String string) {
    switch (string) {
      case "Difficulty.easy":
        return Difficulty.easy;
      case "Difficulty.medium":
        return Difficulty.medium;
      case "Difficulty.hard":
        return Difficulty.hard;
    }

    return Difficulty.easy;
  }

  static Difficulty getDifficultyInt(int int) {
    switch (int) {
      case 1:
        return Difficulty.easy;
      case 2:
        return Difficulty.medium;
      case 3:
        return Difficulty.hard;
    }

    return Difficulty.easy;
  }
}
