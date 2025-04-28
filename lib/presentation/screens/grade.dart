import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sonix_text/config/helper/page_router.dart';
import 'package:sonix_text/presentation/riverpod/repository_grade.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:sonix_text/presentation/screens/voicce_text.dart';
import 'package:sonix_text/presentation/widgets/navigation_bar.dart';

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

  String subStringContent(String content) {
    if (content.length > 50) {
      return '${content.substring(0, 50)}...';
    } else {
      return content;
    }
  }

  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final grades = ref.watch(gradesFilterDateProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFD6EAF8).withAlpha(50),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
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
        child: Column(
          children: [
            CalendarTimeline(
              initialDate: selectedDate,
              firstDate: DateTime.now().subtract(const Duration(days: 30)),
              lastDate: DateTime.now().add(const Duration(days: 365 * 10)),
              onDateSelected: (date) {
                setState(() {
                  selectedDate = date;
                });
                ref
                    .watch(gradeFilterDateNotifierProvider.notifier)
                    .setDate(date);
              },
              leftMargin: 20,
              monthColor: Colors.blueGrey,
              dayColor: Colors.teal[200],
              activeDayColor: Colors.white,
              activeBackgroundDayColor: Colors.redAccent[100],
              locale: 'en_ISO',
            ),
            const SizedBox(height: 15),
            grades.isEmpty
                ? const Center(
                    child: Text(
                      'No hay notas para mostrar',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : Expanded(
                    child: MasonryGridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 8.0,
                    crossAxisSpacing: 8.0,
                    itemCount: grades.length,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      final grade = grades[index];
                      final backgroundColor = Color(grade.color);
                      final luminosity = calculateLuminosity(backgroundColor);
                      final textColor =
                          luminosity > 0.5 ? Colors.black87 : Colors.white;

                      final content = subStringContent(grade.content);
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
                              content,
                              style: TextStyle(fontSize: 14, color: textColor),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 5,
                            ),
                          ],
                        ),
                      );
                    },
                  ))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF3498DB),
        onPressed: () {
          Navigator.push(
            context,
            CustomPageRoute(page: const VoiceTextScreen()),
          );
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 32,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: CustomNavigation(),
    );
  }
}
