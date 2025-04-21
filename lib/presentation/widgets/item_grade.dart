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
          color: Colors.white60,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Color(0xFF4DADE2),width: 0.4),
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
              constraints: BoxConstraints(maxWidth: 180),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                  color: Color(color), borderRadius: BorderRadius.circular(12)),
              child: _buildDropdownField(
                icon: Icons.flag_outlined,
                hint: 'Estado',
                value: grade.status,
                items: statusOptions,
                color: color,
                onChanged: (value) {
                  if (value != null) {
                    changeStatus(grade.id, value, ref);
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required IconData icon,
    required String hint,
    required String value,
    required List<String> items,
    required int color,
    required void Function(String?) onChanged,
  }) {
    final uniqueItems = items.toSet().toList();
    final validValue =
        uniqueItems.contains(value) ? value : uniqueItems.firstOrNull;

    return Container(
      decoration: BoxDecoration(
        color: Color(color),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Color(color)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.white),
          const SizedBox(width: 8),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                  value: validValue,
                  isDense: true,
                  isExpanded: true,
                  icon: const Icon(Icons.arrow_drop_down,
                      color: Colors.white),
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                  onChanged: onChanged,
                  dropdownColor: Colors.white,
                  focusColor: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  items: uniqueItems.map((String item) {
                    return DropdownMenuItem<String>(
                      value: item,
                      child: Text(
                        item,
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(color),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList(),
                  hint: Text(hint,
                      style: const TextStyle(
                        color: Colors.white,
                      )),
                  selectedItemBuilder: (BuildContext context) {
                    return uniqueItems.map<Widget>((String item) {
                      return Text(
                        item,
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      );
                    }).toList();
                  }),
            ),
          ),
        ],
      ),
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
