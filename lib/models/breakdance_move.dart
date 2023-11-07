class BreakdanceMove {
  String name;
  String? description;
  String category;
  int difficulty;
  DateTime dateCreated;
  String? videoPath;
  BreakdanceMove({
    required this.name,
    this.description,
    required this.category,
    required this.difficulty,
    required this.dateCreated,
    this.videoPath,
  });

  factory BreakdanceMove.fromJson(Map<String, dynamic> json) {
    return BreakdanceMove(
      name: json['name'],
      description: json['description'],
      category: json['category'],
      difficulty: json['difficulty'],
      dateCreated: DateTime.parse(json['dateCreated']),
      videoPath: json['videoPath'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'category': category,
      'difficulty': difficulty,
      'dateCreated': dateCreated.toIso8601String(),
      'videoPath': videoPath,
    };
  }
}
