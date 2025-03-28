import 'package:flutter/material.dart';

class CategoryListWidget extends StatelessWidget {
  final List<String> categories;
  final bool isHiddenIcon;
  final Function(String)? onCategory;

  const CategoryListWidget({
    super.key,
    required this.categories,
    this.onCategory,
    this.isHiddenIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 12,
      children: [
        ...categories.map((category) => FilterChip(
              label: Text(category),
              onSelected: (selected) {
                if (onCategory != null) {
                  onCategory!(category);
                }
              },
              backgroundColor: Colors.white,
              selectedColor: const Color(0xFF3498DB).withAlpha(15),
              checkmarkColor: const Color(0xFF3498DB),
              deleteIcon: isHiddenIcon
                  ? null
                  : const Icon(Icons.close, color: Color(0xFF3498DB), size: 20),
              labelStyle: TextStyle(
                color: categories.contains(category)
                    ? const Color(0xFF3498DB)
                    : const Color(0xFF2C3E50),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            )),
      ],
    );
  }
}
