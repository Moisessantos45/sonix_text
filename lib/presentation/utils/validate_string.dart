bool isValidString(String cadena) {
  final RegExp regex = RegExp(r'^[a-zA-Z0-9]+( [a-zA-Z0-9]+)*$');

  return cadena.isNotEmpty && cadena.trim() == cadena && regex.hasMatch(cadena);
}
