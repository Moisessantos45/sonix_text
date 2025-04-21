import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sonix_text/presentation/riverpod/repository_grade.dart';
import 'package:sonix_text/presentation/utils/parse_date.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final grades = ref.watch(allGradesProvider);
    final dueSoonGrades = filterNotesDueSoon(grades);
    return Scaffold(
      backgroundColor: const Color(0xFFD6EAF8).withAlpha(50),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
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
                final daysUntilDue = parseDate(grade.dueDate)
                        ?.difference(DateTime.now())
                        .inDays ??
                    0;
                return Container(
                  height: 105,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white60,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Color(0xFF4DADE2), width: 0.4),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF4DADE2).withAlpha(50),
                        blurRadius: 10,
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
                          color: const Color(0xFF5DADE2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.notifications_outlined,
                          color: Colors.white,
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
                        color: Color(0xFF5DADE2),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  Color _getUrgencyColor(int days) {
    return days == 0
        ? Color(0XFFE74C3C)
        : days <= 2
            ? Color(0XFFF1C40F)
            : Colors.blue;
  }
}
