import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

enum BadgeStyle { success, warning, error, info, neutral, primary }

class StatusBadge extends StatelessWidget {
  final String label;
  final BadgeStyle style;
  final double fontSize;

  const StatusBadge({
    super.key,
    required this.label,
    this.style = BadgeStyle.neutral,
    this.fontSize = 11,
  });

  factory StatusBadge.fromStatus(String status) {
    final s = status.toLowerCase();
    BadgeStyle style;
    if (['ready', 'open', 'active', 'completed', 'delivered', 'in stock'].contains(s)) {
      style = BadgeStyle.success;
    } else if (['preparing', 'pending', 'low stock', 'maintenance'].contains(s)) {
      style = BadgeStyle.warning;
    } else if (['cancelled', 'closed', 'out of stock', 'critical'].contains(s)) {
      style = BadgeStyle.error;
    } else if (['dine-in', 'takeaway', 'delivery'].contains(s)) {
      style = BadgeStyle.info;
    } else if (['manager', 'admin', 'full access'].contains(s)) {
      style = BadgeStyle.primary;
    } else {
      style = BadgeStyle.neutral;
    }
    return StatusBadge(label: status.toUpperCase(), style: style);
  }

  @override
  Widget build(BuildContext context) {
    Color bg, fg;
    switch (style) {
      case BadgeStyle.success:
        bg = AppColors.successBg;
        fg = AppColors.success;
        break;
      case BadgeStyle.warning:
        bg = AppColors.warningBg;
        fg = AppColors.warning;
        break;
      case BadgeStyle.error:
        bg = AppColors.errorBg;
        fg = AppColors.error;
        break;
      case BadgeStyle.info:
        bg = AppColors.infoBg;
        fg = AppColors.info;
        break;
      case BadgeStyle.primary:
        bg = AppColors.primarySurface;
        fg = AppColors.primary;
        break;
      case BadgeStyle.neutral:
        bg = const Color(0xFFF3F4F6);
        fg = AppColors.textSecondary;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Text(
        label,
        style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w600, color: fg),
      ),
    );
  }
}
