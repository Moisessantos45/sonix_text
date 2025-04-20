import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sonix_text/presentation/riverpod/seletc_color.dart';

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
  final List<int> colorList = [
    0xFF4fc3f7, // azul claro
    0xFFa7ffeb, // verde menta claro
    0xFF00e676, // verde brillante
    0xFF81d4fa, // azul cielo claro
    0xFFb2fef7, // celeste muy suave
    0xFF1de9b6, // verde aqua
    0xFF64ffda, // turquesa claro
    0xFF00bfa5, // verde azulado
    0xFF69f0ae, // verde primavera
    0xFF18ffff, // cian brillante
    0xFF40c4ff, // azul vibrante
    0xFF80d8ff, // azul muy claro
    0xFFb9f6ca, // verde pastel
    0xFF00e5ff, // cian intenso
    0xFF76ff03, // verde lima neón
    0xFFf06292, // rosa suave vibrante
    0xFFffd54f, // amarillo suave y brillante
    0xFFba68c8, // morado claro
    0xFFff8a65, // naranja suave
    0xFFf44336, // rojo vibrante
    0xFFffeb3b, // amarillo neón
    0xFFe57373, // rojo coral
    0xFFce93d8, // lavanda claro
    0xFFff5252, // rojo neón
  ];

  Widget _buildColorSelector(BuildContext context) {
    return InkWell(
      onTap: () => _showColorPicker(context),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
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
          content: SingleChildScrollView(
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
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildColorSelector(context);
  }
}
