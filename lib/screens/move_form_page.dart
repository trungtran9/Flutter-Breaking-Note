import 'package:flutter/material.dart';

import '../models/breakdance_move.dart';
import 'move_detail.dart';

class MoveFormPage extends StatefulWidget {
  final List<BreakdanceMove> moves;

  MoveFormPage({required this.moves});

  @override
  _MoveFormPageState createState() => _MoveFormPageState();
}

class _MoveFormPageState extends State<MoveFormPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final String _name = "";
  String _category = "";
  String _description = "";
  int _difficulty = 1;

  final List<Widget Function(List<MoveCategory>, String, ValueChanged<String>)>
      _pages = [
    (categories, selectedCategory, onChanged) => ChooseCategoryStep(
          categories: categories,
          selectedCategory: selectedCategory,
          onChanged: onChanged,
        ),
    (categories, selectedCategory, onChanged) => MoveDetailStep(
          selectedCategory: selectedCategory,
          onChanged: onChanged,
        ),
    // ... rest of the pages ...
  ];
  final List<MoveCategory> _categories = [
    MoveCategory(name: 'Toprock', icon: Icons.directions_walk),
    MoveCategory(name: 'Footwork', icon: Icons.directions_run),
    MoveCategory(name: 'Powermove', icon: Icons.power),
    MoveCategory(name: 'Freeze', icon: Icons.ac_unit),
    MoveCategory(name: 'Transition', icon: Icons.compare_arrows),
    MoveCategory(name: 'Floorwork', icon: Icons.grid_on),
    MoveCategory(name: 'Burns', icon: Icons.fireplace),
    MoveCategory(name: 'Custom', icon: Icons.category),
  ];

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
              itemCount: _pages.length,
              itemBuilder: (context, index) {
                return _pages[index](_categories, _category, (category) {
                  setState(() {
                    _category = category;
                  });
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (_currentPage > 0)
                  ElevatedButton(
                    onPressed: () {
                      _pageController.previousPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: Text('Previous'),
                  ),
                if (_currentPage < _pages.length - 1)
                  ElevatedButton(
                    onPressed: () {
                      _pageController.nextPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: Text('Next'),
                  ),
                if (_currentPage == _pages.length - 1)
                  ElevatedButton(
                    onPressed: () {
                      // Save the move and navigate back
                      // Add your logic to save the move here
                      Navigator.pop(context);
                    },
                    child: Text('Save'),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChooseCategoryStep extends StatelessWidget {
  final List<MoveCategory> categories;
  final String selectedCategory;
  final ValueChanged<String> onChanged;

  ChooseCategoryStep({
    required this.categories,
    required this.selectedCategory,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return StepPage(
      title: 'Choose the category',
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 15, // Add spacing between categories
          mainAxisSpacing: 10,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final isSelected = categories[index].name == selectedCategory;

          return GestureDetector(
            onTap: () {
              onChanged(categories[index].name);
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: isSelected ? Colors.blue : Colors.grey,
                  width: 2, // Border width
                ),
                borderRadius: BorderRadius.circular(8), // Rounded corners
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    categories[index].icon,
                    color: isSelected ? Colors.blue : Colors.grey,
                    size: 48, // Increase the icon size
                  ),
                  SizedBox(height: 8),
                  Text(
                    categories[index].name,
                    style: TextStyle(
                      color: isSelected ? Colors.blue : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class StepPage extends StatelessWidget {
  final String title;
  final Widget child;

  StepPage({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 16),
          Expanded(child: child),
        ],
      ),
    );
  }
}

class MoveCategory {
  final String name;
  final IconData icon;

  MoveCategory({required this.name, required this.icon});
}
