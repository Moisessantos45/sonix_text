bool isValidString(String cadena) {
  final RegExp regex =
      RegExp(r'^[a-zA-Z0-9áéíóúüÁÉÍÓÚÜñÑ]+( [a-zA-Z0-9áéíóúüÁÉÍÓÚÜñÑ]+)*$');

  return cadena.isNotEmpty && cadena.trim() == cadena && regex.hasMatch(cadena);
}
