class BreakdanceMove {
  String name;
  String? description;
  String category;
  int difficulty;
  DateTime dateCreated;

  BreakdanceMove({
    required this.name,
    this.description,
    required this.category,
    required this.difficulty,
    required this.dateCreated,
  });

  factory BreakdanceMove.fromJson(Map<String, dynamic> json) {
    return BreakdanceMove(
      name: json['name'],
      description: json['description'],
      category: json['category'],
      difficulty: json['difficulty'],
      dateCreated: DateTime.parse(json['dateCreated']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'category': category,
      'difficulty': difficulty,
      'dateCreated': dateCreated.toIso8601String(),
    };
  }
}
