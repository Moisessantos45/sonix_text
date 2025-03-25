import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sonix_text/config/show_notification.dart';
import 'package:sonix_text/domains/entity_grade.dart';
import 'package:sonix_text/presentation/riverpod/repository_grade.dart';
import 'package:sonix_text/presentation/screens/voicce_text.dart';

class GradeItemWidget extends ConsumerWidget {
  final EntityGrade grade;
  const GradeItemWidget({super.key, required this.grade});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Expanded(
              flex: 6,
              child: Text(
                grade.title,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            IconButton(
                icon: const Icon(Icons.delete, color: Colors.redAccent),
                onPressed: () {
                  removeGrade(ref, grade.id);
                }),
            IconButton(
                icon: const Icon(Icons.edit, color: Colors.amber),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VoiceTextScreen(
                        id: grade.id,
                      ),
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }

  Future<void> removeGrade(ref, String id) async {
    try {
      final task =
          ref.read(gradeNotifierProvider).firstWhere((t) => t.id == id);
      await ref.read(gradeNotifierProvider.notifier).removeTask(task);
      showNotification("Success", "Note deleted successfully");
    } catch (e) {
      showNotification("Error", "Error deleting note", error: true);
    }
  }
}
