import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sonix_text/presentation/riverpod/seletc_color.dart';
import 'package:sonix_text/presentation/utils/app_colors.dart';

class ColorPair {
  final int color;
  final int index;
  ColorPair(this.color, this.index);
}

class ColorSelector extends ConsumerStatefulWidget {
  final ValueChanged<ColorPair> onColorSelected;

  const ColorSelector({super.key, required this.onColorSelected});

  @override
  ConsumerState<ColorSelector> createState() => _ColorSelectorState();
}

class _ColorSelectorState extends ConsumerState<ColorSelector> {
  Widget _buildColorSelector(BuildContext context) {
    return InkWell(
      onTap: () => _showColorPicker(context),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFFD6EAF8).withAlpha(50),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Row(
          children: [
            const Icon(Icons.color_lens, size: 18, color: Colors.greenAccent),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Seleccionar color',
                style: TextStyle(
                    fontSize: 14, color: Color(ref.watch(selectColor))),
              ),
            ),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: Color(ref.watch(selectColor)),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey.shade400),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showColorPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Seleccionar color'),
          backgroundColor: Colors.white,
          elevation: 0,
          surfaceTintColor: Colors.white,
          shadowColor: Colors.white,
          content: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.5,
            ),
            child: SingleChildScrollView(
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: colorList.asMap().entries.map((entry) {
                  final index = entry.key;
                  final colorValue = entry.value;
                  final color = Color(colorValue);
                  final newColor = ColorPair(colorValue, index);
                  return GestureDetector(
                    onTap: () {
                      widget.onColorSelected(newColor);
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: Color(ref.watch(selectColor)) == color
                            ? Border.all(color: Colors.blueAccent, width: 3)
                            : null,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildColorSelector(context);
  }
}
