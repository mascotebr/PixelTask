import '../model/class_char.dart';

class CharUtil {
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
