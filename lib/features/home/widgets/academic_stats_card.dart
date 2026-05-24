import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/database/static_database.dart';

class AcademicStatsCard extends StatefulWidget {
  const AcademicStatsCard({super.key});

  @override
  State<AcademicStatsCard> createState() => _AcademicStatsCardState();
}

class _AcademicStatsCardState extends State<AcademicStatsCard> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final db = StaticDatabase();
    final courses = db.getCourses();

    if (courses.isEmpty) {
      return const SizedBox.shrink(); // Hide if no data
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryContainer.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
            child: Row(
              children: [
                const Icon(Icons.insights, size: 20, color: AppColors.primary),
                const SizedBox(width: 8),
                Text(
                  'Statistik Akademik',
                  style: AppTypography.titleLarge.copyWith(
                    color: AppColors.onSurface,
                  ),
                ),
              ],
            ),
          ),
          
          TabBar(
            controller: _tabController,
            indicatorColor: AppColors.primary,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.onSurfaceVariant,
            labelStyle: AppTypography.labelMedium.copyWith(fontWeight: FontWeight.bold),
            dividerColor: AppColors.cardBorder,
            tabs: const [
              Tab(text: 'Tren IPS'),
              Tab(text: 'Sebaran Nilai'),
            ],
          ),
          
          SizedBox(
            height: 260,
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildLineChart(db, courses),
                _buildPieChart(courses),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLineChart(StaticDatabase db, List<CourseItem> allCourses) {
    // Find unique semesters that have courses
    final uniqueSemesters = allCourses.map((c) => c.semester).toSet().toList()..sort();
    
    if (uniqueSemesters.length < 2) {
      return Center(
        child: Text(
          'Dibutuhkan minimal 2 semester\nuntuk melihat tren IPS.',
          textAlign: TextAlign.center,
          style: AppTypography.bodyMedium.copyWith(color: AppColors.onSurfaceVariant),
        ),
      );
    }

    final spots = uniqueSemesters.map((sem) {
      return FlSpot(sem.toDouble(), db.getIpsBySemester(sem));
    }).toList();

    return Padding(
      padding: const EdgeInsets.only(right: 24, left: 12, top: 32, bottom: 16),
      child: LineChart(
        LineChartData(
          minY: 0,
          maxY: 4.0,
          minX: uniqueSemesters.first.toDouble(),
          maxX: uniqueSemesters.last.toDouble(),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 1,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: AppColors.cardBorder,
                strokeWidth: 1,
                dashArray: [5, 5],
              );
            },
          ),
          titlesData: FlTitlesData(
            show: true,
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      'Smt ${value.toInt()}',
                      style: AppTypography.labelSmall.copyWith(color: AppColors.onSurfaceVariant),
                    ),
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                reservedSize: 32,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toStringAsFixed(1),
                    style: AppTypography.labelSmall.copyWith(color: AppColors.onSurfaceVariant),
                    textAlign: TextAlign.right,
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: AppColors.primary,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) {
                  return FlDotCirclePainter(
                    radius: 4,
                    color: AppColors.primaryContainer,
                    strokeWidth: 2,
                    strokeColor: AppColors.primary,
                  );
                },
              ),
              belowBarData: BarAreaData(
                show: true,
                color: AppColors.primary.withValues(alpha: 0.15),
              ),
            ),
          ],
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (_) => AppColors.onSurface,
              getTooltipItems: (touchedSpots) {
                return touchedSpots.map((spot) {
                  return LineTooltipItem(
                    'IPS: ${spot.y.toStringAsFixed(2)}',
                    AppTypography.labelMedium.copyWith(color: AppColors.surface, fontWeight: FontWeight.bold),
                  );
                }).toList();
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPieChart(List<CourseItem> allCourses) {
    final gradeCounts = <String, int>{
      'A': 0, 'AB': 0, 'B': 0, 'BC': 0, 'C': 0, 'D': 0, 'E': 0
    };

    int total = 0;
    for (var c in allCourses) {
      if (gradeCounts.containsKey(c.grade)) {
        gradeCounts[c.grade] = gradeCounts[c.grade]! + 1;
        total++;
      }
    }

    if (total == 0) return const SizedBox.shrink();

    // Only show sections that have count > 0
    final sections = <PieChartSectionData>[];
    gradeCounts.forEach((grade, count) {
      if (count > 0) {
        final percentage = (count / total) * 100;
        sections.add(
          PieChartSectionData(
            color: AppColors.getGradeColor(grade),
            value: count.toDouble(),
            title: '${percentage.toStringAsFixed(1)}%',
            radius: 50,
            titleStyle: AppTypography.labelSmall.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      }
    });

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: PieChart(
              PieChartData(
                sectionsSpace: 2,
                centerSpaceRadius: 40,
                sections: sections,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: gradeCounts.entries
                  .where((e) => e.value > 0)
                  .map((e) => _buildLegendItem(e.key, e.value))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String grade, int count) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.getGradeColor(grade),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'Nilai $grade',
            style: AppTypography.labelMedium.copyWith(color: AppColors.onSurface),
          ),
          const Spacer(),
          Text(
            '$count',
            style: AppTypography.labelMedium.copyWith(color: AppColors.onSurfaceVariant, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
