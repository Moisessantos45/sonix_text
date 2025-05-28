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
    final width = MediaQuery.of(context).size.width;
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
                centerSpaceRadius: width * 0.2, // antes 80
                sections: showingSections(grades, width).map((section) {
                  return section.copyWith(
                    radius: section.radius * 1.8,
                  );
                }).toList()),
          ),
        ),
        SizedBox(
          height: width * 0.1, // antes 40
        ),
        SizedBox(
            width: width * 0.8,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Indicator(
                  color: AppColors.contentColorBlue,
                  text: 'Pending',
                  isSquare: true,
                  size: width * 0.04, // antes 16
                ),
                SizedBox(
                  height: width * 0.01, // antes 4
                ),
                Indicator(
                  color: AppColors.contentColorYellow,
                  text: 'In Progress',
                  isSquare: true,
                  size: width * 0.04, // antes 16
                ),
                SizedBox(
                  height: width * 0.01, // antes 4
                ),
                Indicator(
                  color: AppColors.contentColorGreen,
                  text: 'Completed',
                  isSquare: true,
                  size: width * 0.04, // antes 16
                ),
                SizedBox(
                  height: width * 0.01, // antes 4
                ),
              ],
            )),
      ],
    );
  }

  List<PieChartSectionData> showingSections(
      List<EntityGrade> grades, double width) {
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
        radius: _getRadius(0, width),
        titleStyle: _getTitleStyle(0, width),
        badgeWidget: _getBadge("Pending", pendingCount, pendingColor, width),
        badgePositionPercentageOffset: .45,
        titlePositionPercentageOffset: .80,
      ),
      PieChartSectionData(
        color: inProgressColor,
        value: inProgressPercent,
        title: "${inProgressPercent.toStringAsFixed(0)}%",
        radius: _getRadius(1, width),
        titleStyle: _getTitleStyle(1, width),
        badgeWidget:
            _getBadge("In Progress", inProgressCount, inProgressColor, width),
        badgePositionPercentageOffset: .45,
        titlePositionPercentageOffset: .80,
      ),
      PieChartSectionData(
        color: completedColor,
        value: completedPercent,
        title: "${completedPercent.toStringAsFixed(0)}%",
        radius: _getRadius(2, width),
        titleStyle: _getTitleStyle(2, width),
        badgeWidget:
            _getBadge("Completed", completedCount, completedColor, width),
        badgePositionPercentageOffset: .45,
        titlePositionPercentageOffset: .80,
      ),
    ];
  }

  double _getRadius(int index, double width) {
    return touchedIndex == index
        ? width * 0.15
        : width * 0.125; // antes 60.0 : 50.0
  }

  TextStyle _getTitleStyle(int index, double width) {
    final isTouched = index == touchedIndex;
    return TextStyle(
      fontSize: isTouched ? width * 0.06 : width * 0.04, // antes 25.0 : 15.0
      fontFamily: 'Poppins',
      fontWeight: FontWeight.bold,
      color: AppColors.mainTextColor1,
      shadows: [const Shadow(color: Colors.black, blurRadius: 2)],
    );
  }

  Widget _getBadge(String label, int count, Color color, double width) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          label,
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: width * 0.03), // antes 12
        ),
        Text(
          count.toString(),
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: width * 0.035, // antes no especificado
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
    final width = MediaQuery.of(context).size.width;
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
        SizedBox(
          width: width * 0.01, // antes 4
        ),
        Text(
          text,
          style: TextStyle(
            fontSize: width * 0.04, // antes 16
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        )
      ],
    );
  }
}
