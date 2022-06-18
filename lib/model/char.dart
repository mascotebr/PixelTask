class Char {
  String name = "";
  String? classChar = "Warrior";
  int color = 0xFF2196F3;
  double exp = 0;
  double expMax = 20;
  int level = 1;

  Char();

  Map toJson() => {
        'name': name,
        'classChar': classChar,
        'color': color,
        'exp': exp,
        'level': level,
      };

  Char.fromJson(Map json)
      : name = json['name'] ?? "",
        classChar = json['classChar'] ?? "Warrior",
        color = json['color'] ?? 0xFF2196F3,
        exp = json['exp'] ?? 0,
        level = json['level'] ?? 1;
}
