import 'package:sonix_text/domains/entity_grade.dart';

List<EntityGrade> filterNotesDueSoon(List<EntityGrade> notes) {
  final today = DateTime.now();

  final List<EntityGrade> notesAboutToExpire = [];

  for (final note in notes) {
    final noteDueDate = parseDate(note.dueDate);
    if (noteDueDate == null) {
      continue;
    }
    if (note.status != "Completed" &&
        noteDueDate.isAfter(today.subtract(const Duration(days: 1)))) {
      final daysDifference = noteDueDate.difference(today).inDays;

      if (daysDifference >= 0 && daysDifference <= 4) {
        notesAboutToExpire.add(note);
      }
    }
  }

  return notesAboutToExpire;
}

DateTime? parseDate(String date) {
  List<String> parts = date.split('/');
  if (parts.length != 3) {
    return null;
  }

  int day = int.parse(parts[0]);
  int month = int.parse(parts[1]);
  int year = int.parse(parts[2]);

  return DateTime(year, month, day);
}

final currentDate = formatDateTimeToString(DateTime.now());

String formatDateTimeToString(DateTime date) {
  return "${date.day}/${date.month}/${date.year}";
}
