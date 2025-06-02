import 'package:flutter/material.dart';
import 'package:sonix_text/domains/entity_grade.dart';
import 'package:sonix_text/presentation/widgets/widgets.dart';

class ResultsListWidget extends StatelessWidget {
  final List<EntityGrade> notes;
  final double screenWidth;
  final double screenHeight;
  final String fromId;
  final String searchQuery;
  final VoidCallback clearSearchAction;

  const ResultsListWidget({
    super.key,
    required this.notes,
    required this.screenWidth,
    required this.screenHeight,
    required this.fromId,
    required this.searchQuery,
    required this.clearSearchAction,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Results Header
        Padding(
          padding: EdgeInsets.all(screenWidth * 0.04),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Notas disponibles (${notes.length})',
                style: TextStyle(
                  fontSize: screenWidth * 0.04,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF2C3E50),
                ),
              ),
              if (searchQuery.isNotEmpty)
                TextButton(
                  onPressed: clearSearchAction,
                  child: Text(
                    'Limpiar filtro',
                    style: TextStyle(
                      color: const Color(0xFF3498DB),
                      fontSize: screenWidth * 0.035,
                    ),
                  ),
                ),
            ],
          ),
        ),

        // Results List
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
            physics: const BouncingScrollPhysics(),
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final note = notes[index];
              return _buildNoteCard(note, screenWidth, screenHeight);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildNoteCard(
      EntityGrade note, double screenWidth, double screenHeight) {
    if (note.id == fromId) {
      return const SizedBox.shrink();
    }

    return NotesListWidget(
      fromId: fromId,
      note: note,
      screenWidth: screenWidth,
      screenHeight: screenHeight,
    );
  }
}
