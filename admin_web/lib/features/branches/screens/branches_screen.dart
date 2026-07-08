import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/app_badge.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/stat_card.dart';

class _Branch {
  final String name, address, manager, managerInitials, status, revenue;
  const _Branch(this.name, this.address, this.manager, this.managerInitials, this.status, this.revenue);
}

const _branches = [
  _Branch('Central Park North', '122 W 110th St, NY', 'Marcus King', 'MK', 'OPEN', '\$4,821.50'),
  _Branch('Chelsea Market', '75 9th Ave, NY', 'Elena Lopez', 'EL', 'OPEN', '\$3,210.00'),
  _Branch('SoHo Hub', '450 Broadway, NY', 'James Wu', 'JW', 'MAINTENANCE', '\$0.00'),
  _Branch('Upper West Side', '2109 Broadway, NY', 'Sarah T.', 'ST', 'OPEN', '\$5,520.15'),
  _Branch('DUMBO', 'Water Street, NY', 'Rob K.', 'RK', 'OPEN', '\$2,850.00'),
];

class BranchesScreen extends StatelessWidget {
  const BranchesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Breadcrumb
          Text('Organization / Branches',
            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
          const SizedBox(height: 8),
          SectionHeader(
            title: 'Branch Management',
            actions: [
              AppButton(label: 'Export', icon: Icons.upload_rounded, style: AppButtonStyle.outlined, small: true, onPressed: () {}),
              const SizedBox(width: 10),
              AppButton(label: '+ Add New Branch', onPressed: () {}, small: true),
            ],
          ),
          const SizedBox(height: 20),
          Row(children: [
            Expanded(child: StatCard(title: 'Active Branches', value: '12',
              badge: '+2 this yr', icon: Icons.store_rounded,
              iconBg: AppColors.primarySurface, iconColor: AppColors.primary, subtitle: '')),
            const SizedBox(width: 16),
            Expanded(child: StatCard(title: 'Total Revenue (Today)', value: '\$24,850',
              badge: '↑12%', icon: Icons.attach_money_rounded,
              iconBg: AppColors.successSurface, iconColor: AppColors.success, subtitle: '')),
            const SizedBox(width: 16),
            Expanded(child: StatCard(title: 'Avg. Ticket Size', value: '\$18.42',
              badge: 'Steady', badgeColor: AppColors.textSecondary,
              icon: Icons.confirmation_number_outlined,
              iconBg: AppColors.infoSurface, iconColor: AppColors.info, subtitle: '')),
          ]),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 3, child: _BranchTable(branches: _branches, isDark: isDark)),
              const SizedBox(width: 20),
              Expanded(flex: 2, child: _MapCard(isDark: isDark)),
            ],
          ),
        ],
      ),
    );
  }
}

class _BranchTable extends StatelessWidget {
  final List<_Branch> branches;
  final bool isDark;
  const _BranchTable({required this.branches, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final bg = isDark ? AppColors.darkCard : AppColors.white;
    final border = isDark ? AppColors.darkBorder : AppColors.border;
    final headerBg = isDark ? AppColors.darkSurface : const Color(0xFFF9FAFB);

    return Container(
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12), border: Border.all(color: border)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: Row(
              children: [
                Text('All Locations', style: Theme.of(context).textTheme.titleLarge),
                const Spacer(),
                IconButton(icon: const Icon(Icons.filter_list, size: 18, color: AppColors.textSecondary), onPressed: () {}),
                IconButton(icon: const Icon(Icons.more_vert, size: 18, color: AppColors.textSecondary), onPressed: () {}),
              ],
            ),
          ),
          Divider(height: 1, color: border),
          Container(
            color: headerBg,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: const Row(children: [
              Expanded(flex: 3, child: _H('BRANCH NAME')),
              Expanded(flex: 1, child: _H('STATUS')),
              Expanded(flex: 2, child: _H('MANAGER')),
              Expanded(flex: 2, child: _H("TODAY'S REVENUE")),
            ]),
          ),
          Divider(height: 1, color: border),
          ...branches.map((b) => Column(children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Row(children: [
                Expanded(flex: 3, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(b.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                  Text(b.address, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                ])),
                Expanded(flex: 1, child: AppBadge(
                  label: b.status,
                  type: b.status == 'OPEN' ? BadgeType.success
                      : b.status == 'MAINTENANCE' ? BadgeType.warning : BadgeType.error,
                )),
                Expanded(flex: 2, child: Row(children: [
                  CircleAvatar(radius: 14, backgroundColor: AppColors.primarySurface,
                    child: Text(b.managerInitials,
                      style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: AppColors.primary))),
                  const SizedBox(width: 8),
                  Text(b.manager, style: const TextStyle(fontSize: 13, color: AppColors.textPrimary)),
                ])),
                Expanded(flex: 2, child: Text(b.revenue,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary))),
              ]),
            ),
            if (b != branches.last) Divider(height: 1, color: border),
          ])),
        ],
      ),
    );
  }
}

class _MapCard extends StatelessWidget {
  final bool isDark;
  const _MapCard({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 420,
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
              Text('Branch Map', style: Theme.of(context).textTheme.titleLarge),
              const Spacer(),
              AppButton(label: 'Recenter', icon: Icons.my_location, style: AppButtonStyle.outlined, small: true, onPressed: () {}),
            ]),
          ),
          Divider(height: 1, color: isDark ? AppColors.darkBorder : AppColors.border),
          Expanded(
            child: Container(
              color: const Color(0xFF2A3F3A),
              child: Stack(
                children: [
                  // Simulated map background
                  Positioned.fill(
                    child: CustomPaint(painter: _MapPainter()),
                  ),
                  // Map pins
                  ...[
                    const Offset(0.5, 0.3),
                    const Offset(0.35, 0.45),
                    const Offset(0.6, 0.55),
                    const Offset(0.45, 0.65),
                    const Offset(0.7, 0.4),
                  ].map((pos) => Positioned(
                    left: pos.dx * 300 - 12,
                    top: pos.dy * 300 - 12,
                    child: Container(
                      width: 28, height: 28,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: const Icon(Icons.store_rounded, size: 12, color: Colors.white),
                    ),
                  )),
                  // Info overlay
                  Positioned(
                    bottom: 12, left: 12, right: 12,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.primary, borderRadius: BorderRadius.circular(8)),
                      child: Row(children: [
                        const Icon(Icons.navigation_rounded, color: Colors.white, size: 16),
                        const SizedBox(width: 8),
                        const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text('12 Active Sites', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700)),
                          Text('ALL SYSTEMS NORMAL', style: TextStyle(color: Colors.white70, fontSize: 10)),
                        ])),
                        TextButton(onPressed: () {},
                          child: const Text('Recenter', style: TextStyle(color: Colors.white, fontSize: 12))),
                      ]),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0xFF3A5A50)..strokeWidth = 1;
    for (var i = 0; i < 10; i++) {
      canvas.drawLine(Offset(0, size.height * i / 10), Offset(size.width, size.height * i / 10), paint);
      canvas.drawLine(Offset(size.width * i / 10, 0), Offset(size.width * i / 10, size.height), paint);
    }
    final roadPaint = Paint()..color = const Color(0xFF4A7060)..strokeWidth = 3..style = PaintingStyle.stroke;
    canvas.drawLine(const Offset(0, 80), Offset(size.width, 80), roadPaint);
    canvas.drawLine(const Offset(0, 160), Offset(size.width, 160), roadPaint);
    canvas.drawLine(const Offset(80, 0), Offset(80, size.height), roadPaint);
    canvas.drawLine(const Offset(200, 0), Offset(200, size.height), roadPaint);
  }

  @override
  bool shouldRepaint(_) => false;
}

class _H extends StatelessWidget {
  final String text;
  const _H(this.text);
  @override
  Widget build(BuildContext context) => Text(text,
    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700,
      color: AppColors.textSecondary, letterSpacing: 0.5));
}
