import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddCategoryDialog extends StatelessWidget {
  final Function(String) onAddCategory;
  final String title;
  final String hintText;
  final String cancelText;
  final String addText;
  final bool isNumber;

  const AddCategoryDialog({
    super.key,
    required this.onAddCategory,
    this.title = 'Nueva Categoría',
    this.hintText = 'Nombre de la categoría',
    this.cancelText = 'Cancelar',
    this.addText = 'Agregar',
    this.isNumber = false,
  });

  static Future<void> show({
    required BuildContext context,
    required Function(String) onAddCategory,
    String title = 'Nueva Categoría',
    String hintText = 'Nombre de la categoría',
    String cancelText = 'Cancelar',
    String addText = 'Agregar',
  }) async {
    return showDialog(
      context: context,
      barrierColor: Colors.black.withAlpha(50),
      barrierDismissible: true,
      builder: (context) => AddCategoryDialog(
        onAddCategory: onAddCategory,
        title: title,
        hintText: hintText,
        cancelText: cancelText,
        addText: addText,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController categoryController = TextEditingController();

    return AlertDialog(
      backgroundColor: Colors.white,
      elevation: 30,
      surfaceTintColor: Colors.white,
      shadowColor: Colors.black.withAlpha(50),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Text(title),
      content: TextField(
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        controller: categoryController,
        decoration: InputDecoration(
          hintText: hintText,
        ),
        inputFormatters: isNumber
            ? [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(2)
              ]
            : null,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(cancelText),
        ),
        TextButton(
          onPressed: () {
            if (isNumber && categoryController.text.isEmpty) {
              onAddCategory("1");
              Navigator.pop(context);
            } else {
              if (categoryController.text.isNotEmpty) {
                onAddCategory(categoryController.text);
                Navigator.pop(context);
              }
            }
          },
          child: Text(addText),
        ),
      ],
    );
  }
}
