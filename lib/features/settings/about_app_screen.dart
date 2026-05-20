import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

/// Tentang Aplikasi — About the MyIPK application.
class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

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
          'Tentang Aplikasi',
          style: AppTypography.titleLarge.copyWith(color: AppColors.primary),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 48),
        child: Column(
          children: [
            // ── App Identity Card ──────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary.withValues(alpha: 0.06),
                    AppColors.primaryContainer.withValues(alpha: 0.04),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: AppColors.primaryContainer.withValues(alpha: 0.15),
                ),
              ),
              child: Column(
                children: [
                  // App Icon
                  Container(
                    width: 88,
                    height: 88,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.15),
                          blurRadius: 24,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Image.asset(
                        'assets/images/Logo_MyIPK.png',
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) => const Icon(
                          Icons.school,
                          size: 44,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'MyIPK',
                    style: AppTypography.headlineMedium.copyWith(
                      fontWeight: FontWeight.w800,
                      color: AppColors.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Versi 0.1.0',
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Aplikasi manajemen akademik mahasiswa\nuntuk menghitung IPK dan mengatur jadwal kuliah.',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.onSurfaceVariant,
                      height: 1.6,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // ── Features Section ──────────────────────────────
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Fitur Utama',
                style: AppTypography.titleLarge.copyWith(
                  color: AppColors.onSurface,
                ),
              ),
            ),
            const SizedBox(height: 16),

            _FeatureTile(
              icon: Icons.calculate_outlined,
              title: 'Kalkulator IPK',
              description: 'Hitung Indeks Prestasi Kumulatif secara otomatis berdasarkan mata kuliah yang diambil.',
              color: const Color(0xFF2E7D32),
            ),
            const SizedBox(height: 12),
            _FeatureTile(
              icon: Icons.calendar_today_rounded,
              title: 'Jadwal Kuliah',
              description: 'Atur dan pantau jadwal mata kuliah harian dengan tampilan yang mudah dipahami.',
              color: const Color(0xFF1565C0),
            ),
            const SizedBox(height: 12),
            _FeatureTile(
              icon: Icons.bar_chart_rounded,
              title: 'Riwayat Semester',
              description: 'Lihat perkembangan IPS setiap semester dan detail mata kuliah yang diambil.',
              color: const Color(0xFFEF6C00),
            ),
            const SizedBox(height: 12),
            _FeatureTile(
              icon: Icons.person_outline_rounded,
              title: 'Profil Mahasiswa',
              description: 'Personalisasi profil dengan nama, universitas, program studi, dan foto.',
              color: AppColors.primary,
            ),

            const SizedBox(height: 28),

            // ── Tech Stack ────────────────────────────────────
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Teknologi',
                style: AppTypography.titleLarge.copyWith(
                  color: AppColors.onSurface,
                ),
              ),
            ),
            const SizedBox(height: 16),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _TechChip(label: 'Flutter', icon: Icons.flutter_dash),
                  _TechChip(label: 'Dart', icon: Icons.code),
                  _TechChip(label: 'Material Design 3', icon: Icons.palette_outlined),
                  _TechChip(label: 'SharedPreferences', icon: Icons.storage_outlined),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // ── Footer ────────────────────────────────────────
            Text(
              '© 2026 MyIPK. All rights reserved.',
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.onSurfaceVariant.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureTile extends StatelessWidget {
  const _FeatureTile({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });

  final IconData icon;
  final String title;
  final String description;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.labelMedium.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.onSurfaceVariant,
                    height: 1.5,
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

class _TechChip extends StatelessWidget {
  const _TechChip({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.primaryFixed.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.primary),
          const SizedBox(width: 8),
          Text(
            label,
            style: AppTypography.labelSmall.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
