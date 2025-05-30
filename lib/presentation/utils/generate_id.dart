  import 'dart:math';

int generateUniqueId() {
    final now = DateTime.now();
    final random = Random.secure();
    return now.microsecondsSinceEpoch ^ random.nextInt(1 << 32);
  }