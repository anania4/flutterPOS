import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/app_badge.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/stat_card.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});
  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  String _period = 'Last 30 Days';

  final _branches = const [
    ('Downtown Roastery', '82nd St. Plaza', '\$42,150.00', '2,240', '4.2 min', '+14%', true),
    ('Westside Hub', 'Tech District', '\$38,200.50', '1,980', '3.8 min', '+6%', true),
    ('The Heights Bakery', 'North Ave', '\$24,900.00', '1,150', '5.1 min', '-2%', false),
  ];

  final _topSellers = const [
    ('Oat Milk Latte', 2482, 0.92),
    ('Matcha Ceremonial', 1920, 0.75),
    ('Everything Bagel', 1450, 0.58),
    ('Cold Brew', 1120, 0.44),
    ('Avocado Toast', 940, 0.37),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Text('Reports & Analytics', style: Theme.of(context).textTheme.headlineLarge),
            const Spacer(),
            AppButton(label: '↑ Export PDF', onPressed: () {}, small: true),
            const SizedBox(width: 10),
            IconButton(icon: const Icon(Icons.tune, color: AppColors.textSecondary), onPressed: () {}),
          ]),
          const SizedBox(height: 16),
          // Period filter
          Row(children: [
            ...['Last 30 Days', 'Last 90 Days', 'Year to Date'].map((p) => Padding(
              padding: const EdgeInsets.only(right: 8),
              child: _PeriodBtn(label: p, active: _period == p,
                onTap: () => setState(() => _period = p)),
            )),
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.calendar_month_outlined, size: 14),
              label: const Text('Custom Range', style: TextStyle(fontSize: 13)),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.textSecondary,
                side: const BorderSide(color: AppColors.border),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ]),
          const SizedBox(height: 20),
          Row(children: [
            Expanded(child: StatCard(title: 'Total Revenue', value: '\$142,580.00',
              badge: '+12.5% ↗', icon: Icons.attach_money_rounded,
              iconBg: AppColors.primarySurface, iconColor: AppColors.primary, subtitle: '')),
            const SizedBox(width: 16),
            Expanded(child: StatCard(title: 'Avg Order Value', value: '\$18.45',
              badge: '+4.2% ↗', icon: Icons.receipt_outlined,
              iconBg: AppColors.successSurface, iconColor: AppColors.success, subtitle: '')),
            const SizedBox(width: 16),
            Expanded(child: StatCard(title: 'Total Transactions', value: '7,728',
              badge: '-1.5% ↘', badgeColor: AppColors.error,
              icon: Icons.swap_horiz_rounded,
              iconBg: AppColors.warningSurface, iconColor: AppColors.warning, subtitle: '')),
            const SizedBox(width: 16),
            Expanded(child: StatCard(title: 'Customer Retention', value: '64.2%',
              badge: '+8.9% ↗', icon: Icons.favorite_outline,
              iconBg: AppColors.infoSurface, iconColor: AppColors.info, subtitle: '')),
          ]),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 3, child: _SalesTrendsChart(isDark: isDark)),
              const SizedBox(width: 20),
              Expanded(flex: 2, child: _TopSellersCard(sellers: _topSellers, isDark: isDark)),
            ],
          ),
          const SizedBox(height: 20),
          _BranchPerformanceTable(branches: _branches, isDark: isDark),
        ],
      ),
    );
  }
}

class _PeriodBtn extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;
  const _PeriodBtn({required this.label, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      margin: const EdgeInsets.only(right: 4),
      decoration: BoxDecoration(
        color: active ? AppColors.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: active ? AppColors.primary : AppColors.border),
      ),
      child: Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500,
        color: active ? Colors.white : AppColors.textSecondary)),
    ),
  );
}

class _SalesTrendsChart extends StatelessWidget {
  final bool isDark;
  const _SalesTrendsChart({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final data = [22.0, 28.0, 32.0, 52.0, 35.0, 38.0, 42.0];
    final prevData = [18.0, 22.0, 25.0, 38.0, 30.0, 32.0, 35.0];
    const days = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];
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
          Row(children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Sales Trends', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
              const Text('Daily gross revenue comparison', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
            ]),
            const Spacer(),
            _Dot(color: AppColors.primary, label: 'This Period'),
            const SizedBox(width: 12),
            _Dot(color: AppColors.chartPrev, label: 'Previous'),
          ]),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: BarChart(BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: 60,
              barTouchData: BarTouchData(enabled: true),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(sideTitles: SideTitles(
                  showTitles: true, reservedSize: 28,
                  getTitlesWidget: (v, _) {
                    if (v.toInt() < days.length)
                      return Padding(padding: const EdgeInsets.only(top: 6),
                        child: Text(days[v.toInt()], style: const TextStyle(fontSize: 10, color: AppColors.textTertiary)));
                    return const SizedBox();
                  },
                )),
                leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              gridData: FlGridData(
                show: true, drawVerticalLine: false,
                getDrawingHorizontalLine: (_) => const FlLine(color: AppColors.border, strokeWidth: 1),
              ),
              borderData: FlBorderData(show: false),
              barGroups: data.asMap().entries.map((e) => BarChartGroupData(
                x: e.key,
                barRods: [
                  BarChartRodData(toY: prevData[e.key], color: AppColors.chartPrev, width: 14,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(4))),
                  BarChartRodData(toY: e.value, color: AppColors.primary, width: 14,
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

class _Dot extends StatelessWidget {
  final Color color;
  final String label;
  const _Dot({required this.color, required this.label});
  @override
  Widget build(BuildContext context) => Row(children: [
    Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
    const SizedBox(width: 4),
    Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
  ]);
}

class _TopSellersCard extends StatelessWidget {
  final List<(String, int, double)> sellers;
  final bool isDark;
  const _TopSellersCard({required this.sellers, required this.isDark});

  @override
  Widget build(BuildContext context) {
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
          const Text('Top Sellers', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
          const Text('Product mix by volume', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
          const SizedBox(height: 20),
          ...sellers.map((s) => Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Expanded(child: Text(s.$1, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textPrimary))),
                Text('${s.$2} units', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              ]),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: s.$3, minHeight: 5,
                  backgroundColor: AppColors.border,
                  valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                ),
              ),
            ]),
          )),
          Center(
            child: TextButton(onPressed: () {},
              child: const Text('View Full Product Mix', style: TextStyle(fontSize: 13, color: AppColors.primary, fontWeight: FontWeight.w600))),
          ),
        ],
      ),
    );
  }
}

class _BranchPerformanceTable extends StatelessWidget {
  final List<(String, String, String, String, String, String, bool)> branches;
  final bool isDark;
  const _BranchPerformanceTable({required this.branches, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final bg = isDark ? AppColors.darkCard : AppColors.white;
    final border = isDark ? AppColors.darkBorder : AppColors.border;
    return Container(
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12), border: Border.all(color: border)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 16, 16),
            child: Row(children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Branch Performance', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                const Text('Real-time metrics across all locations', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              ])),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(border: Border.all(color: border), borderRadius: BorderRadius.circular(8)),
                child: Row(children: const [
                  Text('Sort by: Revenue', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                  SizedBox(width: 4),
                  Icon(Icons.keyboard_arrow_down, size: 14, color: AppColors.textSecondary),
                ]),
              ),
            ]),
          ),
          Divider(height: 1, color: border),
          Container(
            color: isDark ? AppColors.darkSurface : const Color(0xFFF9FAFB),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: const Row(children: [
              Expanded(flex: 3, child: _H('LOCATION')),
              Expanded(flex: 2, child: _H('NET SALES')),
              Expanded(flex: 1, child: _H('ORDERS')),
              Expanded(flex: 2, child: _H('AVG PREP TIME')),
              Expanded(flex: 1, child: _H('TREND')),
              SizedBox(width: 40, child: _H('ACTIONS')),
            ]),
          ),
          Divider(height: 1, color: border),
          ...branches.map((b) => Column(children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Row(children: [
                Expanded(flex: 3, child: Row(children: [
                  Container(width: 36, height: 36,
                    decoration: BoxDecoration(color: AppColors.primarySurface, borderRadius: BorderRadius.circular(8)),
                    child: const Icon(Icons.coffee_rounded, size: 18, color: AppColors.primary)),
                  const SizedBox(width: 10),
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(b.$1, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                    Text(b.$2, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                  ]),
                ])),
                Expanded(flex: 2, child: Text(b.$3, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimary))),
                Expanded(flex: 1, child: Text(b.$4, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary))),
                Expanded(flex: 2, child: Text(b.$5, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary))),
                Expanded(flex: 1, child: Text(b.$6,
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700,
                    color: b.$7 ? AppColors.success : AppColors.error))),
                SizedBox(width: 40, child: TextButton(onPressed: () {},
                  child: const Text('•••', style: TextStyle(fontSize: 16, color: AppColors.textSecondary)))),
              ]),
            ),
            if (b != branches.last) Divider(height: 1, color: border),
          ])),
        ],
      ),
    );
  }
}

class _H extends StatelessWidget {
  final String text;
  const _H(this.text);
  @override
  Widget build(BuildContext context) => Text(text,
    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700,
      color: AppColors.textSecondary, letterSpacing: 0.5));
}
