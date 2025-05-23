import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sonix_text/config/helper/page_router.dart';
import 'package:sonix_text/config/show_notification.dart';
import 'package:sonix_text/domains/entity_grade.dart';
import 'package:sonix_text/presentation/riverpod/repository_grade.dart';
import 'package:sonix_text/presentation/screens/voicce_text.dart';
import 'package:sonix_text/presentation/utils/options.dart';
import 'package:sonix_text/presentation/widgets/modal_select.dart';

class GradeItemWidget extends ConsumerWidget {
  final EntityGrade grade;
  const GradeItemWidget({super.key, required this.grade});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int indexColor = statusOptions.indexOf(grade.status);
    final int color = statusColors[indexColor];
    return Dismissible(
      key: Key(grade.id),
      direction: DismissDirection.horizontal,
      background: Padding(
        padding: const EdgeInsets.all(8),
        child: Container(
          color: Colors.blue,
          child: Icon(Icons.edit, color: Colors.white, size: 40),
        ),
      ),
      secondaryBackground: Padding(
        padding: const EdgeInsets.all(8),
        child: Container(
          color: Colors.red,
          child: Icon(Icons.delete, color: Colors.white, size: 40),
        ),
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          final confirm = await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              backgroundColor: Colors.white,
              elevation: 30,
              surfaceTintColor: Colors.white,
              shadowColor: Colors.black.withAlpha(50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Text("Confirmar eliminación"),
              content: Text("¿Estás seguro de eliminar este elemento?"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text("Cancelar"),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text("Eliminar", style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
          );
          return confirm;
        } else {
          Navigator.push(
            context,
            CustomPageRoute(page: VoiceTextScreen(id: grade.id)),
          );
          return false;
        }
      },
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          removeGrade(grade.id, ref);
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 9),
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
            contentPadding: const EdgeInsets.all(8),
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
                constraints: BoxConstraints(maxWidth: 180),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                    color: Color(color),
                    borderRadius: BorderRadius.circular(12)),
                child: Row(
                  children: [
                    Text(grade.status,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        )),
                    const Spacer(),
                    IconButton(
                      onPressed: grade.status != "Completed"
                          ? () {
                              _showPeriodSelector(context, ref);
                            }
                          : null,
                      icon:
                          const Icon(Icons.edit, color: Colors.white, size: 25),
                      tooltip: 'Cambiar estatus',
                    ),
                  ],
                )),
          ),
        ),
      ),
    );
  }

  void _showPeriodSelector(context, ref) {
    SelectionModal.show(
      context: context,
      items: statusOptions,
      title: 'Selecciona el estatus',
      selectedItem: grade.status,
      onItemSelected: (value) {
        changeStatus(grade.id, value, ref);
      },
    );
  }

  Future<void> changeStatus(String id, String status, WidgetRef ref) async {
    final grade = ref
        .read(gradeNotifierProvider)
        .firstWhere((element) => element.id == id);

    await ref.read(allGradesProvider.notifier).updateGrade(grade.copyWith(
          status: status,
        ));

    showNotification("Actualizado", "Estado actualizado");
  }

  Future<void> removeGrade(String id, WidgetRef ref) async {
    final grade = ref
        .read(gradeNotifierProvider)
        .firstWhere((element) => element.id == id);
    await ref.read(allGradesProvider.notifier).removeGrade(grade);

    showNotification("Eliminado", "Nota eliminada");
  }
}
