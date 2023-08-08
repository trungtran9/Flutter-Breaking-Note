import 'package:flutter/material.dart';

import '../models/breakdance_move.dart';
import '../models/set_model.dart';
import '../utils/shared_preference_helper.dart';
import 'move_search.dart';

class SetsTab extends StatefulWidget {
  @override
  _SetTabState createState() => _SetTabState();
}

class _SetTabState extends State<SetsTab> {
  List<SetModel> sets = [];

  @override
  void initState() {
    super.initState();
    loadSets();
  }

  void loadSets() async {
    List<SetModel> savedSets = await SharedPreferencesHelper.getSets();
    setState(() {
      sets = savedSets;
    });
  }

  void _addSet(SetModel newSet) {
    List<SetModel> updatedSets = [...sets, newSet];
    SharedPreferencesHelper.saveSets(updatedSets);
    setState(() {
      sets = updatedSets;
    });
  }

  void _deleteSet(SetModel set) {
    List<SetModel> updatedSets = [...sets];
    updatedSets.remove(set);
    SharedPreferencesHelper.saveSets(updatedSets);
    setState(() {
      sets = updatedSets;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sets"),
      ),
      body: ListView.builder(
        itemCount: sets.length,
        itemBuilder: (context, index) {
          var set = sets[index];
          return ListTile(
            title: Text(set.setName),
            subtitle: Text(set.moves.map((move) => move.name).join(", ")),
            // Implement any logic for editing or deleting sets as needed
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) => AddSetPopup(
              addSet: _addSet,
              moves: [], // Pass the moves here
            ),
          ).then((_) {
            loadSets(); // Reload the sets after adding a new set
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class AddSetPopup extends StatefulWidget {
  final Function(SetModel) addSet;
  final List<BreakdanceMove> moves;

  AddSetPopup({required this.addSet, required this.moves});

  @override
  _AddSetPopupState createState() => _AddSetPopupState();
}

class _AddSetPopupState extends State<AddSetPopup> {
  String setName = "";
  List<BreakdanceMove> selectedMoves = [];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Add New Set"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            decoration: InputDecoration(labelText: "Set Name"),
            onChanged: (value) {
              setState(() {
                setName = value;
              });
            },
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Text("Sequence: "),
              TextButton(
                onPressed: () async {
                  _showSelectMovePage();
                },
                child: Text("Select Move"),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Text(
                  selectedMoves.isNotEmpty
                      ? selectedMoves.map((move) => move.name).join(", ")
                      : "No moves selected",
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () {
            SetModel newSet = SetModel(setName: setName, moves: selectedMoves);
            widget
                .addSet(newSet); // Call the addSet function provided by SetPage
            Navigator.of(context).pop();
          },
          child: Text("Save"),
        ),
      ],
    );
  }

  void _showSelectMovePage() async {
    List<BreakdanceMove>? selectedMovesResult =
        await Navigator.of(context).push<List<BreakdanceMove>>(
      MaterialPageRoute(
        builder: (context) => SelectMovePage(),
      ),
    );

    // If the selected moves are not null, update the selectedMoves list
    if (selectedMovesResult != null) {
      setState(() {
        selectedMoves.addAll(selectedMovesResult);
      });
    }
  }
}
