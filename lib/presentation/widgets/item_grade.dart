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
    final Size screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;
    final double screenHeight = screenSize.height;

    final int indexColor = statusOptions.indexOf(grade.status);
    final int color = statusColors[indexColor];

    return Dismissible(
      key: Key(grade.id),
      direction: DismissDirection.horizontal,
      background: Padding(
        padding: EdgeInsets.all(screenWidth * 0.02),
        child: Container(
          color: Colors.blue,
          child: Icon(Icons.edit, color: Colors.white, size: screenWidth * 0.1),
        ),
      ),
      secondaryBackground: Padding(
        padding: EdgeInsets.all(screenWidth * 0.02),
        child: Container(
          color: Colors.red,
          child:
              Icon(Icons.delete, color: Colors.white, size: screenWidth * 0.1),
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
        margin: EdgeInsets.symmetric(vertical: screenHeight * 0.008),
        decoration: BoxDecoration(
          color: Colors.white60,
          borderRadius: BorderRadius.circular(screenWidth * 0.04),
          border:
              Border.all(color: Color(0xFF4DADE2), width: screenWidth * 0.001),
          boxShadow: [
            BoxShadow(
              color: Color(0xFF4DADE2).withAlpha(50),
              blurRadius: screenWidth * 0.025,
              offset: Offset(0, screenHeight * 0.005),
            ),
          ],
        ),
        child: InkWell(
            onTap: () {
              _showPeriodSelector(context, ref);
            },
            child: Material(
              color: Colors.transparent,
              child: ListTile(
                contentPadding: EdgeInsets.all(screenWidth * 0.02),
                title: Text(
                  grade.title,
                  style: TextStyle(
                    fontSize: screenWidth * 0.04,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2C3E50),
                  ),
                ),
                subtitle: Padding(
                  padding: EdgeInsets.only(top: screenHeight * 0.006),
                  child: Text(
                    grade.content,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: screenWidth * 0.035,
                      color: Color(0xFF7F8C8D),
                    ),
                  ),
                ),
                trailing: Container(
                    constraints: BoxConstraints(maxWidth: screenWidth * 0.4),
                    padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.025,
                        vertical: screenHeight * 0.01),
                    decoration: BoxDecoration(
                        color: Color(color),
                        borderRadius:
                            BorderRadius.circular(screenWidth * 0.03)),
                    child: Row(
                      children: [
                        Text(
                          grade.status,
                          style: TextStyle(
                            fontSize: screenWidth * 0.035,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Spacer(),
                        Icon(Icons.edit,
                            color: Colors.white, size: screenWidth * 0.06),
                      ],
                    )),
              ),
            )),
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
    await ref.read(allGradesProvider.notifier).updateGradeStatus(id, status);

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
