import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sonix_text/config/helper/page_router.dart';
import 'package:sonix_text/config/show_notification.dart';
import 'package:sonix_text/domains/entity_grade.dart';
import 'package:sonix_text/presentation/riverpod/repository_grade.dart';
import 'package:sonix_text/presentation/screens/voicce_text.dart';
import 'package:sonix_text/presentation/utils/options.dart';
import 'package:uuid/uuid.dart';

class GradeItemWidget extends ConsumerWidget {
  final EntityGrade grade;
  const GradeItemWidget({super.key, required this.grade});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int indexColor = statusOptions.indexOf(grade.status);
    final int color = statusColors[indexColor];
    return Slidable(
        key: Key(Uuid().v4()),
        startActionPane: ActionPane(
            motion: const ScrollMotion(),
            dismissible: DismissiblePane(
              onDismissed: () {
                Navigator.push(
                  context,
                  CustomPageRoute(page: VoiceTextScreen(id: grade.id)),
                );
              },
            ),
            children: [
              SlidableAction(
                onPressed: (BuildContext context) {
                  Navigator.push(
                    context,
                    CustomPageRoute(page: VoiceTextScreen(id: grade.id)),
                  );
                },
                backgroundColor: Color.fromARGB(255, 0, 176, 246),
                foregroundColor: Colors.white,
                icon: Icons.edit,
                label: 'Edit',
              ),
            ]),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          dismissible: DismissiblePane(
            onDismissed: () {
              removeGrade(grade.id, ref);
            },
          ),
          children: [
            SlidableAction(
              onPressed: (BuildContext context) {
                removeGrade(grade.id, ref);
              },
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
            ),
          ],
        ),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 9),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withAlpha(50),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                  grade.content,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF7F8C8D),
                  ),
                ),
              ),
              trailing: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                    color: Color(color),
                    borderRadius: BorderRadius.circular(12)),
                child: Text(
                  grade.status,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ));
  }

  Future<void> removeGrade(String id, WidgetRef ref) async {
    final grade = ref
        .read(gradeNotifierProvider)
        .firstWhere((element) => element.id == id);
    await ref.read(allGradesProvider.notifier).removeGrade(grade);
    showNotification("Delete", "Item deleted");
  }
}
