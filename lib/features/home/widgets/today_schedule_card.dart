import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/database/static_database.dart';

/// A card that displays today's college class schedule dynamically.
/// Shows ongoing, upcoming, and finished classes with real-time indicators.
class TodayScheduleCard extends StatelessWidget {
  const TodayScheduleCard({super.key});

  String get _currentDayString {
    switch (DateTime.now().weekday) {
      case DateTime.monday:
        return 'Senin';
      case DateTime.tuesday:
        return 'Selasa';
      case DateTime.wednesday:
        return 'Rabu';
      case DateTime.thursday:
        return 'Kamis';
      case DateTime.friday:
        return 'Jumat';
      case DateTime.saturday:
        return 'Sabtu';
      case DateTime.sunday:
        return 'Minggu';
      default:
        return 'Senin';
    }
  }

  String get _formattedTodayDate {
    final now = DateTime.now();
    final dayName = _currentDayString;

    final months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember'
    ];
    final monthName = months[now.month - 1];

    return '$dayName, ${now.day} $monthName ${now.year}';
  }

  /// Evaluates class status relative to current hour and minute.
  /// Returns 'sekarang' (ongoing), 'selesai' (finished), or 'mendatang' (upcoming).
  String _getClassStatus(String startStr, String endStr) {
    try {
      final now = DateTime.now();

      final startParts = startStr.split(':');
      final endParts = endStr.split(':');

      if (startParts.length != 2 || endParts.length != 2) return 'mendatang';

      final startHour = int.parse(startParts[0]);
      final startMin = int.parse(startParts[1]);
      final endHour = int.parse(endParts[0]);
      final endMin = int.parse(endParts[1]);

      final startTime = DateTime(now.year, now.month, now.day, startHour, startMin);
      final endTime = DateTime(now.year, now.month, now.day, endHour, endMin);

      if (now.isBefore(startTime)) {
        return 'mendatang';
      } else if (now.isAfter(endTime)) {
        return 'selesai';
      } else {
        return 'sekarang';
      }
    } catch (_) {
      return 'mendatang';
    }
  }

  /// Parses "HH:mm" to a comparable double value (e.g. "08:30" -> 8.5) to sort chronologically.
  double _parseTimeToDouble(String timeStr) {
    try {
      final parts = timeStr.split(':');
      if (parts.length != 2) return 0.0;
      return double.parse(parts[0]) + (double.parse(parts[1]) / 60.0);
    } catch (_) {
      return 0.0;
    }
  }

  void _showScheduleDetailDialog(BuildContext context, ScheduleItem schedule, String status) {
    Color statusColor;
    Color statusBgColor;
    String statusLabel;
    IconData statusIcon;

    if (status == 'sekarang') {
      statusColor = AppColors.primary;
      statusBgColor = AppColors.primary.withValues(alpha: 0.1);
      statusLabel = 'Sedang Berlangsung';
      statusIcon = Icons.play_circle_outline_rounded;
    } else if (status == 'selesai') {
      statusColor = Colors.grey.shade600;
      statusBgColor = Colors.grey.shade100;
      statusLabel = 'Sudah Selesai';
      statusIcon = Icons.check_circle_outline_rounded;
    } else {
      statusColor = const Color(0xFF1565C0);
      statusBgColor = const Color(0xFF1565C0).withValues(alpha: 0.1);
      statusLabel = 'Akan Datang';
      statusIcon = Icons.watch_later_outlined;
    }

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          backgroundColor: Colors.white,
          clipBehavior: Clip.antiAlias,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header with color coding
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.08),
                  border: Border(
                    bottom: BorderSide(
                      color: statusColor.withValues(alpha: 0.15),
                      width: 1.5,
                    ),
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.menu_book_rounded,
                        color: statusColor,
                        size: 28,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      schedule.courseName,
                      style: AppTypography.headlineMedium.copyWith(
                        color: AppColors.onSurface,
                        fontWeight: FontWeight.w800,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              // Content details
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Label Hari & Waktu
                    Text(
                      'HARI & WAKTU KULIAH',
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.onSurfaceVariant,
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.access_time_filled_rounded, size: 18, color: AppColors.onSurfaceVariant),
                        const SizedBox(width: 8),
                        Text(
                          '${schedule.day}, ${schedule.startTime} - ${schedule.endTime} WIB',
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.onSurface,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Label Ruangan
                    Text(
                      'RUANGAN KULIAH',
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.onSurfaceVariant,
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.creamBackground.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.cardBorder),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.room_rounded, size: 20, color: AppColors.primary),
                          const SizedBox(width: 10),
                          Text(
                            schedule.room.isNotEmpty ? schedule.room : 'Daring / Tidak ditentukan',
                            style: AppTypography.bodyMedium.copyWith(
                              color: AppColors.onSurface,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Label Status
                    Text(
                      'STATUS KELAS',
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.onSurfaceVariant,
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(statusIcon, size: 18, color: statusColor),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: statusBgColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            statusLabel.toUpperCase(),
                            style: AppTypography.labelSmall.copyWith(
                              color: statusColor,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Action button
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryContainer,
                      foregroundColor: AppColors.onPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: const Text('Tutup'),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final db = StaticDatabase();
    final todayDay = _currentDayString;
    
    // Retrieve today's schedules and sort them chronologically by start time
    final todaySchedules = List<ScheduleItem>.from(db.getSchedulesByDay(todayDay))
      ..sort((a, b) => _parseTimeToDouble(a.startTime).compareTo(_parseTimeToDouble(b.startTime)));

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.cardBorder,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.secondary.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: AppColors.cardBorder,
                    width: 1.0,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.today_rounded,
                      color: AppColors.primary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Jadwal Kuliah Hari Ini',
                          style: AppTypography.titleLarge.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.onSurface,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _formattedTodayDate,
                          style: AppTypography.labelSmall.copyWith(
                            color: AppColors.outline,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Schedule List or Empty State
            if (todaySchedules.isEmpty)
              _buildEmptyState()
            else
              Padding(
                padding: const EdgeInsets.all(16),
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: todaySchedules.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = todaySchedules[index];
                    final status = _getClassStatus(item.startTime, item.endTime);

                    Color statusColor;
                    Color statusBgColor;
                    String statusLabel;
                    Widget? trailingWidget;

                    if (status == 'sekarang') {
                      statusColor = AppColors.primary;
                      statusBgColor = AppColors.primary.withValues(alpha: 0.1);
                      statusLabel = 'SEKARANG';
                      trailingWidget = Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      );
                    } else if (status == 'selesai') {
                      statusColor = Colors.grey.shade600;
                      statusBgColor = Colors.grey.shade100;
                      statusLabel = 'SELESAI';
                    } else {
                      statusColor = const Color(0xFF1565C0);
                      statusBgColor = const Color(0xFF1565C0).withValues(alpha: 0.1);
                      statusLabel = 'MENDATANG';
                    }

                    return Container(
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerLowest,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: status == 'sekarang'
                              ? AppColors.primary.withValues(alpha: 0.3)
                              : AppColors.cardBorder.withValues(alpha: 0.5),
                          width: status == 'sekarang' ? 1.5 : 1.0,
                        ),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => _showScheduleDetailDialog(context, item, status),
                          child: Row(
                            children: [
                              // Vertical Accent Line
                              Container(
                                width: 6,
                                height: 80,
                                color: statusColor,
                              ),
                              const SizedBox(width: 14),

                              // Main Schedule Details
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              item.courseName,
                                              style: AppTypography.titleLarge.copyWith(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w700,
                                                color: status == 'selesai'
                                                    ? AppColors.outline
                                                    : AppColors.onSurface,
                                                decoration: status == 'selesai'
                                                    ? TextDecoration.lineThrough
                                                    : null,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          if (trailingWidget != null) ...[
                                            trailingWidget,
                                            const SizedBox(width: 14),
                                          ],
                                        ],
                                      ),
                                      const SizedBox(height: 6),
                                      Row(
                                        children: [
                                          // Time Badge
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: AppColors.secondaryFixedDim.withValues(alpha: 0.3),
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                            child: Row(
                                              children: [
                                                const Icon(
                                                  Icons.access_time_rounded,
                                                  size: 12,
                                                  color: AppColors.onSecondaryFixedVariant,
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  '${item.startTime} - ${item.endTime}',
                                                  style: AppTypography.labelSmall.copyWith(
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w600,
                                                    color: AppColors.onSecondaryFixedVariant,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(width: 8),

                                          // Room Badge
                                          if (item.room.isNotEmpty) ...[
                                            Container(
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 8, vertical: 4),
                                              decoration: BoxDecoration(
                                                color: AppColors.surfaceContainerHigh,
                                                borderRadius: BorderRadius.circular(6),
                                              ),
                                              child: Row(
                                                children: [
                                                  const Icon(
                                                    Icons.room_rounded,
                                                    size: 12,
                                                    color: AppColors.onSurfaceVariant,
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    item.room,
                                                    style: AppTypography.labelSmall.copyWith(
                                                      fontSize: 11,
                                                      fontWeight: FontWeight.w600,
                                                      color: AppColors.onSurfaceVariant,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                          ],

                                          // Status Badge
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: statusBgColor,
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                            child: Text(
                                              statusLabel,
                                              style: AppTypography.labelSmall.copyWith(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w700,
                                                color: statusColor,
                                                letterSpacing: 0.5,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.secondaryContainer.withValues(alpha: 0.4),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.coffee_rounded,
              color: AppColors.onSecondaryContainer,
              size: 28,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Tidak ada jadwal kuliah hari ini',
            style: AppTypography.titleLarge.copyWith(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Waktunya bersantai & memulihkan energi! ☕',
            textAlign: TextAlign.center,
            style: AppTypography.bodyMedium.copyWith(
              fontSize: 13,
              color: AppColors.outline,
            ),
          ),
        ],
      ),
    );
  }
}
