import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/theme_provider.dart';

class SectionCard extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final Widget? trailing;
  final Widget child;
  final EdgeInsets? padding;
  final double? height;

  const SectionCard({
    super.key,
    this.title,
    this.subtitle,
    this.trailing,
    required this.child,
    this.padding,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDark;
    final cardColor = isDark ? AppColors.darkCard : AppColors.cardBg;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;
    final titleColor = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final subtitleColor = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 16, 12),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title!,
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: titleColor)),
                        if (subtitle != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Text(subtitle!,
                                style: TextStyle(fontSize: 12, color: subtitleColor)),
                          ),
                      ],
                    ),
                  ),
                  if (trailing != null) trailing!,
                ],
              ),
            ),
          Expanded(
            flex: height != null ? 1 : 0,
            child: Padding(
              padding: padding ?? const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}
