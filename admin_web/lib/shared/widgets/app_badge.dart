import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

enum BadgeType { success, warning, error, info, neutral, primary }

class AppBadge extends StatelessWidget {
  final String label;
  final BadgeType type;
  final bool dot;

  const AppBadge({super.key, required this.label, this.type = BadgeType.neutral, this.dot = false});

  Color get _bg {
    switch (type) {
      case BadgeType.success: return AppColors.successSurface;
      case BadgeType.warning: return AppColors.warningSurface;
      case BadgeType.error: return AppColors.errorSurface;
      case BadgeType.info: return AppColors.infoSurface;
      case BadgeType.primary: return AppColors.primarySurface;
      default: return const Color(0xFFF3F4F6);
    }
  }

  Color get _fg {
    switch (type) {
      case BadgeType.success: return AppColors.success;
      case BadgeType.warning: return AppColors.warning;
      case BadgeType.error: return AppColors.error;
      case BadgeType.info: return AppColors.info;
      case BadgeType.primary: return AppColors.primary;
      default: return AppColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: _bg, borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (dot) ...[
            Container(width: 6, height: 6, decoration: BoxDecoration(color: _fg, shape: BoxShape.circle)),
            const SizedBox(width: 5),
          ],
          Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: _fg)),
        ],
      ),
    );
  }
}
