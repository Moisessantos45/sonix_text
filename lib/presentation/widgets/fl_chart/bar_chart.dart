import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:sonix_text/domains/entity_grade.dart';
import 'package:sonix_text/presentation/utils/app_colors.dart';

class BarChartWidget extends StatelessWidget {
  final List<EntityGrade> grades;

  const BarChartWidget({
    super.key,
    required this.grades,
  });

  @override
  Widget build(BuildContext context) {
    final weekCounts = countNotesByWeekday(grades);
    return BarChart(
      BarChartData(
        barTouchData: barTouchData,
        titlesData: titlesData,
        borderData: borderData,
        barGroups: _generateBarGroups(weekCounts),
        gridData: const FlGridData(show: false),
        alignment: BarChartAlignment.spaceAround,
        maxY: _calculateMaxY(weekCounts),
      ),
    );
  }

  double _calculateMaxY(List<int> counts) {
    final maxCount = counts.reduce((a, b) => a > b ? a : b);
    return maxCount.toDouble() * 1.2;
  }

  List<BarChartGroupData> _generateBarGroups(List<int> counts) {
    return List.generate(7, (index) {
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: counts[index].toDouble(),
            gradient: _barsGradient,
          )
        ],
        showingTooltipIndicators: [0],
      );
    });
  }

  BarTouchData get barTouchData => BarTouchData(
        enabled: false,
        touchTooltipData: BarTouchTooltipData(
          getTooltipColor: (group) => Colors.transparent,
          tooltipPadding: EdgeInsets.zero,
          tooltipMargin: 8,
          getTooltipItem: (
            BarChartGroupData group,
            int groupIndex,
            BarChartRodData rod,
            int rodIndex,
          ) {
            return BarTooltipItem(
              rod.toY.round().toString(),
              const TextStyle(
                color: AppColors.contentColorCyan,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
      );

  Widget getTitles(double value, TitleMeta meta) {
    final now = DateTime.now();
    final currentWeekday = now.weekday;
    final daysFromMonday = currentWeekday - 1;
    final targetDate =
        now.subtract(Duration(days: daysFromMonday - value.toInt()));

    final style = TextStyle(
      color: AppColors.contentColorBlue.darken(20),
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );

    String text;
    switch (value.toInt()) {
      case 0:
        text = 'Lun\n${targetDate.day}';
      case 1:
        text = 'Mar\n${targetDate.day}';
      case 2:
        text = 'Mié\n${targetDate.day}';
      case 3:
        text = 'Jue\n${targetDate.day}';
      case 4:
        text = 'Vie\n${targetDate.day}';
      case 5:
        text = 'Sáb\n${targetDate.day}';
      case 6:
        text = 'Dom\n${targetDate.day}';
      default:
        text = '';
    }

    return SideTitleWidget(
      meta: meta,
      space: 4,
      child: Text(text, style: style),
    );
  }

  FlTitlesData get titlesData => FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: getTitles,
          ),
        ),
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      );

  FlBorderData get borderData => FlBorderData(
        show: false,
      );

  LinearGradient get _barsGradient => LinearGradient(
        colors: [
          AppColors.contentColorBlue.darken(20),
          AppColors.contentColorCyan,
        ],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      );

  List<BarChartGroupData> get barGroups => [
        BarChartGroupData(
          x: 0,
          barRods: [
            BarChartRodData(
              toY: 8,
              gradient: _barsGradient,
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 1,
          barRods: [
            BarChartRodData(
              toY: 10,
              gradient: _barsGradient,
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 2,
          barRods: [
            BarChartRodData(
              toY: 14,
              gradient: _barsGradient,
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 3,
          barRods: [
            BarChartRodData(
              toY: 15,
              gradient: _barsGradient,
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 4,
          barRods: [
            BarChartRodData(
              toY: 13,
              gradient: _barsGradient,
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 5,
          barRods: [
            BarChartRodData(
              toY: 10,
              gradient: _barsGradient,
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 6,
          barRods: [
            BarChartRodData(
              toY: 16,
              gradient: _barsGradient,
            )
          ],
          showingTooltipIndicators: [0],
        ),
      ];

  List<int> countNotesByWeekday(List<EntityGrade> notes) {
    final now = DateTime.now();

    final monday = now.subtract(Duration(days: now.weekday - 1));

    final counts = List<int>.filled(7, 0);

    for (final note in notes) {
      final noteDate = _parseDate(note.date);

      if (noteDate.isAfter(monday.subtract(const Duration(days: 1)))) {
        final weekday = noteDate.weekday - 1;
        counts[weekday]++;
      }
    }

    return counts;
  }

  DateTime _parseDate(String dateStr) {
    final parts = dateStr.split('/');
    if (parts.length != 3) {
      throw FormatException('Invalid date format: $dateStr');
    }

    return DateTime(
      int.parse(parts[2]),
      int.parse(parts[1]),
      int.parse(parts[0]),
    );
  }
}
