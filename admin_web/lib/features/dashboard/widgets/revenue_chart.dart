import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_provider.dart';
import '../../../shared/widgets/section_card.dart';

class RevenueChart extends StatelessWidget {
  const RevenueChart({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDark;
    final labelColor = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    final revenueData = [320.0, 420.0, 390.0, 510.0, 580.0, 460.0, 430.0, 380.0, 290.0, 320.0, 280.0, 240.0];
    final ordersData = [180.0, 240.0, 210.0, 280.0, 320.0, 260.0, 240.0, 220.0, 160.0, 190.0, 170.0, 140.0];

    return SectionCard(
      title: 'Revenue vs Orders',
      subtitle: 'Comparison of volume and value across service hours.',
      trailing: Row(
        children: [
          _Legend(color: AppColors.primary, label: 'Revenue'),
          const SizedBox(width: 12),
          _Legend(color: AppColors.chart2, label: 'Orders'),
        ],
      ),
      height: 320,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: 650,
          barTouchData: BarTouchData(enabled: true),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (v, _) {
                  const hours = ['6', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16', '17'];
                  final idx = v.toInt();
                  if (idx < 0 || idx >= hours.length) return const SizedBox();
                  return Text(hours[idx], style: TextStyle(fontSize: 10, color: labelColor));
                },
                reservedSize: 22,
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 44,
                getTitlesWidget: (v, _) => Text('\$${v.toInt()}',
                    style: TextStyle(fontSize: 9, color: labelColor)),
              ),
            ),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (_) => FlLine(
              color: isDark ? AppColors.darkBorder : AppColors.divider,
              strokeWidth: 1,
            ),
          ),
          borderData: FlBorderData(show: false),
          barGroups: List.generate(revenueData.length, (i) {
            return BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: revenueData[i],
                  color: AppColors.primary,
                  width: 10,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                ),
                BarChartRodData(
                  toY: ordersData[i],
                  color: AppColors.chart2,
                  width: 10,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  final Color color;
  final String label;
  const _Legend({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
      ],
    );
  }
}
