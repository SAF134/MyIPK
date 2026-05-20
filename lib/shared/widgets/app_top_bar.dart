import 'dart:convert';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/database/static_database.dart';

/// Reusable top app bar matching the Stitch design.
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
      scrolledUnderElevation: 0, // Prevents background color change on scroll
      titleSpacing: 20,
      title: Text(
        title,
        style: AppTypography.titleLarge.copyWith(
          color: AppColors.primary,
        ),
      ),
      centerTitle: false,
      actions: [
        Container(
          width: 40,
          height: 40,
          margin: const EdgeInsets.only(right: 20),
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
      ],
    );
  }
}
