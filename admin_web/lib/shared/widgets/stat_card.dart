import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;
  final String? badge;
  final Color? badgeColor;
  final IconData? icon;
  final Color? iconBg;
  final Color? iconColor;
  final Widget? trailing;
  final bool isAlert;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    this.subtitle,
    this.badge,
    this.badgeColor,
    this.icon,
    this.iconBg,
    this.iconColor,
    this.trailing,
    this.isAlert = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isAlert
        ? AppColors.errorSurface
        : (isDark ? AppColors.darkCard : AppColors.white);
    final borderColor = isAlert
        ? AppColors.error.withOpacity(0.3)
        : (isDark ? AppColors.darkBorder : AppColors.border);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: iconBg ?? AppColors.primarySurface,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, size: 16, color: iconColor ?? AppColors.primary),
                ),
                const SizedBox(width: 10),
              ],
              Expanded(
                child: Text(title.toUpperCase(),
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary, letterSpacing: 0.5),
                ),
              ),
              if (badge != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: (badgeColor ?? AppColors.success).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(badge!,
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600,
                      color: badgeColor ?? AppColors.success),
                  ),
                ),
              if (isAlert)
                const Icon(Icons.warning_amber_rounded, size: 18, color: AppColors.error),
              if (trailing != null) trailing!,
            ],
          ),
          const SizedBox(height: 12),
          Text(value,
            style: TextStyle(
              fontSize: 28, fontWeight: FontWeight.w700,
              color: isAlert
                  ? AppColors.error
                  : (isDark ? AppColors.darkTextPrimary : AppColors.textPrimary),
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(subtitle!,
              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
          ],
        ],
      ),
    );
  }
}
