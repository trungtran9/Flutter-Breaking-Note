import 'package:firstapp/models/breakdance_move.dart';

class SetModel {
  String setName;
  List<BreakdanceMove> moves;

  SetModel({
    required this.setName,
    required this.moves,
  });

  factory SetModel.fromJson(Map<String, dynamic> json) {
    return SetModel(
      setName: json['setName'],
      moves: (json['moves'] as List)
          .map((move) => BreakdanceMove.fromJson(move))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'setName': setName,
      'moves': moves.map((move) => move.toJson()).toList(),
    };
  }
}
