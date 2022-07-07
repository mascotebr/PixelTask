class Achievements {
  String? name = "";
  String? description3 = "";
  String? description2 = "";
  String? description1 = "";
  int? medal = 0;
  Achievements(
      {this.name, this.description3, this.description2, this.description1});

  Map toJson() => {
        'name': name,
        'description3': description3,
        'description2': description2,
        'description1': description1,
        'medal': medal,
      };

  Achievements.fromJson(Map json)
      : name = json['name'] ?? "",
        description3 = json['description3'] ?? "",
        description2 = json['description2'] ?? "",
        description1 = json['description1'] ?? "",
        medal = json['medal'] ?? 0;
}
