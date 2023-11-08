import 'package:flutter/material.dart';

class CategoryStep extends StatelessWidget {
  final List<MoveCategory> categories;
  final String selectedCategory;
  final ValueChanged<String> onChanged;

  const CategoryStep({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final gridItemWidth = screenWidth / 2;

    double aspectRatio = screenHeight / screenWidth;
    return StepPage(
      title: 'Choose the category',
      child: GridView.builder(
        primary: false,
        padding: const EdgeInsets.all(20),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 10,
            childAspectRatio: (1.5)),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final isSelected = categories[index].name == selectedCategory;
          return GestureDetector(
            onTap: () {
              onChanged(categories[index].name);
            },
            child: Container(
              height: gridItemWidth *
                  aspectRatio, // Adjust height based on aspect ratio
              width: gridItemWidth,
              decoration: BoxDecoration(
                border: Border.all(
                  color: isSelected ? Colors.white : Colors.grey,
                  width: 2, // Border width
                ),
                borderRadius: BorderRadius.circular(8), // Rounded corners
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ImageIcon(
                    AssetImage(categories[index].path),
                    color: isSelected ? Colors.white : Colors.grey,
                    size: 48, // Increase the icon size
                  ),
                  const SizedBox(height: 8),
                  Text(
                    categories[index].name,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.grey,
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

  const StepPage({super.key, required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Expanded(child: child),
        ],
      ),
    );
  }
}

class MoveCategory {
  final String name;
  final String path;

  MoveCategory({required this.name, required this.path});
}
