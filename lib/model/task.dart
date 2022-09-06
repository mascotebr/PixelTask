import 'package:pixel_tasks/model/Difficulty.dart';
import 'package:pixel_tasks/utils/task_util.dart';

class Task {
  String key = "";
  String title = "";
  String? description;
  DateTime? date = DateTime.now();
  bool isDaily = false;
  DateTime? lastFinish = DateTime.now().add(const Duration(days: -1));

  Difficulty difficulty = Difficulty.easy;

  int repeat = 0;

  Task();

  Map toJson() => {
        'key': key,
        'title': title,
        'description': description,
        'date': date?.toIso8601String(),
        'isDaily': isDaily,
        'lastFinish': lastFinish?.toIso8601String(),
        'difficulty': difficulty.toString(),
      };

  Task.fromJson(Map json)
      : key = json['key'],
        title = json['title'],
        description = json['description'],
        date = DateTime.parse(json['date']),
        isDaily = json['isDaily'],
        lastFinish = DateTime.parse(json['lastFinish']),
        difficulty = json['difficulty'] == null
            ? Difficulty.easy
            : TaskUtil.getDifficulty(json['difficulty']);
}
