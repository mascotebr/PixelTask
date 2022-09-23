import 'package:flutter/cupertino.dart';
import 'package:pixel_tasks/model/achievements.dart';
import 'package:pixel_tasks/model/class_char.dart';
import 'package:pixel_tasks/utils/char_util.dart';

class Char {
  String key = UniqueKey().toString();
  String name = "";
  ClassChar classChar = ClassChar.warrior;
  int color = 0xFF2196F3;
  int experience = 0;
  int exp = 0;
  int expMax = 20;
  int level = 1;
  List<Achievements>? achievements;
  bool isLoaded = false;

  Char();

  Map toJson() => {
        'key': key,
        'name': name,
        'classChar': classChar.toString(),
        'color': color,
        'experience': experience,
        'level': level,
      };

  Char.fromJson(Map json)
      : key = json['key'] ?? "",
        name = json['name'] ?? "",
        classChar = CharUtil.getClassChar(json['classChar']),
        color = json['color'] ?? 0xFF2196F3,
        experience = json['experience'],
        level = json['level'] ?? 1;
}
