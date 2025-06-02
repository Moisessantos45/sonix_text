import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sonix_text/config/show_notification.dart';
import 'package:sonix_text/domains/entity_grade.dart';
import 'package:sonix_text/infrastructure/note_links_model.dart';
import 'package:sonix_text/presentation/riverpod/riverpod.dart';

class NotesListWidget extends ConsumerStatefulWidget {
  final EntityGrade note;
  final String fromId;
  final double screenWidth;
  final double screenHeight;

  const NotesListWidget({
    super.key,
    required this.note,
    required this.fromId,
    required this.screenWidth,
    required this.screenHeight,
  });

  @override
  ConsumerState<NotesListWidget> createState() => _NotesListWidgetState();
}

class _NotesListWidgetState extends ConsumerState<NotesListWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: widget.screenHeight * 0.015),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(widget.screenWidth * 0.04),
        border: Border.all(
          color: const Color(0xFF3498DB).withAlpha(50),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3498DB).withAlpha(25),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(widget.screenWidth * 0.04),
          onTap: () => _showLinkConfirmation(widget.note),
          child: Padding(
            padding: EdgeInsets.all(widget.screenWidth * 0.04),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(widget.screenWidth * 0.02),
                      decoration: BoxDecoration(
                        color: Color(widget.note.color).withAlpha(50),
                        borderRadius:
                            BorderRadius.circular(widget.screenWidth * 0.02),
                      ),
                      child: Icon(
                        Icons.note,
                        color: Color(widget.note.color),
                        size: widget.screenWidth * 0.05,
                      ),
                    ),
                    SizedBox(width: widget.screenWidth * 0.03),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.note.title,
                            style: TextStyle(
                              fontSize: widget.screenWidth * 0.04,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF2C3E50),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: widget.screenHeight * 0.005),
                          Text(
                            widget.note.category,
                            style: TextStyle(
                              fontSize: widget.screenWidth * 0.03,
                              color: const Color(0xFF7F8C8D),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: widget.screenWidth * 0.025,
                        vertical: widget.screenHeight * 0.005,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(widget.note.status),
                        borderRadius:
                            BorderRadius.circular(widget.screenWidth * 0.02),
                      ),
                      child: Text(
                        widget.note.status,
                        style: TextStyle(
                          fontSize: widget.screenWidth * 0.025,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: widget.screenHeight * 0.015),
                Text(
                  widget.note.content,
                  style: TextStyle(
                    fontSize: widget.screenWidth * 0.035,
                    color: const Color(0xFF2C3E50),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: widget.screenHeight * 0.01),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: widget.screenWidth * 0.03,
                      color: const Color(0xFF7F8C8D),
                    ),
                    SizedBox(width: widget.screenWidth * 0.015),
                    Text(
                      widget.note.date,
                      style: TextStyle(
                        fontSize: widget.screenWidth * 0.03,
                        color: const Color(0xFF7F8C8D),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'Tocar para vincular',
                      style: TextStyle(
                        fontSize: widget.screenWidth * 0.03,
                        color: const Color(0xFF3498DB),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return const Color(0xFF27AE60);
      case 'in progress':
        return const Color(0xFFF39C12);
      case 'pending':
      default:
        return const Color(0xFFE74C3C);
    }
  }

  void _showLinkConfirmation(EntityGrade note) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        elevation: 30,
        surfaceTintColor: Colors.white,
        shadowColor: Colors.black.withAlpha(50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          'Confirmar Vinculación',
          style: TextStyle(
            color: Color(0xFF2C3E50),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '¿Deseas crear un vínculo entre estas notas?',
              style: TextStyle(color: Color(0xFF2C3E50)),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFECF0F1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text('Desde: ',
                          style: TextStyle(fontWeight: FontWeight.w600)),
                      Expanded(child: Text(note.title)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Text('Hacia: ',
                          style: TextStyle(fontWeight: FontWeight.w600)),
                      Expanded(child: Text(note.title)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => _createNoteLink(note),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3498DB),
            ),
            child: const Text(
              'Crear Vínculo',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _createNoteLink(EntityGrade note) async {
    try {
      final newLink = NoteLinksModel(
        id: DateTime.now().millisecondsSinceEpoch,
        fromId: widget.fromId,
        toId: note.id,
        createdAt: DateTime.now().toIso8601String(),
      );

      await ref.read(noteLinksNotifierProvider.notifier).addNoteLink(newLink);
      ref.read(unrelatedGradesProvider.notifier).setNoteId(widget.fromId);
      ref.read(relatedGradesProvider.notifier).setNoteId(widget.fromId);

      showNotification("Éxito", "Vínculo creado correctamente");
      Navigator.pop(context); // Cerrar el diálogo
    } catch (e) {
      showNotification("Error", "Error al crear el vínculo", error: true);
    }
  }
}
