class Task {
  String key = "";
  String title = "";
  String? description;
  DateTime? date;
  bool isDairy = false;
  DateTime? lastFinish = DateTime.now().add(const Duration(days: -1));

  Task();

  Map toJson() => {
        'key': key,
        'title': title,
        'description': description,
        'date': date?.toIso8601String(),
        'isDairy': isDairy,
        'lastFinish': lastFinish?.toIso8601String()
      };

  Task.fromJson(Map json)
      : key = json['key'],
        title = json['title'],
        description = json['description'],
        date = DateTime.parse(json['date']),
        isDairy = json['isDairy'],
        lastFinish = DateTime.parse(json['lastFinish']);
}
