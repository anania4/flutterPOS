import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/stat_card.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/app_badge.dart';
import '../../../shared/widgets/app_button.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: 'Daily Overview',
            subtitle: 'Real-time performance metrics for Artisan Brew Downtown.',
            actions: [
              AppButton(label: 'Last 24 Hours', icon: Icons.calendar_today_outlined,
                style: AppButtonStyle.outlined, small: true, onPressed: () {}),
              const SizedBox(width: 10),
              AppButton(label: 'Export Report', icon: Icons.upload_rounded,
                small: true, onPressed: () {}),
            ],
          ),
          const SizedBox(height: 24),
          // Stat cards
          Row(
            children: [
              Expanded(child: StatCard(
                title: "Today's Revenue",
                value: '\$4,250.00',
                badge: '+12.5%',
                icon: Icons.attach_money_rounded,
                iconBg: AppColors.primarySurface,
                iconColor: AppColors.primary,
                subtitle: 'vs \$3,782 yesterday',
              )),
              const SizedBox(width: 16),
              Expanded(child: StatCard(
                title: 'Active Orders',
                value: '18',
                badge: 'LIVE',
                badgeColor: AppColors.error,
                icon: Icons.receipt_long_rounded,
                iconBg: AppColors.infoSurface,
                iconColor: AppColors.info,
                subtitle: '9 Preparing • 5 Ready • 4 In Transit',
              )),
              const SizedBox(width: 16),
              Expanded(child: StatCard(
                title: 'Average Ticket',
                value: '\$24.50',
                badge: '+2.1%',
                icon: Icons.confirmation_number_outlined,
                iconBg: AppColors.successSurface,
                iconColor: AppColors.success,
                subtitle: 'vs \$23.90 yesterday',
              )),
              const SizedBox(width: 16),
              Expanded(child: StatCard(
                title: 'Stock Alerts',
                value: '5',
                isAlert: true,
                subtitle: 'Action required: Oat Milk, Espresso Beans',
              )),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 3, child: _RevenueChart()),
              const SizedBox(width: 20),
              Expanded(flex: 2, child: _TopBranchesCard()),
            ],
          ),
          const SizedBox(height: 24),
          _RecentOrdersTable(),
        ],
      ),
    );
  }
}

class _RevenueChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final data = [18.0, 25.0, 22.0, 38.0, 42.0, 35.0, 28.0, 22.0, 18.0, 14.0, 10.0, 8.0];
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Revenue vs Orders', style: Theme.of(context).textTheme.titleLarge),
                Text('Comparison of volume and value across service hours.',
                  style: Theme.of(context).textTheme.bodySmall),
              ]),
              const Spacer(),
              _LegendDot(color: AppColors.primary, label: 'Revenue'),
              const SizedBox(width: 12),
              _LegendDot(color: AppColors.chartPrev, label: 'Orders'),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 200,
            child: BarChart(BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: 50,
              barTouchData: BarTouchData(enabled: true),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: AxisTitles(sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (v, _) {
                    const hours = ['6am','8am','10am','12pm','2pm','4pm','6pm','8pm','10pm','12am','2am','4am'];
                    if (v.toInt() < hours.length)
                      return Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Text(hours[v.toInt()], style: const TextStyle(fontSize: 10, color: AppColors.textTertiary)),
                      );
                    return const SizedBox();
                  },
                  reservedSize: 28,
                )),
                leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                getDrawingHorizontalLine: (_) => FlLine(color: AppColors.border, strokeWidth: 1),
              ),
              borderData: FlBorderData(show: false),
              barGroups: data.asMap().entries.map((e) => BarChartGroupData(
                x: e.key,
                barRods: [
                  BarChartRodData(toY: e.value * 0.6, color: AppColors.chartPrev, width: 12,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(4))),
                  BarChartRodData(toY: e.value, color: AppColors.primary, width: 12,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(4))),
                ],
              )).toList(),
            )),
          ),
        ],
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
      const SizedBox(width: 4),
      Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
    ],
  );
}

class _TopBranchesCard extends StatelessWidget {
  final branches = const [
    ('Downtown Artisan', '\$12,450', 0.85),
    ('East Side Roastery', '\$10,120', 0.72),
    ('West End Hub', '\$8,340', 0.60),
    ('Harbor View Coffee', '\$7,900', 0.57),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Top Performing Branches', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 20),
          ...branches.map((b) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(child: Text(b.$1,
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textPrimary))),
                    Text(b.$2, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: b.$3, minHeight: 6,
                    backgroundColor: AppColors.border,
                    valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                  ),
                ),
              ],
            ),
          )),
          const SizedBox(height: 4),
          Center(
            child: TextButton(
              onPressed: () {},
              child: const Text('View All Branches', style: TextStyle(fontSize: 13, color: AppColors.primary, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }
}

class _RecentOrdersTable extends StatelessWidget {
  final _orders = const [
    ('#9832', 'JD', 'Jane Doe', 'Dine-In', 'READY', '\$32.50'),
    ('#9831', 'MS', 'Mark Smith', 'Delivery', 'PREPARING', '\$18.90'),
    ('#9830', 'AL', 'Alice Lee', 'Dine-In', 'DELIVERED', '\$45.00'),
  ];

  BadgeType _badgeType(String status) {
    switch (status) {
      case 'READY': return BadgeType.success;
      case 'PREPARING': return BadgeType.warning;
      case 'DELIVERED': return BadgeType.neutral;
      default: return BadgeType.neutral;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkCard : AppColors.white;
    final border = isDark ? AppColors.darkBorder : AppColors.border;

    return Container(
      decoration: BoxDecoration(
        color: bg, borderRadius: BorderRadius.circular(12), border: Border.all(color: border)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 16, 16),
            child: Row(
              children: [
                Expanded(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Recent Orders', style: Theme.of(context).textTheme.titleLarge),
                    Text('Overview of latest transactions across the branch.',
                      style: Theme.of(context).textTheme.bodySmall),
                  ],
                )),
                const Icon(Icons.filter_list, size: 20, color: AppColors.textSecondary),
              ],
            ),
          ),
          Divider(height: 1, color: border),
          Container(
            color: isDark ? AppColors.darkSurface : const Color(0xFFF9FAFB),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: const Row(
              children: [
                Expanded(child: Text('ID', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700,
                  color: AppColors.textSecondary, letterSpacing: 0.5))),
                Expanded(flex: 2, child: Text('CUSTOMER', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700,
                  color: AppColors.textSecondary, letterSpacing: 0.5))),
                Expanded(child: Text('TYPE', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700,
                  color: AppColors.textSecondary, letterSpacing: 0.5))),
                Expanded(child: Text('STATUS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700,
                  color: AppColors.textSecondary, letterSpacing: 0.5))),
                Expanded(child: Text('TOTAL', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700,
                  color: AppColors.textSecondary, letterSpacing: 0.5))),
                SizedBox(width: 40, child: Text('ACTION', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700,
                  color: AppColors.textSecondary, letterSpacing: 0.5))),
              ],
            ),
          ),
          Divider(height: 1, color: border),
          ..._orders.map((o) => Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                child: Row(
                  children: [
                    Expanded(child: Text(o.$1, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.primary))),
                    Expanded(flex: 2, child: Row(
                      children: [
                        CircleAvatar(radius: 14, backgroundColor: AppColors.primarySurface,
                          child: Text(o.$2, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.primary))),
                        const SizedBox(width: 8),
                        Text(o.$3, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
                      ],
                    )),
                    Expanded(child: Text(o.$4, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary))),
                    Expanded(child: AppBadge(label: o.$5, type: _badgeType(o.$5))),
                    Expanded(child: Text(o.$6, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimary))),
                    SizedBox(width: 40, child: IconButton(
                      icon: const Icon(Icons.more_vert, size: 18, color: AppColors.textSecondary),
                      onPressed: () {},
                    )),
                  ],
                ),
              ),
              if (o != _orders.last) Divider(height: 1, color: border),
            ],
          )),
          Divider(height: 1, color: border),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: TextButton(
                onPressed: () {},
                child: const Text('View All Transactions',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.primary)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
