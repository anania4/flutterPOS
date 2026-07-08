import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class DataTableCard extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final List<String> columns;
  final List<List<Widget>> rows;
  final List<Widget>? headerActions;
  final Widget? footer;

  const DataTableCard({
    super.key,
    this.title,
    this.subtitle,
    required this.columns,
    required this.rows,
    this.headerActions,
    this.footer,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkCard : AppColors.white;
    final border = isDark ? AppColors.darkBorder : AppColors.border;
    final headerBg = isDark ? AppColors.darkSurface : const Color(0xFFF9FAFB);

    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 16, 16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title!, style: Theme.of(context).textTheme.titleLarge),
                        if (subtitle != null)
                          Text(subtitle!, style: Theme.of(context).textTheme.bodySmall),
                      ],
                    ),
                  ),
                  if (headerActions != null) ...headerActions!,
                ],
              ),
            ),
          if (title != null) Divider(height: 1, color: border),
          // Column headers
          Container(
            color: headerBg,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              children: columns.asMap().entries.map((e) {
                return Expanded(
                  child: Text(e.value.toUpperCase(),
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700,
                      color: AppColors.textSecondary, letterSpacing: 0.5),
                  ),
                );
              }).toList(),
            ),
          ),
          Divider(height: 1, color: border),
          // Rows
          ...rows.asMap().entries.map((e) {
            final isLast = e.key == rows.length - 1;
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  child: Row(
                    children: e.value.map((cell) => Expanded(child: cell)).toList(),
                  ),
                ),
                if (!isLast) Divider(height: 1, color: border),
              ],
            );
          }),
          if (footer != null) ...[
            Divider(height: 1, color: border),
            footer!,
          ],
        ],
      ),
    );
  }
}
