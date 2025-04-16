import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = contentColorCyan;
  static const Color menuBackground = Color(0xFF090912);
  static const Color itemsBackground = Color(0xFF1B2339);
  static const Color pageBackground = Color(0xFF282E45);
  static const Color mainTextColor1 = Colors.white;
  static const Color mainTextColor2 = Colors.white70;
  static const Color mainTextColor3 = Colors.white38;
  static const Color mainGridLineColor = Colors.white10;
  static const Color borderColor = Colors.white54;
  static const Color gridLinesColor = Color(0x11FFFFFF);

  static const Color contentColorBlack = Colors.black;
  static const Color contentColorWhite = Colors.white;
  static const Color contentColorBlue = Color(0xFF2196F3);
  static const Color contentColorYellow = Color(0xFFFFC300);
  static const Color contentColorOrange = Color(0xFFFF683B);
  static const Color contentColorGreen = Color(0xFF3BFF49);
  static const Color contentColorPurple = Color(0xFF6E1BFF);
  static const Color contentColorPink = Color(0xFFFF3AF2);
  static const Color contentColorRed = Color(0xFFE80054);
  static const Color contentColorCyan = Color(0xFF50E4FF);
}

extension ColorExtension on Color {
  Color darken([int percent = 40]) {
    assert(1 <= percent && percent <= 100);
    final value = 1 - percent / 100;
    return Color.fromARGB(
      _floatToInt8(a),
      (_floatToInt8(r) * value).round(),
      (_floatToInt8(g) * value).round(),
      (_floatToInt8(b) * value).round(),
    );
  }

  Color lighten([int percent = 40]) {
    assert(1 <= percent && percent <= 100);
    final value = percent / 100;
    return Color.fromARGB(
      _floatToInt8(a),
      (_floatToInt8(r) + ((255 - _floatToInt8(r)) * value)).round(),
      (_floatToInt8(g) + ((255 - _floatToInt8(g)) * value)).round(),
      (_floatToInt8(b) + ((255 - _floatToInt8(b)) * value)).round(),
    );
  }

  Color avg(Color other) {
    final red = (_floatToInt8(r) + _floatToInt8(other.r)) ~/ 2;
    final green = (_floatToInt8(g) + _floatToInt8(other.g)) ~/ 2;
    final blue = (_floatToInt8(b) + _floatToInt8(other.b)) ~/ 2;
    final alpha = (_floatToInt8(a) + _floatToInt8(other.a)) ~/ 2;
    return Color.fromARGB(alpha, red, green, blue);
  }

  int _floatToInt8(double x) {
    return (x * 255.0).round() & 0xff;
  }
}

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
