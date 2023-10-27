import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MoveDetailStep extends StatelessWidget {
  final double difficulty;
  final String description;
  final String name;
  final void Function(String, String, int) onChanged;
  MoveDetailStep({
    required this.name,
    required this.description,
    required this.difficulty,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          decoration: InputDecoration(labelText: "Name"),
          onChanged: (value) {
            final updateName = value;
            onChanged(updateName, description, difficulty.toInt());
          },
        ),
        Slider(
          value: difficulty,
          min: 1,
          max: 5,
          divisions: 4,
          onChanged: (value) {
            final updateDifficulty = value.toInt();
            onChanged(name, description, updateDifficulty);
          },
        ),
        Text('Difficulty: ${difficulty.toStringAsFixed(0)}'),
        TextField(
          decoration: InputDecoration(labelText: "Description"),
          maxLines: 3,
          onChanged: (value) {
            final updateDescription = value;
            onChanged(name, updateDescription, difficulty.toInt());
          },
        )
      ],
    );
  }
}
