import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sonix_text/presentation/utils/parse_date.dart';

final initialDateProvider = StateProvider<DateTime>(
    (ref) => DateTime.now().add(const Duration(days: 1)));

final selectDateProvider = StateProvider<String>((ref) => currentDate);
