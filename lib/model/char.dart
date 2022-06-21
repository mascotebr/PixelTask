import 'package:pixel_tasks/model/class_char.dart';
import 'package:pixel_tasks/utils/char_util.dart';

class Char {
  String name = "";
  ClassChar classChar = ClassChar.warrior;
  int color = 0xFF2196F3;
  double exp = 0;
  double expMax = 20;
  int level = 1;

  Char();

  Map toJson() => {
        'name': name,
        'classChar': classChar.toString(),
        'color': color,
        'exp': exp,
        'level': level,
      };

  Char.fromJson(Map json)
      : name = json['name'] ?? "",
        classChar = CharUtil.getClassChar(json['classChar']),
        color = json['color'] ?? 0xFF2196F3,
        exp = json['exp'] ?? 0,
        level = json['level'] ?? 1;
}
