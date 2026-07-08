import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_provider.dart';
import '../../../shared/widgets/section_card.dart';
import '../../../shared/widgets/status_badge.dart';

class _Order {
  final String id;
  final String customer;
  final String initials;
  final String type;
  final String status;
  final String total;
  const _Order(this.id, this.customer, this.initials, this.type, this.status, this.total);
}

class RecentOrdersTable extends StatelessWidget {
  const RecentOrdersTable({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDark;
    final headerColor = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
    final textColor = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final headerBg = isDark ? AppColors.darkBackground : const Color(0xFFF8F9FC);
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;

    final orders = [
      const _Order('#9832', 'Jane Doe', 'JD', 'Dine-In', 'READY', '\$32.50'),
      const _Order('#9831', 'Mark Smith', 'MS', 'Delivery', 'PREPARING', '\$18.90'),
      const _Order('#9830', 'Alice Lee', 'AL', 'Dine-In', 'DELIVERED', '\$45.00'),
      const _Order('#9829', 'Tom Nguyen', 'TN', 'Takeaway', 'PENDING', '\$12.60'),
    ];

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 16, 12),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Recent Orders', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: textColor)),
                      Text('Overview of latest transactions across the branch.',
                          style: TextStyle(fontSize: 12, color: headerColor)),
                    ],
                  ),
                ),
                Icon(Icons.filter_list_rounded, size: 18, color: headerColor),
              ],
            ),
          ),
          // Header
          Container(
            color: headerBg,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: ['ID', 'CUSTOMER', 'TYPE', 'STATUS', 'TOTAL', 'ACTION']
                  .map((h) => Expanded(
                        child: Text(h,
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700,
                                color: headerColor, letterSpacing: 0.5)),
                      ))
                  .toList(),
            ),
          ),
          ...orders.map((o) => _OrderRow(order: o, isDark: isDark, textColor: textColor)),
          Divider(height: 1, color: borderColor),
          TextButton(
            onPressed: () {},
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text('View All Transactions', style: TextStyle(color: AppColors.primary, fontSize: 13)),
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderRow extends StatelessWidget {
  final _Order order;
  final bool isDark;
  final Color textColor;
  const _OrderRow({required this.order, required this.isDark, required this.textColor});

  @override
  Widget build(BuildContext context) {
    final borderColor = isDark ? AppColors.darkBorder : AppColors.divider;
    return Column(
      children: [
        Divider(height: 1, color: borderColor),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
          child: Row(
            children: [
              Expanded(child: Text(order.id, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: textColor))),
              Expanded(
                child: Row(
                  children: [
                    CircleAvatar(radius: 14, backgroundColor: AppColors.primarySurface,
                        child: Text(order.initials, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.primary))),
                    const SizedBox(width: 8),
                    Text(order.customer, style: TextStyle(fontSize: 13, color: textColor)),
                  ],
                ),
              ),
              Expanded(child: Text(order.type, style: TextStyle(fontSize: 13, color: textColor))),
              Expanded(child: StatusBadge.fromStatus(order.status)),
              Expanded(child: Text(order.total, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: textColor))),
              IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert_rounded, size: 16), color: AppColors.textSecondary),
            ],
          ),
        ),
      ],
    );
  }
}
