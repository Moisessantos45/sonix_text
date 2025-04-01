bool isValidString(String cadena) {
  final String trimmed = cadena.trim();

  final RegExp regex = RegExp(
      r'^[a-zA-Z0-9áéíóúüÁÉÍÓÚÜñÑ.,?!¿¡:;_\-]+( [a-zA-Z0-9áéíóúüÁÉÍÓÚÜñÑ.,?!¿¡:;_\-]+)*$');

  return trimmed.isNotEmpty &&
      trimmed.trim() == trimmed &&
      regex.hasMatch(trimmed);
}
