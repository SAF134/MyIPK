import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

class GradingScaleScreen extends StatelessWidget {
  const GradingScaleScreen({super.key});

  static const _grades = [
    _GradeEntry(letter: 'A', range: '85.01 – 100', point: 4.0, color: Color(0xFF2E7D32)),
    _GradeEntry(letter: 'AB', range: '75.01 – 85', point: 3.5, color: Color(0xFF4CAF50)),
    _GradeEntry(letter: 'B', range: '65.01 – 75', point: 3.0, color: Color(0xFF8BC34A)),
    _GradeEntry(letter: 'BC', range: '60.01 – 65', point: 2.5, color: Color(0xFFFBC02D)),
    _GradeEntry(letter: 'C', range: '50.01 – 60', point: 2.0, color: Color(0xFFF57C00)),
    _GradeEntry(letter: 'D', range: '40.01 – 50', point: 1.0, color: Color(0xFFE64A19)),
    _GradeEntry(letter: 'E', range: '0 – 40', point: 0.0, color: Color(0xFFD32F2F)),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.creamBackground,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          color: AppColors.primary,
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Panduan Skala Nilai',
          style: AppTypography.titleLarge.copyWith(color: AppColors.primary),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header Card ────────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary.withValues(alpha: 0.08),
                    AppColors.primaryContainer.withValues(alpha: 0.06),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: AppColors.primaryContainer.withValues(alpha: 0.15),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: AppColors.primaryFixed,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Icon(
                      Icons.analytics_outlined,
                      color: AppColors.primary,
                      size: 28,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Standard 4.00',
                    style: AppTypography.headlineMedium.copyWith(
                      fontWeight: FontWeight.w800,
                      color: AppColors.onSurface,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Sistem penilaian berdasarkan skala 4.00\nyang digunakan oleh perguruan tinggi di Indonesia.',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.onSurfaceVariant,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // ── Grade Table ────────────────────────────────────
            Text(
              'Tabel Konversi Nilai',
              style: AppTypography.titleLarge.copyWith(
                color: AppColors.onSurface,
              ),
            ),
            const SizedBox(height: 16),

            // Table Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Huruf',
                      style: AppTypography.labelMedium.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      'Rentang Nilai',
                      style: AppTypography.labelMedium.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Bobot',
                      style: AppTypography.labelMedium.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.end,
                    ),
                  ),
                ],
              ),
            ),

            // Table Rows
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(20),
                ),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Column(
                children: List.generate(_grades.length, (i) {
                  final g = _grades[i];
                  final isLast = i == _grades.length - 1;
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    decoration: BoxDecoration(
                      border: isLast
                          ? null
                          : Border(
                              bottom: BorderSide(color: AppColors.cardBorder),
                            ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: g.color.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              g.letter,
                              style: AppTypography.labelMedium.copyWith(
                                fontWeight: FontWeight.w800,
                                color: g.color,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 3,
                          child: Text(
                            g.range,
                            style: AppTypography.bodyMedium.copyWith(
                              color: AppColors.onSurface,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            g.point.toStringAsFixed(1),
                            style: AppTypography.titleLarge.copyWith(
                              fontWeight: FontWeight.w700,
                              color: g.color,
                            ),
                            textAlign: TextAlign.end,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),

            const SizedBox(height: 28),

            // ── Formula Card ───────────────────────────────────
            Text(
              'Rumus Perhitungan',
              style: AppTypography.titleLarge.copyWith(
                color: AppColors.onSurface,
              ),
            ),
            const SizedBox(height: 16),

            _FormulaCard(
              title: 'IPS (Indeks Prestasi Semester)',
              formula: 'IPS = Σ (SKS × Bobot) / Σ SKS',
              description: 'Dihitung per semester dari seluruh mata kuliah yang diambil pada semester tersebut.',
              icon: Icons.calculate_outlined,
            ),
            const SizedBox(height: 12),
            _FormulaCard(
              title: 'IPK (Indeks Prestasi Kumulatif)',
              formula: 'IPK = Σ (SKS × Bobot) / Σ SKS',
              description: 'Dihitung dari seluruh mata kuliah yang telah ditempuh sejak semester pertama.',
              icon: Icons.school_outlined,
            ),

            const SizedBox(height: 28),

            // ── Predikat ───────────────────────────────────────
            Text(
              'Predikat Kelulusan',
              style: AppTypography.titleLarge.copyWith(
                color: AppColors.onSurface,
              ),
            ),
            const SizedBox(height: 16),

            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Column(
                children: [
                  _PredikatTile(
                    predikat: 'Summa cumlaude',
                    ipk: '3.95 – 4.00',
                    icon: Icons.emoji_events,
                    color: const Color(0xFF2E7D32),
                    isFirst: true,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Divider(height: 1, color: AppColors.cardBorder),
                  ),
                  _PredikatTile(
                    predikat: 'Cumlaude',
                    ipk: '3.60 – 3.89',
                    icon: Icons.star,
                    color: const Color(0xFF1565C0),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Divider(height: 1, color: AppColors.cardBorder),
                  ),
                  _PredikatTile(
                    predikat: 'Sangat Memuaskan',
                    ipk: '3.45 – 3.59',
                    icon: Icons.thumb_up_alt_outlined,
                    color: const Color(0xFFEF6C00),
                    isLast: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GradeEntry {
  final String letter;
  final String range;
  final double point;
  final Color color;

  const _GradeEntry({
    required this.letter,
    required this.range,
    required this.point,
    required this.color,
  });
}

class _FormulaCard extends StatelessWidget {
  const _FormulaCard({
    required this.title,
    required this.formula,
    required this.description,
    required this.icon,
  });

  final String title;
  final String formula;
  final String description;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.primaryFixed,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: AppColors.primary, size: 18),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: AppTypography.labelMedium.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              formula,
              style: AppTypography.titleLarge.copyWith(
                fontWeight: FontWeight.w800,
                color: AppColors.primary,
                letterSpacing: 0.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.onSurfaceVariant,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _PredikatTile extends StatelessWidget {
  const _PredikatTile({
    required this.predikat,
    required this.ipk,
    required this.icon,
    required this.color,
    this.isFirst = false,
    this.isLast = false,
  });

  final String predikat;
  final String ipk;
  final IconData icon;
  final Color color;
  final bool isFirst;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  predikat,
                  style: AppTypography.labelMedium.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'IPK $ipk',
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
