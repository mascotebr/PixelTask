import 'package:flutter/material.dart';

enum Difficulty {
  easy,
  medium,
  hard;
}

extension DifficultyExtension on Difficulty {
  String get string {
    switch (this) {
      case Difficulty.easy:
        return 'Easy';
      case Difficulty.medium:
        return 'Medium';
      case Difficulty.hard:
        return 'Hard';
    }
  }
}

extension DifficultyExpExtension on Difficulty {
  double get exp {
    switch (this) {
      case Difficulty.easy:
        return 5;
      case Difficulty.medium:
        return 10;
      case Difficulty.hard:
        return 20;
    }
  }
}

extension DifficultyColorExtension on Difficulty {
  MaterialColor get color {
    switch (this) {
      case Difficulty.easy:
        return Colors.green;
      case Difficulty.medium:
        return Colors.yellow;
      case Difficulty.hard:
        return Colors.red;
    }
  }
}
