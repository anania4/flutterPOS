import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/theme_provider.dart';

class AppDataTable extends StatelessWidget {
  final List<String> columns;
  final List<List<Widget>> rows;
  final List<double>? columnWidths;

  const AppDataTable({
    super.key,
    required this.columns,
    required this.rows,
    this.columnWidths,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDark;
    final headerBg = isDark ? AppColors.darkBackground : const Color(0xFFF8F9FC);
    final rowDivider = isDark ? AppColors.darkBorder : AppColors.divider;
    final headerColor = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
    final cellColor = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;

    return Column(
      children: [
        // Header
        Container(
          decoration: BoxDecoration(
            color: headerBg,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
          ),
          child: _buildRow(columns.map((c) => Text(c.toUpperCase(),
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700,
                  color: headerColor, letterSpacing: 0.5))).toList(), isHeader: true),
        ),
        // Rows
        ...rows.asMap().entries.map((entry) {
          return Column(
            children: [
              Divider(height: 1, thickness: 1, color: rowDivider),
              _buildRow(entry.value, isHeader: false),
            ],
          );
        }),
      ],
    );
  }

  Widget _buildRow(List<Widget> cells, {required bool isHeader}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: cells.asMap().entries.map((e) {
          final flex = columnWidths != null ? null : 1;
          final width = columnWidths != null ? columnWidths![e.key] : null;
          return width != null
              ? SizedBox(width: width, child: e.value)
              : Expanded(flex: flex ?? 1, child: e.value);
        }).toList(),
      ),
    );
  }
}
