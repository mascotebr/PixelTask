import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pixel_tasks/services/auth_service.dart';

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
    if (auth.userA != null && single.name == "") {
      final snapshot =
          await db.collection('users/${auth.userA!.uid}/char').get();

      single = snapshot.docs
              .map((single) => Char.fromJson(single.data()))
              .toList()
              .isNotEmpty
          ? snapshot.docs.map((single) => Char.fromJson(single.data())).first
          : Char();
      notifyListeners();
    }
  }

  save(Char char) {
    single = char;
    db.collection("users/${auth.userA!.uid}/char").doc().set({
      'name': single.name,
      'classChar': single.classChar.toString(),
      'color': single.color,
      'exp': single.exp,
      'level': single.level,
      'achievements': achievements,
    });
    notifyListeners();
  }

  double get maxExp {
    single.expMax = 20;
    for (var i = 1; i < single.level; i++) {
      single.expMax *= 2;
    }
    return single.expMax;
  }

  double widthExp(BuildContext context) {
    return MediaQuery.of(context).size.width * (single.exp / maxExp);
  }

  Future<void> addExp(double exp) async {
    single.exp += exp;
    if (single.exp >= single.expMax) {
      single.exp -= single.expMax;
      single.level++;
    }
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
    List<Achievements> actualAchievements = single.achievements;
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
      single.achievements.add(achievements[0]);
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
      single.achievements.add(achievements[1]);
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
      single.achievements.add(achievements[2]);
    }

    List<Achievements> newAchievements = <Achievements>[];

    for (var a in single.achievements) {
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

  Widget pixelChar(
      BuildContext context, double minusWidth, double maxWidthPorcent) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
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
                "${single.exp.round()} / ${maxExp.round()}",
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
                  color: Color(single.color),
                  width: MediaQuery.of(context).size.width - minusWidth,
                  height: 4,
                ),
              ),
              Container(
                color: Color(single.color),
                width: widthExp(context) * maxWidthPorcent,
                height: 4,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Center(child: Image.asset(single.classChar.image)),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Center(
            child: Text(single.name,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold)),
          ),
        )
      ],
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
