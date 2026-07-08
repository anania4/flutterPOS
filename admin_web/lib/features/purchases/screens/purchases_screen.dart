import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/stat_card.dart';
import '../../../shared/widgets/app_badge.dart';

class _PurchaseOrder {
  final String id, supplier, items, date, status, total;
  const _PurchaseOrder(this.id, this.supplier, this.items, this.date, this.status, this.total);
}

const _orders = [
  _PurchaseOrder('PO-2401', 'Global Origin Imports', '5 items', 'Oct 22, 2023', 'Delivered', '\$1,240.00'),
  _PurchaseOrder('PO-2402', 'PurePlant Co.', '3 items', 'Oct 23, 2023', 'In Transit', '\$380.50'),
  _PurchaseOrder('PO-2403', 'Eco-Pack Solutions', '8 items', 'Oct 24, 2023', 'Pending', '\$740.00'),
  _PurchaseOrder('PO-2404', 'Artisan Flavors', '2 items', 'Oct 24, 2023', 'Confirmed', '\$195.00'),
];

BadgeType _statusType(String s) {
  switch (s) {
    case 'Delivered': return BadgeType.success;
    case 'In Transit': return BadgeType.info;
    case 'Pending': return BadgeType.neutral;
    case 'Confirmed': return BadgeType.primary;
    default: return BadgeType.neutral;
  }
}

class PurchasesScreen extends StatelessWidget {
  const PurchasesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: 'Purchase & Supplier Management',
            subtitle: 'Track purchase orders and manage supplier relationships.',
            actions: [
              AppButton(label: 'Add Supplier', icon: Icons.business_outlined, style: AppButtonStyle.outlined, small: true, onPressed: () {}),
              const SizedBox(width: 10),
              AppButton(label: '+ New Purchase Order', onPressed: () {}, small: true),
            ],
          ),
          const SizedBox(height: 20),
          Row(children: [
            Expanded(child: StatCard(title: 'Total Suppliers', value: '18',
              icon: Icons.business_rounded, iconBg: AppColors.primarySurface, iconColor: AppColors.primary, subtitle: '14 active')),
            const SizedBox(width: 16),
            Expanded(child: StatCard(title: 'Monthly Spend', value: '\$12,480',
              badge: '+8.2%', icon: Icons.attach_money_rounded,
              iconBg: AppColors.warningSurface, iconColor: AppColors.warning, subtitle: '')),
            const SizedBox(width: 16),
            Expanded(child: StatCard(title: 'Pending Orders', value: '4',
              icon: Icons.pending_actions_rounded,
              iconBg: AppColors.infoSurface, iconColor: AppColors.info, subtitle: 'Awaiting confirmation')),
            const SizedBox(width: 16),
            Expanded(child: StatCard(title: 'Low Stock Items', value: '8',
              isAlert: true, subtitle: 'Need reordering')),
          ]),
          const SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCard : AppColors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.border),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 16, 16),
                  child: Row(children: [
                    const Text('Purchase Orders', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                    const Spacer(),
                    AppButton(label: 'All Suppliers', icon: Icons.keyboard_arrow_down,
                      style: AppButtonStyle.outlined, small: true, onPressed: () {}),
                  ]),
                ),
                Divider(height: 1, color: isDark ? AppColors.darkBorder : AppColors.border),
                Container(
                  color: isDark ? AppColors.darkSurface : const Color(0xFFF9FAFB),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: const Row(children: [
                    Expanded(flex: 1, child: _H('PO NUMBER')),
                    Expanded(flex: 2, child: _H('SUPPLIER')),
                    Expanded(flex: 1, child: _H('ITEMS')),
                    Expanded(flex: 2, child: _H('ORDER DATE')),
                    Expanded(flex: 1, child: _H('STATUS')),
                    Expanded(flex: 1, child: _H('TOTAL')),
                    SizedBox(width: 80, child: _H('ACTIONS')),
                  ]),
                ),
                Divider(height: 1, color: isDark ? AppColors.darkBorder : AppColors.border),
                ..._orders.map((o) => Column(children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    child: Row(children: [
                      Expanded(flex: 1, child: Text(o.id, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primary))),
                      Expanded(flex: 2, child: Row(children: [
                        Container(width: 28, height: 28,
                          decoration: BoxDecoration(color: AppColors.primarySurface, borderRadius: BorderRadius.circular(6)),
                          child: const Icon(Icons.business_rounded, size: 14, color: AppColors.primary)),
                        const SizedBox(width: 8),
                        Text(o.supplier, style: const TextStyle(fontSize: 13, color: AppColors.textPrimary)),
                      ])),
                      Expanded(flex: 1, child: Text(o.items, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary))),
                      Expanded(flex: 2, child: Text(o.date, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary))),
                      Expanded(flex: 1, child: AppBadge(label: o.status, type: _statusType(o.status))),
                      Expanded(flex: 1, child: Text(o.total, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimary))),
                      SizedBox(width: 80, child: Row(children: [
                        TextButton(onPressed: () {}, child: const Text('View', style: TextStyle(fontSize: 12, color: AppColors.primary))),
                        IconButton(icon: const Icon(Icons.more_vert, size: 16, color: AppColors.textSecondary), onPressed: () {}),
                      ])),
                    ]),
                  ),
                  if (o != _orders.last) Divider(height: 1, color: isDark ? AppColors.darkBorder : AppColors.border),
                ])),
              ],
            ),
          ),
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
    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.textSecondary, letterSpacing: 0.5));
}
