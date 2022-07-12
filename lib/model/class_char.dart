import 'package:pixel_tasks/utils/char_util.dart';

enum ClassChar {
  warrior,
  thief,
  mage,
  archer,
  liver,
  pencilMaster,
  sunWorker;
}

extension ClassCharExtension on ClassChar {
  String get string {
    switch (this) {
      case ClassChar.warrior:
        return 'Warrior';
      case ClassChar.thief:
        return 'Thief';
      case ClassChar.mage:
        return 'Mage';
      case ClassChar.archer:
        return 'Archer';
      case ClassChar.liver:
        return 'Liver';
      case ClassChar.pencilMaster:
        return 'Pencil Master';
      case ClassChar.sunWorker:
        return 'Sun Worker';
    }
  }
}

extension ClassCharImageExtension on ClassChar {
  String get image {
    switch (this) {
      case ClassChar.warrior:
        return 'images/warrior.png';
      case ClassChar.thief:
        return 'images/thief.png';
      case ClassChar.mage:
        return 'images/mage.png';
      case ClassChar.archer:
        return 'images/archer.png';
      case ClassChar.liver:
        return 'images/liver.png';
      case ClassChar.pencilMaster:
        return 'images/pencil-master.png';
      case ClassChar.sunWorker:
        return 'images/sun-worker.png';
    }
  }
}

extension ClassCharListExtension on ClassChar {
  List<ClassChar> get listValues {
    List<ClassChar> list = <ClassChar>[];

    list.add(ClassChar.archer);
    list.add(ClassChar.mage);
    list.add(ClassChar.thief);
    list.add(ClassChar.warrior);

    if (CharUtil.char.achievements
        .where((a) => a.name == "E X P E R T")
        .isNotEmpty) {
      list.add(ClassChar.liver);
    }

    if (CharUtil.char.achievements
        .where((a) => a.name == "SUN WORKER")
        .isNotEmpty) {
      list.add(ClassChar.sunWorker);
    }

    if (CharUtil.char.achievements
        .where((a) => a.name == "MASTER WRITER")
        .isNotEmpty) {
      list.add(ClassChar.pencilMaster);
    }

    return list;
  }
}
