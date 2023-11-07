import 'package:flutter/material.dart';

import '../models/breakdance_move.dart';
import '../utils/shared_preference_helper.dart';
import 'move_form_page.dart';

class MovesTab extends StatefulWidget {
  final SharedPreferencesHelper _sharedPreferencesHelper =
      SharedPreferencesHelper();
  SharedPreferencesHelper get sharedPreferencesHelper =>
      _sharedPreferencesHelper;

  MovesTab({super.key});

  @override
  _MovesTabState createState() => _MovesTabState();
}

class _MovesTabState extends State<MovesTab> {
  List<BreakdanceMove> moves = [];

  @override
  void initState() {
    super.initState();
    loadMoves();
  }

  void loadMoves() async {
    List<BreakdanceMove> savedMoves = await SharedPreferencesHelper.getMoves();
    setState(() {
      moves = savedMoves;
    });
  }

  void _editMove(BreakdanceMove move) {}

  void _handleMoveAdd(BreakdanceMove newMove) {
    List<BreakdanceMove> updatedMoves = [...moves, newMove];
    SharedPreferencesHelper.saveMoves(updatedMoves);
    setState(() {
      moves = updatedMoves;
    });
  }

  void _deleteMove(BreakdanceMove move) {
    setState(() {
      moves.removeWhere((element) => element == move);
      SharedPreferencesHelper.saveMoves(moves); // Save updated moves
    });
  }

  void _handleMoveEdit(BreakdanceMove editedMove) {
    List<BreakdanceMove> updatedMoves = [...moves];
    int moveIndex = updatedMoves
        .indexWhere((move) => move.dateCreated == editedMove.dateCreated);
    if (moveIndex != -1) {
      updatedMoves[moveIndex] = editedMove;
      SharedPreferencesHelper.saveMoves(updatedMoves);
      setState(() {
        moves = updatedMoves;
      });
    }
  }

  void addMove(BreakdanceMove move) {
    moves.add(move);
    SharedPreferencesHelper.saveMoves(moves);
  }

  @override
  Widget build(BuildContext context) {
    // Group the moves by category
    Map<String, List<BreakdanceMove>> movesByCategory = {};
    for (var move in moves) {
      movesByCategory.putIfAbsent(move.category, () => []);
      movesByCategory[move.category]!.add(move);
    }

    // Sort the categories in ascending order
    List<String> sortedCategories = movesByCategory.keys.toList();
    sortedCategories.sort();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Moves"),
      ),
      body: ListView.builder(
        itemCount: sortedCategories.length,
        itemBuilder: (context, index) {
          var category = sortedCategories[index];
          var movesInCategory = movesByCategory[category]!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  category,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: movesInCategory.map((move) {
                  return GestureDetector(
                    onTap: () {
                      _editMove(move);
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width / 2 -
                          20, // Adjust the width to fit 2 columns
                      padding: const EdgeInsets.all(
                          16.0), // Increase the padding for bigger buttons
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            move.name,
                            style: const TextStyle(
                              fontSize: 18, // Increase font size for move name
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Difficulty: ${move.difficulty}",
                            style: const TextStyle(
                              fontSize: 14, // Increase font size for difficulty
                              color: Colors.white,
                            ),
                          ),
                          PopupMenuButton<String>(
                            onSelected: (String choice) {
                              if (choice == 'Edit') {
                                _handleMoveEdit(move);
                              } else if (choice == 'Delete') {
                                _deleteMove(move);
                              }
                            },
                            itemBuilder: (BuildContext context) {
                              return ['Edit', 'Delete'].map((String choice) {
                                return PopupMenuItem<String>(
                                  value: choice,
                                  child: Text(choice),
                                );
                              }).toList();
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(
            MaterialPageRoute(
              builder: (context) => MoveFormPage(
                moves: moves,
                onSave: (move) {
                  addMove(move);
                  loadMoves;
                },
              ),
            ),
          )
              .then((result) {
            if (result != null && result is BreakdanceMove) {
              setState(() {});
            }
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
