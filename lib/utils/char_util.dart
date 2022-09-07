import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pixel_tasks/model/achievements.dart';

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
    await file.writeAsString(json);
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
      case "ClassChar.liver":
        return ClassChar.liver;
      case "ClassChar.pencilMaster":
        return ClassChar.pencilMaster;
      case "ClassChar.sunWorker":
        return ClassChar.sunWorker;
    }

    return ClassChar.warrior;
  }
}
