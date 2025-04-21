import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sonix_text/config/helper/page_router.dart';
import 'package:sonix_text/presentation/riverpod/repository_grade.dart';
import 'package:sonix_text/presentation/screens/voicce_text.dart';
import 'package:sonix_text/presentation/widgets/fl_chart/bar_chart.dart';
import 'package:sonix_text/presentation/widgets/fl_chart/pie_chart.dart';
import 'package:sonix_text/presentation/widgets/navigation_bar.dart';

class StatisticsScreen extends ConsumerStatefulWidget {
  const StatisticsScreen({super.key});

  @override
  ConsumerState<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends ConsumerState<StatisticsScreen> {
  @override
  Widget build(BuildContext context) {
    final grades = ref.watch(allGradesProvider);

    return Scaffold(
        backgroundColor: const Color(0xFFD6EAF8).withAlpha(50),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          title: const Text('Mis Estadisticas',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C3E50),
                fontSize: 26,
                letterSpacing: 0.5,
              )),
          centerTitle: true,
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: Column(
                  children: [
                    const Text(
                      'Estado de las Notas',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2C3E50),
                      ),
                    ),
                    const SizedBox(height: 50),
                    grades.isEmpty
                        ? const Center(
                            child: Text(
                              'No hay notas registradas',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF7F8C8D),
                              ),
                            ),
                          )
                        : SizedBox(
                            height: constraints.maxHeight * 0.55,
                            child: PieChartWidget(),
                          ),
                    const SizedBox(height: 20),
                    const Text(
                      'Notas por dia',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2C3E50),
                      ),
                    ),
                    grades.isEmpty
                        ? const Center(
                            child: Text(
                              'No hay notas registradas',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF7F8C8D),
                              ),
                            ),
                          )
                        : SizedBox(
                            height: constraints.maxHeight * 0.4,
                            child: BarChartWidget(grades: [...grades]),
                          ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color(0xFF3498DB),
          onPressed: () {
            Navigator.push(
              context,
              CustomPageRoute(page: const VoiceTextScreen()),
            );
          },
          child: const Icon(Icons.add, color: Colors.white),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: CustomNavigation());
  }
}
