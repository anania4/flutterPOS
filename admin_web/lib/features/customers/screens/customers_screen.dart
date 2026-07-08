import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/stat_card.dart';
import '../../../shared/widgets/app_badge.dart';

class _Customer {
  final String name, initials, email, phone, tier, lastVisit, totalSpend, visits;
  const _Customer(this.name, this.initials, this.email, this.phone, this.tier, this.lastVisit, this.totalSpend, this.visits);
}

const _customers = [
  _Customer('Sarah Jenkins', 'SJ', 'sarah.j@email.com', '+1 555-0101', 'Gold', '2 days ago', '\$1,240.00', '48'),
  _Customer('Michael Ross', 'MR', 'mross@email.com', '+1 555-0102', 'Silver', '5 days ago', '\$680.50', '22'),
  _Customer('Emma Watson', 'EW', 'emma.w@email.com', '+1 555-0103', 'Platinum', 'Today', '\$3,890.00', '127'),
  _Customer('John Kim', 'JK', 'jkim@email.com', '+1 555-0104', 'Bronze', '2 weeks ago', '\$145.00', '6'),
  _Customer('Priya Patel', 'PP', 'priya.p@email.com', '+1 555-0105', 'Gold', 'Yesterday', '\$2,110.00', '75'),
];

BadgeType _tierType(String t) {
  switch (t) {
    case 'Platinum': return BadgeType.primary;
    case 'Gold': return BadgeType.warning;
    case 'Silver': return BadgeType.neutral;
    default: return BadgeType.neutral;
  }
}

class CustomersScreen extends StatelessWidget {
  const CustomersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: 'Customer Management',
            subtitle: 'Track customer profiles, loyalty, and purchase history.',
            actions: [
              AppButton(label: 'Export', icon: Icons.upload_rounded, style: AppButtonStyle.outlined, small: true, onPressed: () {}),
              const SizedBox(width: 10),
              AppButton(label: '+ Add Customer', onPressed: () {}, small: true),
            ],
          ),
          const SizedBox(height: 20),
          Row(children: [
            Expanded(child: StatCard(title: 'Total Customers', value: '3,842',
              badge: '+124 this month', icon: Icons.people_alt_outlined,
              iconBg: AppColors.primarySurface, iconColor: AppColors.primary, subtitle: '')),
            const SizedBox(width: 16),
            Expanded(child: StatCard(title: 'Loyalty Members', value: '1,204',
              badge: '31.3%', icon: Icons.card_membership_outlined,
              iconBg: AppColors.warningSurface, iconColor: AppColors.warning, subtitle: '')),
            const SizedBox(width: 16),
            Expanded(child: StatCard(title: 'Avg. Lifetime Value', value: '\$486',
              icon: Icons.trending_up_rounded,
              iconBg: AppColors.successSurface, iconColor: AppColors.success, subtitle: '')),
            const SizedBox(width: 16),
            Expanded(child: StatCard(title: 'Churn Rate', value: '4.2%',
              badge: '-1.1%', icon: Icons.person_remove_outlined,
              iconBg: AppColors.infoSurface, iconColor: AppColors.info, subtitle: '')),
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
                  padding: const EdgeInsets.all(16),
                  child: Row(children: [
                    const Text('All Customers', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                    const Spacer(),
                    SizedBox(width: 280, child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search customers...',
                        prefixIcon: const Icon(Icons.search, size: 16, color: AppColors.textTertiary),
                        contentPadding: const EdgeInsets.symmetric(vertical: 0),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.border)),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.border)),
                      ),
                    )),
                  ]),
                ),
                Divider(height: 1, color: isDark ? AppColors.darkBorder : AppColors.border),
                Container(
                  color: isDark ? AppColors.darkSurface : const Color(0xFFF9FAFB),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: const Row(children: [
                    Expanded(flex: 3, child: _H('CUSTOMER')),
                    Expanded(flex: 2, child: _H('CONTACT')),
                    Expanded(flex: 1, child: _H('TIER')),
                    Expanded(flex: 2, child: _H('LAST VISIT')),
                    Expanded(flex: 2, child: _H('TOTAL SPEND')),
                    Expanded(flex: 1, child: _H('VISITS')),
                    SizedBox(width: 40, child: _H('ACTIONS')),
                  ]),
                ),
                Divider(height: 1, color: isDark ? AppColors.darkBorder : AppColors.border),
                ..._customers.map((c) => Column(children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    child: Row(children: [
                      Expanded(flex: 3, child: Row(children: [
                        CircleAvatar(radius: 18, backgroundColor: AppColors.primarySurface,
                          child: Text(c.initials, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary))),
                        const SizedBox(width: 10),
                        Text(c.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                      ])),
                      Expanded(flex: 2, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(c.email, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                        Text(c.phone, style: const TextStyle(fontSize: 11, color: AppColors.textTertiary)),
                      ])),
                      Expanded(flex: 1, child: AppBadge(label: c.tier, type: _tierType(c.tier))),
                      Expanded(flex: 2, child: Text(c.lastVisit, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary))),
                      Expanded(flex: 2, child: Text(c.totalSpend, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimary))),
                      Expanded(flex: 1, child: Text(c.visits, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary))),
                      SizedBox(width: 40, child: IconButton(icon: const Icon(Icons.more_vert, size: 16, color: AppColors.textSecondary), onPressed: () {})),
                    ]),
                  ),
                  if (c != _customers.last) Divider(height: 1, color: isDark ? AppColors.darkBorder : AppColors.border),
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
