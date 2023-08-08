import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/breakdance_move.dart';
import '../models/set_model.dart';

class SharedPreferencesHelper {
  static const String movesKey = "breakdance_moves";
  static const String setsKey = "breakdance_sets";

  static Future<void> saveMoves(List<BreakdanceMove> moves) async {
    final prefs = await SharedPreferences.getInstance();
    final encodedMoves = json.encode(moves);
    await prefs.setString(movesKey, encodedMoves);
  }

  static Future<List<BreakdanceMove>> getMoves() async {
    final prefs = await SharedPreferences.getInstance();
    final encodedMoves = prefs.getString(movesKey);
    if (encodedMoves != null) {
      final List<dynamic> decodedMoves = json.decode(encodedMoves);
      return decodedMoves.map((move) => BreakdanceMove.fromJson(move)).toList();
    } else {
      return [];
    }
  }

  static Future<void> saveSets(List<SetModel> sets) async {
    final prefs = await SharedPreferences.getInstance();
    final encodedSets = json.encode(sets);
    await prefs.setString(setsKey, encodedSets);
  }

  static Future<List<SetModel>> getSets() async {
    final prefs = await SharedPreferences.getInstance();
    final encodedSets = prefs.getString(setsKey);
    if (encodedSets != null) {
      final List<dynamic> decodedSets = json.decode(encodedSets);
      return decodedSets.map((set) => SetModel.fromJson(set)).toList();
    } else {
      return [];
    }
  }
}
