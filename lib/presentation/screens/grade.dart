import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sonix_text/presentation/riverpod/repository_grade.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class GradeScreen extends ConsumerStatefulWidget {
  const GradeScreen({super.key});

  @override
  ConsumerState<GradeScreen> createState() => _GradeScreenState();
}

class _GradeScreenState extends ConsumerState<GradeScreen> {
  double calculateLuminosity(Color color) {
    final double r = color.r / 255.0;
    final double g = color.g / 255.0;
    final double b = color.b / 255.0;

    return 0.2126 * r + 0.7152 * g + 0.0722 * b;
  }

  @override
  Widget build(BuildContext context) {
    final grades = ref.watch(allGradesProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        title: const Text('Notas',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            )),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: MasonryGridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 8.0,
          crossAxisSpacing: 8.0,
          itemCount: grades.length,
          itemBuilder: (context, index) {
            final grade = grades[index];
            final backgroundColor = Color(grade.color);
            final luminosity = calculateLuminosity(backgroundColor);
            final textColor = luminosity > 0.5 ? Colors.black87 : Colors.white;
            return Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    grade.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    grade.date,
                    style: TextStyle(
                      fontSize: 14,
                      color: textColor.withAlpha(700),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    grade.content,
                    style: TextStyle(fontSize: 14, color: textColor),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 5,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
