import 'package:flutter/material.dart';
import 'package:sonix_text/domains/entity_grade.dart';

class RelatedNotesWidget extends StatelessWidget {
  final List<EntityGrade> notes;
  final double screenWidth;
  final double screenHeight;

  const RelatedNotesWidget({
    super.key,
    required this.notes,
    required this.screenWidth,
    required this.screenHeight,
  });

  @override
  Widget build(BuildContext context) {
    if (notes.isEmpty) {
      return Center(
        child: Text(
          'No hay notas relacionadas',
          style: TextStyle(
            fontSize: screenWidth * 0.045,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF7F8C8D),
          ),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.04, vertical: screenHeight * 0.02),
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes[index];
        return Column(
          children: [
            Row(
              children: [
                Container(
                  width: screenWidth * 0.02,
                  height: screenHeight * 0.1,
                  color: const Color(0xFF3498DB),
                ),
                SizedBox(width: screenWidth * 0.04),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(screenWidth * 0.04),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(screenWidth * 0.04),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(25),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          note.title,
                          style: TextStyle(
                            fontSize: screenWidth * 0.04,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF2C3E50),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.005),
                        Text(
                          note.content,
                          style: TextStyle(
                            fontSize: screenWidth * 0.035,
                            color: const Color(0xFF7F8C8D),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            if (index < notes.length - 1)
              Container(
                width: screenWidth * 0.02,
                height: screenHeight * 0.05,
                color: const Color(0xFF3498DB),
              ),
          ],
        );
      },
    );
  }
}
