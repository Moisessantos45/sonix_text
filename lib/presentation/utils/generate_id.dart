import 'dart:math';

int generateUniqueId() {
  final random = Random.secure();
  // Aseguramos un número positivo de 31 bits (el bit 32 es para el signo)
  return (DateTime.now().millisecondsSinceEpoch ^ random.nextInt(1 << 31))
          .abs() %
      (1 << 31);
}
