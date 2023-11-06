import 'dart:async';

import 'package:firstapp/screens/move_category.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/breakdance_move.dart';
import 'move_detail.dart';

class MoveFormPage extends StatefulWidget {
  final List<BreakdanceMove> moves;
  final void Function(dynamic) onSave;

  const MoveFormPage({super.key, required this.moves, required this.onSave});

  @override
  MoveFormPageState createState() => MoveFormPageState();
}

class MoveFormPageState extends State<MoveFormPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final StreamController<XFile?> _imageStreamController =
      StreamController<XFile?>.broadcast();

  String _name = "";
  String _category = "";
  String _description = "";
  int _difficulty = 1;

  final List<MoveCategory> _categories = [
    MoveCategory(
        name: 'Toprock', path: 'assets/icons/category_icons/toprock.png'),
    MoveCategory(
        name: 'Footwork', path: 'assets/icons/category_icons/footwork.png'),
    MoveCategory(
        name: 'Powermove', path: 'assets/icons/category_icons/powermove.png'),
    MoveCategory(
        name: 'Freeze', path: 'assets/icons/category_icons/freeze.png'),
    MoveCategory(
        name: 'Transition', path: 'assets/icons/category_icons/loading.png'),
    MoveCategory(
        name: 'Floorwork', path: 'assets/icons/category_icons/freeze.png'),
    MoveCategory(name: 'Burns', path: 'assets/icons/category_icons/burns.png'),
    MoveCategory(name: 'Custom', path: 'assets/icons/category_icons/add.png'),
  ];

  void _saveMove() {
    // Get the values of the form fields
    String name = _name;
    String category = _category;
    int difficulty = _difficulty;
    String description = _description;

    BreakdanceMove newMove = BreakdanceMove(
      name: name,
      description: description,
      category: category,
      difficulty: difficulty.toInt(),
      dateCreated: DateTime.now(),
    );

    //Call save function
    widget.onSave(newMove);
    // Close the current page
    Navigator.pop(context, newMove);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Move'),
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (page) {
                setState(() {
                  _currentPage = page;
                });
              },
              itemCount: 2,
              itemBuilder: (context, index) {
                if (_currentPage == 0) {
                  return CategoryStep(
                    categories: _categories,
                    selectedCategory: _category,
                    onChanged: (value) {
                      setState(() {
                        _category = value;
                      });
                    },
                  );
                } else if (_currentPage == 1) {
                  return MoveDetailStep(
                    name: _name,
                    description: _description,
                    difficulty: _difficulty.toDouble(),
                    //image: _imageStreamController.stream.first,
                    onChanged: (name, description, difficulty) {
                      setState(() {
                        _name = name;
                        _description = description;
                        _difficulty = difficulty;
                      });
                    },
                  );
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (_currentPage > 0)
                  ElevatedButton(
                    onPressed: () {
                      _pageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: const Text('Previous'),
                  ),
                if (_currentPage < 1)
                  ElevatedButton(
                    onPressed: () {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: const Text('Next'),
                  ),
                if (_currentPage == 1)
                  ElevatedButton(
                    onPressed: _saveMove,
                    child: const Text('Save'),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
