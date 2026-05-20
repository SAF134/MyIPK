import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../shared/widgets/app_top_bar.dart';
import '../../core/database/static_database.dart';
import 'widgets/today_schedule_card.dart';
import 'widgets/gpa_summary_card.dart';
import 'widgets/upcoming_tasks_card.dart';

/// Beranda (Home) screen — the main dashboard of MyIPK.
///
/// Shows: greeting header, today's schedule card, GPA summary card,
/// and upcoming tasks card.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final db = StaticDatabase();
    return Scaffold(
      backgroundColor: AppColors.creamBackground,
      appBar: AppTopBar(title: 'Halo, ${db.profileName}!'),
      body: CustomScrollView(
        slivers: [
          // ── Content ──────────────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 120),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const GpaSummaryCard(),
                const SizedBox(height: 24),
                const TodayScheduleCard(),
                const SizedBox(height: 24),
                const UpcomingTasksCard(),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
