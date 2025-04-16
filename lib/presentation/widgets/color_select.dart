import 'package:flutter/material.dart';

class ColorSelector extends StatefulWidget {
  final ValueChanged<int> onColorSelected;

  const ColorSelector({super.key, required this.onColorSelected});

  @override
  State<ColorSelector> createState() => _ColorSelectorState();
}

class _ColorSelectorState extends State<ColorSelector> {
  Color? _selectedColor;

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
                  fontSize: 14,
                  color: _selectedColor != null
                      ? Colors.black
                      : const Color(0xFF2C3E50),
                ),
              ),
            ),
            if (_selectedColor != null)
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: _selectedColor,
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
          content: SingleChildScrollView(
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: colorList.map((colorValue) {
                final color = Color(colorValue);
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedColor = color;
                    });
                    widget.onColorSelected(colorValue);
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: _selectedColor == color
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
