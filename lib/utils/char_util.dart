import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pixel_tasks/model/achievements.dart';
import 'package:pixel_tasks/model/task.dart';
import 'package:pixel_tasks/utils/task_util.dart';

import '../model/char.dart';
import '../model/class_char.dart';

class CharUtil {
  static Char char = Char();
  static List<Achievements> achievements = <Achievements>[];

  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  static Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/char.txt');
  }

  static Future<void> writeChar(Char char) async {
    final file = await _localFile;
    String json = jsonEncode(char);
    file.writeAsString(json);
    await setChar();
  }

  static Future<Char> readChar() async {
    try {
      final file = await _localFile;
      final contents = await file.readAsString();
      dynamic obj = json.decode(contents);
      return Char.fromJson(obj);
    } catch (e) {
      return Char();
    }
  }

  static Future<Char> setChar() async {
    char = await readChar();
    return char;
  }

  static double get maxExp {
    char.expMax = 20;
    for (var i = 1; i < char.level; i++) {
      char.expMax *= 2;
    }
    return char.expMax;
  }

  static double widthExp(BuildContext context) {
    return MediaQuery.of(context).size.width * (char.exp / maxExp);
  }

  static Future<void> addExp(double exp) async {
    char.exp += exp;
    if (char.exp >= char.expMax) {
      char.exp -= char.expMax;
      char.level++;
    }

    await writeChar(char);
    await setChar();
  }

  static ClassChar getClassChar(String string) {
    switch (string) {
      case "ClassChar.warrior":
        return ClassChar.warrior;
      case "ClassChar.thief":
        return ClassChar.thief;
      case "ClassChar.mage":
        return ClassChar.mage;
      case "ClassChar.archer":
        return ClassChar.archer;
    }

    return ClassChar.warrior;
  }

  static void getAchivements() {
    achievements = <Achievements>[];
    achievements.add(Achievements(
        name: "E X P E R T",
        description3: "Reach Level 5",
        description2: "Reach Level 10",
        description1: "Reach Level 15"));
    achievements.add(Achievements(
      name: "SUN WORKER",
      description3: "Complete for 30 days a daily task",
      description2: "Complete for 60 days a daily task",
      description1: "Complete for 90 days a daily task",
    ));
    achievements.add(Achievements(
      name: "MASTER WRITER",
      description3: "Complete 100 Tasks",
      description2: "Complete 200 Tasks",
      description1: "Complete 500 Tasks",
    ));
  }

  static Future<List<Achievements>> checkAchivements() async {
    getAchivements();
    List<Achievements> actualAchievements = char.achievements;
    char.achievements = <Achievements>[];

    //Level 5
    if (char.level >= 5) {
      achievements[0].medal = 3;
      //Level 10
      if (char.level >= 10) {
        achievements[0].medal = 2;
        //Level 15
        if (char.level >= 15) {
          achievements[0].medal = 1;
        }
      }
      char.achievements.add(achievements[0]);
    }

    List<Task> tasksFinished = <Task>[];
    List<Task> tasks = await TaskUtil.readTasksFinished();

    for (var i = 0; i < tasks.length; i++) {
      if (tasks[i].isDairy) {
        int repeat = tasks.where((t) => t.key == tasks[i].key).length;
        tasks[i].repeat = repeat;
        tasksFinished.add(tasks[i]);
        tasks.removeWhere((t) => t.key == tasks[i].key);
      }
    }

    //1 Month Tasks Daily
    if (tasksFinished.where((t) => t.repeat > 30).isNotEmpty) {
      achievements[1].medal = 3;
      //2 Month Tasks Daily
      if (tasksFinished.where((t) => t.repeat > 60).isNotEmpty) {
        achievements[1].medal = 2;
        //3 Month Tasks Daily
        if (tasksFinished.where((t) => t.repeat > 90).isNotEmpty) {
          achievements[1].medal = 1;
        }
      }
      char.achievements.add(achievements[1]);
    }

    //100 Tasks writes
    if (tasksFinished.length >= 100) {
      achievements[2].medal = 3;
      if (tasksFinished.length >= 200) {
        //200 Tasks writes
        achievements[2].medal = 2;
        //300 Tasks writes
        if (tasksFinished.length >= 500) {
          achievements[2].medal = 1;
        }
      }
      char.achievements.add(achievements[2]);
    }

    List<Achievements> newAchievements = <Achievements>[];

    for (var a in char.achievements) {
      //Add a new achievement
      List<Achievements> aux =
          actualAchievements.where((act) => a.name == act.name).toList();

      if (aux.isEmpty) {
        newAchievements.add(a);
      } else {
        //Add change medal
        aux = actualAchievements
            .where((act) => a.name == act.name && a.medal != act.medal)
            .toList();
        if (aux.isNotEmpty) {
          newAchievements.add(aux.first);
        }
      }
    }
    await writeChar(char);

    return newAchievements;
  }

  static Widget pixelChar(
      BuildContext context, double minusWidth, double maxWidthPorcent) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                "Level ${CharUtil.char.level}",
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                "${CharUtil.char.exp.round()} / ${CharUtil.maxExp.round()}",
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Stack(
            children: [
              Opacity(
                opacity: 0.3,
                child: Container(
                  color: Color(CharUtil.char.color),
                  width: MediaQuery.of(context).size.width - minusWidth,
                  height: 4,
                ),
              ),
              Container(
                color: Color(CharUtil.char.color),
                width: CharUtil.widthExp(context) * maxWidthPorcent,
                height: 4,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Center(child: Image.asset(CharUtil.char.classChar.image)),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Center(
            child: Text(CharUtil.char.name,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold)),
          ),
        )
      ],
    );
  }

  static Widget medalImage(int medal) {
    switch (medal) {
      case 1:
        return Image.asset(
          'images/medals/medal1.png',
        );

      case 2:
        return Image.asset(
          'images/medals/medal2.png',
        );

      case 3:
        return Image.asset(
          'images/medals/medal3.png',
        );
      default:
        return Opacity(
            opacity: 0.5,
            child: Image.asset(
              'images/medals/nomedal.png',
            ));
    }
  }
}
