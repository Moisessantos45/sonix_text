import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sonix_text/domains/entity_grade.dart';
import 'package:sonix_text/presentation/riverpod/repository_grade.dart';
import 'package:sonix_text/presentation/utils/app_colors.dart';

class PieChartWidget extends ConsumerStatefulWidget {
  const PieChartWidget({super.key});

  @override
  ConsumerState<PieChartWidget> createState() => _PieChartWidgetState();
}

class _PieChartWidgetState extends ConsumerState<PieChartWidget> {
  int touchedIndex = -1;
  @override
  Widget build(BuildContext context) {
    final grades = ref.watch(allGradesProvider);
    return Column(
      children: [
        Expanded(
          child: PieChart(
            PieChartData(
                pieTouchData: PieTouchData(
                  touchCallback: (FlTouchEvent event, pieTouchResponse) {
                    setState(() {
                      if (!event.isInterestedForInteractions ||
                          pieTouchResponse == null ||
                          pieTouchResponse.touchedSection == null) {
                        touchedIndex = -1;
                        return;
                      }
                      touchedIndex =
                          pieTouchResponse.touchedSection!.touchedSectionIndex;
                    });
                  },
                ),
                borderData: FlBorderData(
                  show: false,
                ),
                sectionsSpace: 0,
                centerSpaceRadius: 80,
                sections: showingSections(grades).map((section) {
                  return section.copyWith(
                    radius: section.radius * 1.8,
                  );
                }).toList()),
          ),
        ),
        const SizedBox(
          height: 40,
        ),
        SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Indicator(
                  color: AppColors.contentColorBlue,
                  text: 'Pending',
                  isSquare: true,
                ),
                SizedBox(
                  height: 4,
                ),
                Indicator(
                  color: AppColors.contentColorYellow,
                  text: 'In Progress',
                  isSquare: true,
                ),
                SizedBox(
                  height: 4,
                ),
                Indicator(
                  color: AppColors.contentColorGreen,
                  text: 'Completed',
                  isSquare: true,
                ),
                SizedBox(
                  height: 4,
                ),
              ],
            )),
      ],
    );
  }

  List<PieChartSectionData> showingSections(List<EntityGrade> grades) {
    final pendingCount =
        grades.where((task) => task.status == "Pending").length;
    final inProgressCount =
        grades.where((task) => task.status == "In Progress").length;
    final completedCount =
        grades.where((task) => task.status == "Completed").length;

    final total = grades.length;
    final pendingPercent = total > 0 ? (pendingCount / total * 100) : 0.0;
    final inProgressPercent = total > 0 ? (inProgressCount / total * 100) : 0.0;
    final completedPercent = total > 0 ? (completedCount / total * 100) : 0.0;

    const pendingColor = AppColors.contentColorYellow;
    const inProgressColor = AppColors.contentColorBlue;
    const completedColor = AppColors.contentColorGreen;

    return [
      PieChartSectionData(
        color: pendingColor,
        value: pendingPercent,
        title: "${pendingPercent.toStringAsFixed(0)}%",
        radius: _getRadius(0),
        titleStyle: _getTitleStyle(0),
        badgeWidget: _getBadge("Pending", pendingCount, pendingColor),
        badgePositionPercentageOffset: .45,
        titlePositionPercentageOffset: .80,
      ),
      PieChartSectionData(
        color: inProgressColor,
        value: inProgressPercent,
        title: "${inProgressPercent.toStringAsFixed(0)}%",
        radius: _getRadius(1),
        titleStyle: _getTitleStyle(1),
        badgeWidget: _getBadge("In Progress", inProgressCount, inProgressColor),
        badgePositionPercentageOffset: .45,
        titlePositionPercentageOffset: .80,
      ),
      PieChartSectionData(
        color: completedColor,
        value: completedPercent,
        title: "${completedPercent.toStringAsFixed(0)}%",
        radius: _getRadius(2),
        titleStyle: _getTitleStyle(2),
        badgeWidget: _getBadge("Completed", completedCount, completedColor),
        badgePositionPercentageOffset: .45,
        titlePositionPercentageOffset: .80,
      ),
    ];
  }

  double _getRadius(int index) {
    return touchedIndex == index ? 60.0 : 50.0;
  }

  TextStyle _getTitleStyle(int index) {
    final isTouched = index == touchedIndex;
    return TextStyle(
      fontSize: isTouched ? 25.0 : 15.0,
      fontFamily: 'Poppins',
      fontWeight: FontWeight.bold,
      color: AppColors.mainTextColor1,
      shadows: [const Shadow(color: Colors.black, blurRadius: 2)],
    );
  }

  Widget _getBadge(String label, int count, Color color) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          label,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
        ),
        Text(
          count.toString(),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class Indicator extends StatelessWidget {
  const Indicator({
    super.key,
    required this.color,
    required this.text,
    required this.isSquare,
    this.size = 16,
    this.textColor,
  });
  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        )
      ],
    );
  }
}
