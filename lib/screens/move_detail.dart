import 'package:firstapp/utils/shared_preference_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/breakdance_move.dart';

class MoveDetailStep extends StatefulWidget {
  final String selectedCategory;
  final ValueChanged<String> onChanged;

  MoveDetailStep({
    required this.selectedCategory,
    required this.onChanged,
  });

  @override
  _MoveDetailsStepState createState() => _MoveDetailsStepState();
}

class _MoveDetailsStepState extends State<MoveDetailStep> {
  String name = "";
  int difficulty = 1;
  String description = "";

  void _saveMove() {
    if (name.isEmpty) {
      // Display an error message or handle empty name
      return;
    }
    BreakdanceMove newMove = BreakdanceMove(
      name: name,
      description: description,
      category: widget.selectedCategory,
      difficulty: difficulty,
      dateCreated: DateTime.now(),
    );

    // Implement the logic to save the move using SharedPreferencesHelper or any other method you're using
    List<BreakdanceMove> updatedMoves = [newMove];
    SharedPreferencesHelper.saveMoves(updatedMoves);

    // Close the current page
    Navigator.pop(context);
    widget.onChanged('media');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          decoration: InputDecoration(labelText: "Name"),
          onChanged: (value) {
            setState(() {
              name = value;
            });
          },
        ),
        TextField(
          decoration: InputDecoration(labelText: "Difficulty"),
          keyboardType: TextInputType.number,
          onChanged: (value) {
            setState(() {
              difficulty = int.tryParse(value) ?? 1;
            });
          },
        ),
        TextField(
          decoration: InputDecoration(labelText: "Description"),
          maxLines: 3,
          onChanged: (value) {
            setState(() {
              description = value;
            });
          },
        )
      ],
    );
  }
}
