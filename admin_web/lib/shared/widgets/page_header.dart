import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/theme_provider.dart';

class PageHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final List<Widget>? actions;
  final List<Widget>? breadcrumbs;

  const PageHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.actions,
    this.breadcrumbs,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDark;
    final titleColor = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final subtitleColor = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (breadcrumbs != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              children: breadcrumbs!
                  .expand((w) => [w, const Text(' > ', style: TextStyle(color: AppColors.textMuted, fontSize: 12))])
                  .take(breadcrumbs!.length * 2 - 1)
                  .toList(),
            ),
          ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(
                          fontSize: 24, fontWeight: FontWeight.w700, color: titleColor)),
                  if (subtitle != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(subtitle!,
                          style: TextStyle(fontSize: 13, color: subtitleColor)),
                    ),
                ],
              ),
            ),
            if (actions != null)
              Row(children: actions!.expand((w) => [w, const SizedBox(width: 10)]).take(actions!.length * 2 - 1).toList()),
          ],
        ),
      ],
    );
  }
}
