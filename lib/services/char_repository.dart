import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pixel_tasks/services/auth_service.dart';
import 'package:pixel_tasks/utils/connectivity_util.dart';
import 'package:pixel_tasks/utils/design_util.dart';

import '../model/achievements.dart';
import '../model/char.dart';
import '../model/class_char.dart';
import '../model/task.dart';
import '../utils/dbfirestore_util.dart';

class CharRepository extends ChangeNotifier {
  Char single = Char();
  List<Achievements> achievements = <Achievements>[];

  late FirebaseFirestore db;
  late AuthService auth;

  CharRepository({required this.auth}) {
    _startRepository();
  }

  _startRepository() async {
    await _startFirestore();
    await _readChar();
  }

  _startFirestore() {
    db = DBFirestore.get();
  }

  _readChar() async {
    if (auth.userP != null && single.name == "") {
      if (await ConnectivityUtil.verify()) {
        final snapshot =
            await db.collection('users/${auth.userA!.uid}/char').get();

        single = snapshot.docs
                .map((single) => Char.fromJson(single.data()))
                .toList()
                .isNotEmpty
            ? snapshot.docs.map((single) => Char.fromJson(single.data())).first
            : Char();
      } else {
        single = await _readCharDoc();
      }
      single.isLoaded = true;
      notifyListeners();
    }
  }

  save(Char char) async {
    single = char;
    single.isLoaded = true;

    if (await ConnectivityUtil.verify()) {
      db.collection("users/${auth.userA!.uid}/char").doc(single.key).set({
        'key': single.key,
        'name': single.name,
        'classChar': single.classChar.toString(),
        'color': single.color,
        'experience': single.experience,
        'level': single.level,
      });
    }
    await _writeCharDoc(char);

    notifyListeners();
  }

  int get maxExp {
    single.expMax = 20;
    for (var i = 1; i < single.level; i++) {
      single.expMax *= 2;
    }
    return single.expMax;
  }

  double widthExp(BuildContext context) {
    return MediaQuery.of(context).size.width * (single.experience / maxExp);
  }

  Future<void> addExp(int exp) async {
    single.experience += exp;
    if (single.experience >= single.expMax) {
      single.experience -= single.expMax;
      single.level++;
    }
    notifyListeners();
    save(single);
  }

  getAchivements() {
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

  Future<List<Achievements>> checkAchivements(List<Task> tasksFinished) async {
    getAchivements();
    List<Achievements>? actualAchievements =
        single.achievements ?? <Achievements>[];
    single.achievements = <Achievements>[];

    //Level 5
    if (single.level >= 5) {
      achievements[0].medal = 3;
      //Level 10
      if (single.level >= 10) {
        achievements[0].medal = 2;
        //Level 15
        if (single.level >= 15) {
          achievements[0].medal = 1;
        }
      }
      single.achievements!.add(achievements[0]);
    }

    List<Task> tasksFinished = <Task>[];
    List<Task> tasks = tasksFinished;

    for (var i = 0; i < tasks.length; i++) {
      if (tasks[i].isDaily) {
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
      single.achievements!.add(achievements[1]);
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
      single.achievements!.add(achievements[2]);
    }

    List<Achievements> newAchievements = <Achievements>[];

    for (var a in single.achievements!) {
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
    // await writeChar(single);
    save(single);

    return newAchievements;
  }

  List<ClassChar> get listAchievements {
    List<ClassChar> list = <ClassChar>[];
    single.achievements = single.achievements ?? <Achievements>[];

    list.add(ClassChar.archer);
    list.add(ClassChar.mage);
    list.add(ClassChar.thief);
    list.add(ClassChar.warrior);

    if (single.achievements!.where((a) => a.name == "E X P E R T").isNotEmpty) {
      list.add(ClassChar.liver);
    }

    if (single.achievements!.where((a) => a.name == "SUN WORKER").isNotEmpty) {
      list.add(ClassChar.sunWorker);
    }

    if (single.achievements!
        .where((a) => a.name == "MASTER WRITER")
        .isNotEmpty) {
      list.add(ClassChar.pencilMaster);
    }

    return list;
  }

  //Documents
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/char.txt');
  }

  Future<void> _writeCharDoc(Char char) async {
    final file = await _localFile;
    String json = jsonEncode(char);
    await file.writeAsString(json);
  }

  Future<Char> _readCharDoc() async {
    try {
      final file = await _localFile;
      final contents = await file.readAsString();
      dynamic obj = json.decode(contents);
      return Char.fromJson(obj);
    } catch (e) {
      return Char();
    }
  }

//Widgets

  Widget pixelChar(
      BuildContext context, double minusWidth, double maxWidthPorcent) {
    return single.isLoaded
        ? Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    top: 24.0, bottom: 8.0, left: 16.0, right: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      "Level ${single.level}",
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "${single.experience.round()} / ${maxExp.round()}",
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
                    Container(
                      width: MediaQuery.of(context).size.width - minusWidth,
                      height: 12,
                      color: DesignUtil.darkGray,
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 2, left: 2, right: 2),
                      color: Color(single.color),
                      width: widthExp(context) * maxWidthPorcent,
                      height: 8,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: Center(child: Image.asset(single.classChar.image)),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                width: single.name.length * 20,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(30.0),
                  ),
                  color: DesignUtil.gray,
                ),
                child: Center(
                  child: Text(single.name,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28.0,
                          fontWeight: FontWeight.bold)),
                ),
              )
            ],
          )
        : Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(180.0),
              ),
              color: DesignUtil.darkGray,
            ),
            child: const Center(
              child: CircularProgressIndicator(
                strokeWidth: 6,
                color: Colors.white,
              ),
            ),
          );
  }

  Widget medalImage(int medal) {
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
