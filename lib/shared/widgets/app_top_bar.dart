import 'dart:convert';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/database/static_database.dart';
import '../../features/settings/settings_screen.dart';

/// Reusable top app bar matching the Stitch design.
///
/// Profile photo on the left, settings gear icon on the right.
class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  const AppTopBar({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final db = StaticDatabase();
    final hasPhoto = db.profilePicBase64 != null;

    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      titleSpacing: 0,
      // ── Profile photo on the left ──
      leadingWidth: 64,
      leading: Container(
        width: 40,
        height: 40,
        margin: const EdgeInsets.only(left: 20),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.primaryContainer,
            width: 2,
          ),
          color: AppColors.primaryContainer.withValues(alpha: 0.2),
        ),
        child: ClipOval(
          child: hasPhoto
              ? Image.memory(
                  base64Decode(db.profilePicBase64!),
                  fit: BoxFit.cover,
                  width: 40,
                  height: 40,
                )
              : const Center(
                  child: Icon(
                    Icons.person,
                    size: 20,
                    color: AppColors.primaryContainer,
                  ),
                ),
        ),
      ),
      // ── Title ──
      title: Padding(
        padding: const EdgeInsets.only(left: 8),
        child: Text(
          title,
          style: AppTypography.titleLarge.copyWith(
            color: AppColors.primary,
          ),
        ),
      ),
      centerTitle: false,
      // ── Settings gear on the right ──
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 12),
          child: IconButton(
            icon: const Icon(
              Icons.settings_outlined,
              color: AppColors.onSurfaceVariant,
              size: 26,
            ),
            tooltip: 'Pengaturan',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SettingsScreen(),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
