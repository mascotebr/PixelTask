import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';

import '../model/char.dart';
import '../model/class_char.dart';

class CharUtil {
  static Char char = Char();

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
}
