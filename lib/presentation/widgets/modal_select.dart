import 'package:flutter/material.dart';

class SelectionModal extends StatelessWidget {
  final String title;
  final List<String> items;
  final String? selectedItem;
  final ValueChanged<String> onItemSelected;
  final Color? accentColor;
  final Color? textColor;

  const SelectionModal({
    super.key,
    required this.items,
    required this.onItemSelected,
    this.title = 'Selecciona una opción',
    this.selectedItem,
    this.accentColor,
    this.textColor,
  });

  static Future<void> show({
    required BuildContext context,
    required List<String> items,
    required ValueChanged<String> onItemSelected,
    String title = 'Selecciona una opción',
    String? selectedItem,
    Color? accentColor,
    Color? textColor,
    Color? backgroundColor,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return showDialog(
      context: context,
      builder: (context) => SelectionModal(
        items: items,
        onItemSelected: onItemSelected,
        title: title,
        selectedItem: selectedItem,
        accentColor:
            accentColor ?? (isDark ? Colors.greenAccent : Color(0XFF2C3E50)),
        textColor: textColor ?? (isDark ? Colors.white : Colors.black87),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Color(0xFFD6EAF8),
      title: Text(
        title,
        style: TextStyle(color: accentColor,fontWeight: FontWeight.bold),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: items
            .map(
              (item) => ListTile(
                title: Text(
                  item,
                  style: TextStyle(color: Color(0xff2C80B4),
                      fontWeight: FontWeight.w500),
                ),
                onTap: () {
                  onItemSelected(item);
                  Navigator.pop(context);
                },
                trailing: item == selectedItem
                    ? Icon(Icons.check, color: Color(0xFF5DADE2))
                    : null,
              ),
            )
            .toList(),
      ),
    );
  }
}
