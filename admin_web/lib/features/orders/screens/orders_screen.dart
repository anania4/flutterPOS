import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/app_badge.dart';
import '../../../shared/widgets/app_button.dart';

class _Order {
  final String id, customer, initials, items, source, status, time, total;
  const _Order(this.id, this.customer, this.initials, this.items, this.source, this.status, this.time, this.total);
}

const _orders = [
  _Order('#BS-9421', 'Sarah Jenkins', 'SJ', '2x Oat..., 1x Sta...', 'UberEats', 'Preparing', '12m ago', '\$32.50'),
  _Order('#DT-8842', 'Table 14', 'T14', '1x Pour Over, 1x..., 1x...', 'Dine-in', 'Ready', 'Just now', '\$18.25'),
  _Order('#TW-1150', 'Guest #402', 'G4', '4x Flat White, 2x...', 'Takeaway', 'Pending', '4h ago', '\$45.00'),
  _Order('#DD-7721', 'Michael R.', 'MR', '1x Cold Brew, 1x...', 'DoorDash', 'Delivering', '1h ago', '\$24.80'),
  _Order('#BS-9420', 'Emily Carter', 'EC', '2x Latte, 1x Muffin', 'Dine-in', 'Delivered', '2h ago', '\$22.10'),
  _Order('#BS-9419', 'James Wu', 'JW', '1x Cappuccino', 'Takeaway', 'Ready', '35m ago', '\$5.50'),
];

BadgeType _badgeType(String s) {
  switch (s) {
    case 'Ready': return BadgeType.success;
    case 'Preparing': return BadgeType.warning;
    case 'Pending': return BadgeType.neutral;
    case 'Delivering': return BadgeType.info;
    case 'Delivered': return BadgeType.primary;
    default: return BadgeType.neutral;
  }
}

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});
  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  String _filterStatus = 'All Orders';
  static const _statusFilters = ['All Orders', 'Preparing', 'Ready', 'Delivering', 'Pending'];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final filtered = _filterStatus == 'All Orders'
        ? _orders
        : _orders.where((o) => o.status == _filterStatus).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: 'Order Management',
            subtitle: 'Real-time tracking across all service channels.',
            actions: [
              AppButton(label: '+ New POS Order', onPressed: () {}, small: true),
            ],
          ),
          const SizedBox(height: 20),
          // Filters
          Row(
            children: [
              ..._statusFilters.map((f) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: _FilterChip(label: f, active: _filterStatus == f,
                  onTap: () => setState(() => _filterStatus = f)),
              )),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.border),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(children: [
                  const Icon(Icons.calendar_today_outlined, size: 14, color: AppColors.textSecondary),
                  const SizedBox(width: 6),
                  const Text('Today: Oct 24, 2023', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                ]),
              ),
              const SizedBox(width: 10),
              AppButton(label: 'Advanced Filters', icon: Icons.tune, style: AppButtonStyle.outlined, small: true, onPressed: () {}),
            ],
          ),
          const SizedBox(height: 20),
          _buildTable(filtered, isDark),
          const SizedBox(height: 12),
          Row(children: [
            Container(width: 10, height: 10, decoration: const BoxDecoration(color: AppColors.success, shape: BoxShape.circle)),
            const SizedBox(width: 6),
            const Text('Kitchen Link: Online', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
            const Spacer(),
            Text('Showing 1–${filtered.length} of 142 orders today',
              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
          ]),
        ],
      ),
    );
  }

  Widget _buildTable(List<_Order> orders, bool isDark) {
    final bg = isDark ? AppColors.darkCard : AppColors.white;
    final border = isDark ? AppColors.darkBorder : AppColors.border;
    final headerBg = isDark ? AppColors.darkSurface : const Color(0xFFF9FAFB);
    return Container(
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12), border: Border.all(color: border)),
      child: Column(
        children: [
          Container(
            color: headerBg,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: const Row(children: [
              Expanded(flex: 1, child: _ColHead('ORDER ID')),
              Expanded(flex: 2, child: _ColHead('CUSTOMER')),
              Expanded(flex: 2, child: _ColHead('ITEMS & NOTES')),
              Expanded(flex: 1, child: _ColHead('TOTAL')),
              Expanded(flex: 1, child: _ColHead('SOURCE')),
              Expanded(flex: 1, child: _ColHead('STATUS')),
              Expanded(flex: 1, child: _ColHead('TIME')),
              SizedBox(width: 80, child: _ColHead('ACTIONS')),
            ]),
          ),
          Divider(height: 1, color: border),
          ...orders.map((o) => Column(children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Row(children: [
                Expanded(flex: 1, child: Text(o.id,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary))),
                Expanded(flex: 2, child: Row(children: [
                  CircleAvatar(radius: 14, backgroundColor: AppColors.primarySurface,
                    child: Text(o.initials, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: AppColors.primary))),
                  const SizedBox(width: 8),
                  Text(o.customer, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
                ])),
                Expanded(flex: 2, child: Text(o.items,
                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondary), overflow: TextOverflow.ellipsis)),
                Expanded(flex: 1, child: Text(o.total,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimary))),
                Expanded(flex: 1, child: _SourceBadge(o.source)),
                Expanded(flex: 1, child: AppBadge(label: o.status, type: _badgeType(o.status))),
                Expanded(flex: 1, child: Text(o.time,
                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondary))),
                SizedBox(width: 80, child: Row(children: [
                  if (o.status == 'Pending')
                    TextButton(onPressed: () {},
                      child: const Text('Accept', style: TextStyle(fontSize: 11, color: AppColors.success))),
                  IconButton(icon: const Icon(Icons.more_vert, size: 16, color: AppColors.textSecondary), onPressed: () {}),
                ])),
              ]),
            ),
            if (o != orders.last) Divider(height: 1, color: border),
          ])),
        ],
      ),
    );
  }
}

class _ColHead extends StatelessWidget {
  final String text;
  const _ColHead(this.text);
  @override
  Widget build(BuildContext context) => Text(text,
    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700,
      color: AppColors.textSecondary, letterSpacing: 0.5));
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;
  const _FilterChip({required this.label, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
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

class _SourceBadge extends StatelessWidget {
  final String source;
  const _SourceBadge(this.source);

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color color;
    switch (source) {
      case 'UberEats': icon = Icons.delivery_dining; color = AppColors.success; break;
      case 'DoorDash': icon = Icons.delivery_dining; color = AppColors.error; break;
      case 'Dine-in': icon = Icons.restaurant; color = AppColors.primary; break;
      default: icon = Icons.shopping_bag_outlined; color = AppColors.info;
    }
    return Row(children: [
      Icon(icon, size: 14, color: color),
      const SizedBox(width: 4),
      Flexible(child: Text(source, style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w500),
        overflow: TextOverflow.ellipsis)),
    ]);
  }
}
