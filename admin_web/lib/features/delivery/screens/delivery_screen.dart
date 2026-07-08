import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/stat_card.dart';
import '../../../shared/widgets/app_badge.dart';

class _DeliveryOrder {
  final String id, customer, address, driver, status, eta, total, platform;
  const _DeliveryOrder(this.id, this.customer, this.address, this.driver, this.status, this.eta, this.total, this.platform);
}

const _deliveries = [
  _DeliveryOrder('#DD-8821', 'Sarah Jenkins', '122 Park Ave, NY', 'Marco R.', 'In Transit', '12 min', '\$32.50', 'DoorDash'),
  _DeliveryOrder('#UE-8820', 'Michael Ross', '45 Broadway, NY', 'Lisa K.', 'Picked Up', '20 min', '\$18.90', 'UberEats'),
  _DeliveryOrder('#DD-8819', 'Emily Carter', '77 5th Ave, NY', 'James W.', 'Preparing', '35 min', '\$45.00', 'DoorDash'),
  _DeliveryOrder('#UE-8818', 'Tom Adams', '33 W 14th St, NY', 'Unassigned', 'Pending', '—', '\$22.00', 'UberEats'),
];

BadgeType _statusType(String s) {
  switch (s) {
    case 'In Transit': return BadgeType.info;
    case 'Picked Up': return BadgeType.primary;
    case 'Preparing': return BadgeType.warning;
    case 'Delivered': return BadgeType.success;
    default: return BadgeType.neutral;
  }
}

class DeliveryScreen extends StatelessWidget {
  const DeliveryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: 'Delivery Management',
            subtitle: 'Track all active deliveries across platforms in real-time.',
            actions: [
              AppButton(label: 'Assign Driver', icon: Icons.person_add_outlined, style: AppButtonStyle.outlined, small: true, onPressed: () {}),
              const SizedBox(width: 10),
              AppButton(label: '+ New Delivery', onPressed: () {}, small: true),
            ],
          ),
          const SizedBox(height: 20),
          Row(children: [
            Expanded(child: StatCard(title: 'Active Deliveries', value: '14',
              badge: 'LIVE', badgeColor: AppColors.error,
              icon: Icons.delivery_dining_rounded,
              iconBg: AppColors.primarySurface, iconColor: AppColors.primary, subtitle: '8 DoorDash • 6 UberEats')),
            const SizedBox(width: 16),
            Expanded(child: StatCard(title: 'Avg. Delivery Time', value: '24 min',
              badge: '-3 min vs yesterday',
              icon: Icons.timer_outlined,
              iconBg: AppColors.successSurface, iconColor: AppColors.success, subtitle: '')),
            const SizedBox(width: 16),
            Expanded(child: StatCard(title: 'Drivers On Road', value: '6',
              icon: Icons.drive_eta_rounded,
              iconBg: AppColors.infoSurface, iconColor: AppColors.info, subtitle: '2 available')),
            const SizedBox(width: 16),
            Expanded(child: StatCard(title: 'Delivery Revenue', value: '\$840.50',
              badge: '+18%',
              icon: Icons.attach_money_rounded,
              iconBg: AppColors.warningSurface, iconColor: AppColors.warning, subtitle: 'Today')),
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
                    const Text('Active Deliveries', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                    const Spacer(),
                    AppButton(label: 'All Platforms', icon: Icons.keyboard_arrow_down,
                      style: AppButtonStyle.outlined, small: true, onPressed: () {}),
                  ]),
                ),
                Divider(height: 1, color: isDark ? AppColors.darkBorder : AppColors.border),
                Container(
                  color: isDark ? AppColors.darkSurface : const Color(0xFFF9FAFB),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: const Row(children: [
                    Expanded(flex: 1, child: _H('ORDER ID')),
                    Expanded(flex: 2, child: _H('CUSTOMER')),
                    Expanded(flex: 3, child: _H('ADDRESS')),
                    Expanded(flex: 2, child: _H('DRIVER')),
                    Expanded(flex: 1, child: _H('PLATFORM')),
                    Expanded(flex: 1, child: _H('STATUS')),
                    Expanded(flex: 1, child: _H('ETA')),
                    Expanded(flex: 1, child: _H('TOTAL')),
                    SizedBox(width: 40, child: _H('ACTIONS')),
                  ]),
                ),
                Divider(height: 1, color: isDark ? AppColors.darkBorder : AppColors.border),
                ..._deliveries.map((d) => Column(children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    child: Row(children: [
                      Expanded(flex: 1, child: Text(d.id, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary))),
                      Expanded(flex: 2, child: Text(d.customer, style: const TextStyle(fontSize: 13, color: AppColors.textPrimary))),
                      Expanded(flex: 3, child: Text(d.address, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary), overflow: TextOverflow.ellipsis)),
                      Expanded(flex: 2, child: d.driver == 'Unassigned'
                          ? const Text('Unassigned', style: TextStyle(fontSize: 12, color: AppColors.error))
                          : Row(children: [
                              CircleAvatar(radius: 12, backgroundColor: AppColors.primarySurface,
                                child: Text(d.driver[0], style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: AppColors.primary))),
                              const SizedBox(width: 6),
                              Text(d.driver, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                            ])),
                      Expanded(flex: 1, child: _PlatformIcon(d.platform)),
                      Expanded(flex: 1, child: AppBadge(label: d.status, type: _statusType(d.status))),
                      Expanded(flex: 1, child: Text(d.eta, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary))),
                      Expanded(flex: 1, child: Text(d.total, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimary))),
                      SizedBox(width: 40, child: IconButton(icon: const Icon(Icons.more_vert, size: 16, color: AppColors.textSecondary), onPressed: () {})),
                    ]),
                  ),
                  if (d != _deliveries.last) Divider(height: 1, color: isDark ? AppColors.darkBorder : AppColors.border),
                ])),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PlatformIcon extends StatelessWidget {
  final String platform;
  const _PlatformIcon(this.platform);

  @override
  Widget build(BuildContext context) => Row(children: [
    Icon(Icons.delivery_dining, size: 14,
      color: platform == 'DoorDash' ? AppColors.error : AppColors.success),
    const SizedBox(width: 4),
    Text(platform, style: TextStyle(fontSize: 11,
      color: platform == 'DoorDash' ? AppColors.error : AppColors.success, fontWeight: FontWeight.w500)),
  ]);
}

class _H extends StatelessWidget {
  final String text;
  const _H(this.text);
  @override
  Widget build(BuildContext context) => Text(text,
    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.textSecondary, letterSpacing: 0.5));
}
