import 'package:flutter/material.dart';
import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:sonix_text/config/service/notifications.dart';
import 'package:sonix_text/presentation/riverpod/riverpod.dart';
import 'package:sonix_text/presentation/utils/utils.dart';
import 'package:sonix_text/presentation/widgets/navigation_bar.dart';

class GradeScreen extends ConsumerStatefulWidget {
  const GradeScreen({super.key});

  @override
  ConsumerState<GradeScreen> createState() => _GradeScreenState();
}

class _GradeScreenState extends ConsumerState<GradeScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoading = true;

  Future<void> _scheduleNotifications() async {
    try {
      final user = ref.read(userProvider);
      if (user.isEmpty || user.first.activeNotifications == false) {
        return;
      }

      final updatedUser = user.first;

      final hora = updatedUser.hora;

      final dueSoonGrades = filterNotesDueSoon(ref.read(allGradesProvider));
      if (dueSoonGrades.isEmpty) return;
      await NotificationsService.cancelAll();

      for (final grade in dueSoonGrades) {
        DateTime fecha = parseDate(grade.dueDate) ?? DateTime.now();

        DateTime fechaConHora =
            DateTime(fecha.year, fecha.month, fecha.day, hora, 1);

        final notificationId = generateUniqueId();

        await NotificationsService.hideNotificationSchedule(
          notificationId,
          "La nota ${grade.title}",
          'La nota ${grade.title} se vence en ${grade.dueDate}',
          fechaConHora,
        );
      }
    } catch (e) {
      await NotificationsService.cancelAll();
    }
  }

  Future<void> _loadData() async {
    await ref.read(loadDataProvider.notifier).loadData();

    await _scheduleNotifications();

    setState(() {
      isLoading = false;
    });
  }

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
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    final grades = ref.watch(gradesFilterDateProvider);

    return isLoading
        ? Container(
            color: Color(0xff0dc1fe),
            width: double.infinity,
            height: double.infinity,
            alignment: Alignment.center,
            child: Lottie.asset('assets/lottle/1745961873622.json',
                width: 200, height: 200))
        : Scaffold(
            key: scaffoldKey,
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
                    firstDate:
                        DateTime.now().subtract(const Duration(days: 30)),
                    lastDate:
                        DateTime.now().add(const Duration(days: 365 * 10)),
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
                            final luminosity =
                                calculateLuminosity(backgroundColor);
                            final textColor = luminosity > 0.5
                                ? Colors.black87
                                : Colors.white;

                            final content = subStringContent(grade.content);
                            return GestureDetector(
                                onTap: () {
                                  context.push("/add_note/${grade.id}");
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    color: backgroundColor,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                        style: TextStyle(
                                            fontSize: 14, color: textColor),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 5,
                                      ),
                                    ],
                                  ),
                                ));
                          },
                        ))
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: const Color(0xFF3498DB),
              onPressed: () {
                context.push("/add_note/0");
              },
              child: const Icon(
                Icons.add,
                color: Colors.white,
                size: 32,
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            bottomNavigationBar: CustomNavigation(),
          );
  }
}
