import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

/// Tentang Pengembang — About the developer page.
class AboutDeveloperScreen extends StatelessWidget {
  const AboutDeveloperScreen({super.key});

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
          'Tentang Pengembang',
          style: AppTypography.titleLarge.copyWith(color: AppColors.primary),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 48),
        child: Column(
          children: [
            // ── Developer Profile Card ─────────────────────────
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
                  // Avatar
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primaryFixed,
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.2),
                        width: 4,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.15),
                          blurRadius: 24,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.person,
                        size: 48,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Syauqi Akmal Fadhali',
                    style: AppTypography.headlineMedium.copyWith(
                      fontWeight: FontWeight.w800,
                      color: AppColors.onSurface,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Mahasiswa Teknik Komputer',
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Mahasiswa yang bersemangat dalam\nmengembangkan aplikasi mobile\nuntuk membantu sesama mahasiswa.',
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

            // ── Contact / Social ──────────────────────────────
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Informasi Pengembang',
                style: AppTypography.titleLarge.copyWith(
                  color: AppColors.onSurface,
                ),
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
                  _ContactTile(
                    icon: Icons.email_outlined,
                    title: 'Email',
                    value: 'syauqiakmal137@gmail.com',
                    color: const Color(0xFFC62828),
                    isFirst: true,
                  ),
                  _contactDivider(),
                  _ContactTile(
                    icon: Icons.code_rounded,
                    title: 'GitHub',
                    value: 'github.com/SAF134',
                    color: const Color(0xFF212121),
                  ),
                  _contactDivider(),
                  _ContactTile(
                    icon: Icons.chat_bubble_outline,
                    title: 'WhatsApp',
                    value: '+62 812-9862-8236',
                    color: const Color(0xFF25D366),
                  ),
                  _contactDivider(),
                  _ContactTile(
                    icon: Icons.account_balance_outlined,
                    title: 'SeaBank',
                    value: '901217685910',
                    color: const Color(0xFFFF5A00),
                    isLast: true,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // ── Skills ────────────────────────────────────────
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Keahlian',
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
                  _SkillChip(label: 'Flutter', color: const Color(0xFF027DFD)),
                  _SkillChip(label: 'Dart', color: const Color(0xFF0175C2)),
                  _SkillChip(label: 'Android', color: const Color(0xFF3DDC84)),
                  _SkillChip(label: 'Firebase', color: const Color(0xFFFFA000)),
                  _SkillChip(label: 'UI/UX Design', color: AppColors.primary),
                  _SkillChip(label: 'Git', color: const Color(0xFFF4511E)),
                ],
              ),
            ),


          ],
        ),
      ),
    );
  }

  Widget _contactDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Divider(height: 1, color: AppColors.cardBorder),
    );
  }
}

class _ContactTile extends StatelessWidget {
  const _ContactTile({
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
    this.isFirst = false,
    this.isLast = false,
  });

  final IconData icon;
  final String title;
  final String value;
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
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: AppTypography.labelMedium.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.onSurface,
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

class _SkillChip extends StatelessWidget {
  const _SkillChip({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: color.withValues(alpha: 0.15),
        ),
      ),
      child: Text(
        label,
        style: AppTypography.labelSmall.copyWith(
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}
