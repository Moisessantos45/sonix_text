import 'package:flutter/material.dart';

class EmptyStateIndicator extends StatelessWidget {
  final String searchQuery;
  final double screenWidth;
  final double screenHeight;
  const EmptyStateIndicator(
      {super.key, required this.screenWidth, required this.screenHeight, required this.searchQuery});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            searchQuery.isEmpty ? Icons.note_outlined : Icons.search_off,
            size: screenWidth * 0.2,
            color: const Color(0xFF7F8C8D),
          ),
          SizedBox(height: screenHeight * 0.02),
          Text(
            searchQuery.isEmpty
               ? 'No hay notas disponibles'
                : 'No se encontraron resultados',
            style: TextStyle(
              fontSize: screenWidth * 0.045,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF7F8C8D),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: screenHeight * 0.01),
          Text(
            searchQuery.isEmpty
                ? 'Las notas aparecerán aquí cuando las agregues'
                : 'Intenta con otros términos de búsqueda',
            style: TextStyle(
              fontSize: screenWidth * 0.035,
              color: const Color(0xFF95A5A6),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
