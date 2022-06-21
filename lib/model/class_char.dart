enum ClassChar {
  warrior,
  thief,
  mage,
  archer;
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
    }
  }
}
