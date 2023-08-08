import 'package:flutter/material.dart';

import '../models/breakdance_move.dart';
import '../utils/shared_preference_helper.dart';

class SelectMovePage extends StatefulWidget {
  @override
  _SelectMovePageState createState() => _SelectMovePageState();
}

class _SelectMovePageState extends State<SelectMovePage> {
  final TextEditingController _searchController = TextEditingController();
  List<BreakdanceMove> searchResults = [];
  List<BreakdanceMove> allMoves = [];
  List<BreakdanceMove> selectedMoves = [];
  @override
  void initState() {
    super.initState();
    loadMoves();
  }

  void loadMoves() async {
    List<BreakdanceMove> savedMoves = await SharedPreferencesHelper.getMoves();
    setState(() {
      allMoves = savedMoves;
      selectedMoves =
          savedMoves; // Initialize filteredMoves with all moves initially
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (allMoves.isEmpty) {
      // If the allMoves list is empty, you can show a loading spinner or a message
      return Scaffold(
        appBar: AppBar(
          title: const Text("Select Move"),
        ),
        body: const Center(
          child:
              CircularProgressIndicator(), // You can replace this with your custom message
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Move"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: searchMoves,
              decoration: InputDecoration(
                labelText: "Search Moves",
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: clearSearch,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: selectedMoves.length,
              itemBuilder: (context, index) {
                var move = selectedMoves[index];
                return ListTile(
                  title: Text(move.name),
                  onTap: () {
                    // Handle the selection of moves here
                    Navigator.of(context).pop(
                        [move]); // Pass the selected move back to the popup
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void searchMoves(String searchTerm) {
    setState(() {
      if (searchTerm.isEmpty) {
        searchResults = allMoves;
      } else {
        searchResults = allMoves
            .where((move) =>
                move.name.toLowerCase().contains(searchTerm.toLowerCase()))
            .toList();
      }
    });
  }

  void clearSearch() {
    _searchController.clear();
    setState(() {
      searchResults = allMoves;
    });
  }
}
