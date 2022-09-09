import 'package:pixel_tasks/model/Difficulty.dart';

class TaskUtil {
  static Difficulty getDifficulty(String string) {
    switch (string) {
      case "Difficulty.easy":
        return Difficulty.easy;
      case "Difficulty.medium":
        return Difficulty.medium;
      case "Difficulty.hard":
        return Difficulty.hard;
    }

    return Difficulty.easy;
  }

  static Difficulty getDifficultyInt(int int) {
    switch (int) {
      case 1:
        return Difficulty.easy;
      case 2:
        return Difficulty.medium;
      case 3:
        return Difficulty.hard;
    }

    return Difficulty.easy;
  }
}
