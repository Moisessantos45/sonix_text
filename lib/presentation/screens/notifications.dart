import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sonix_text/domains/entity_grade.dart';
import 'package:sonix_text/presentation/riverpod/repository_grade.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final grades = ref.watch(allGradesProvider);
    final dueSoonGrades = filterNotesDueSoon(grades);
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: const Text('Mis Notificaciones',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C3E50),
              fontSize: 24,
              letterSpacing: 0.5,
            )),
        centerTitle: true,
      ),
      body: dueSoonGrades.isEmpty
          ? const Center(
              child: Text('No hay notificaciones pendientes',
                  style: TextStyle(
                    color: Color(0xFF7F8C8D),
                    fontSize: 16,
                  )))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: dueSoonGrades.length,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                final grade = dueSoonGrades[index];
                final daysUntilDue =
                    _parseDate(grade.dueDate).difference(DateTime.now()).inDays;
                return Container(
                  height: 105,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(20),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      leading: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: const Color(0xFF3498DB).withAlpha(30),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.notifications_outlined,
                          color: Color(0xFF3498DB),
                        ),
                      ),
                      title: Text(
                        grade.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2C3E50),
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          "Fecha de entrega: ${grade.dueDate}",
                          style: TextStyle(
                            fontSize: 14,
                            color: _getUrgencyColor(daysUntilDue),
                          ),
                        ),
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Color(0xFF95A5A6),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  List<EntityGrade> filterNotesDueSoon(List<EntityGrade> notes) {
    final today = DateTime.now();

    final List<EntityGrade> notesAboutToExpire = [];

    for (final note in notes) {
      final noteDueDate = _parseDate(note.dueDate);
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

  DateTime _parseDate(String dateStr) {
    final parts = dateStr.split('/');
    if (parts.length != 3) {
      throw FormatException('Invalid date format: $dateStr');
    }

    return DateTime(
      int.parse(parts[2]),
      int.parse(parts[1]),
      int.parse(parts[0]),
    );
  }

  Color _getUrgencyColor(int days) {
    return days == 0
        ? Colors.red
        : days <= 2
            ? Colors.orange
            : Colors.blue;
  }
}
