import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/app_badge.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/stat_card.dart';

class _Employee {
  final String name, id, role, branch, contact, shiftStatus;
  const _Employee(this.name, this.id, this.role, this.branch, this.shiftStatus, this.contact);
}

const _employees = [
  _Employee('Marcus Thorne', 'EMP-00421', 'MANAGER', 'Downtown Branch', 'Active Now', 'm.thorne@artisanbrew.com'),
  _Employee('Elena Rodriguez', 'EMP-00435', 'CHEF', 'Westside Branch', 'Off-Shift', 'e.rodriguez@artisanbrew.com'),
  _Employee('Jamie Liao', 'EMP-00462', 'CASHIER', 'Downtown Branch', 'Active Now', 'j.liao@artisanbrew.com'),
  _Employee('Samir Amin', 'EMP-00489', 'DRIVER', 'Airport Terminal', 'Break', 's.amin@artisanbrew.com'),
  _Employee('Priya Sharma', 'EMP-00501', 'BARISTA', 'Chelsea Market', 'Active Now', 'p.sharma@artisanbrew.com'),
];

BadgeType _shiftType(String s) {
  if (s == 'Active Now') return BadgeType.success;
  if (s == 'Break') return BadgeType.warning;
  return BadgeType.neutral;
}

Color _roleColor(String r) {
  switch (r) {
    case 'MANAGER': return AppColors.primary;
    case 'CHEF': return AppColors.info;
    case 'CASHIER': return AppColors.success;
    case 'DRIVER': return AppColors.warning;
    default: return AppColors.textSecondary;
  }
}

class StaffScreen extends StatefulWidget {
  const StaffScreen({super.key});
  @override
  State<StaffScreen> createState() => _StaffScreenState();
}

class _StaffScreenState extends State<StaffScreen> with SingleTickerProviderStateMixin {
  late TabController _tab;
  int _page = 1;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() { _tab.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: 'Staff Directory',
            subtitle: 'Manage your team members across all 4 branch locations.',
            actions: [
              AppButton(label: 'Export', icon: Icons.upload_rounded, style: AppButtonStyle.outlined, small: true, onPressed: () {}),
              const SizedBox(width: 10),
              AppButton(label: '+ Add New Staff', icon: Icons.person_add_outlined, onPressed: () {}, small: true),
            ],
          ),
          const SizedBox(height: 20),
          Row(children: [
            Expanded(child: StatCard(title: 'Total Staff', value: '42',
              icon: Icons.people_alt_outlined, iconBg: AppColors.primarySurface, iconColor: AppColors.primary, subtitle: '')),
            const SizedBox(width: 16),
            Expanded(child: StatCard(title: 'On-Shift Now', value: '18',
              icon: Icons.check_circle_outline, iconBg: AppColors.successSurface, iconColor: AppColors.success, subtitle: '')),
            const SizedBox(width: 16),
            Expanded(child: StatCard(title: 'Schedule Gaps', value: '3',
              icon: Icons.schedule, iconBg: const Color(0xFFF3F4F6), iconColor: AppColors.textSecondary, subtitle: '')),
            const SizedBox(width: 16),
            Expanded(child: StatCard(title: 'Upcoming Leave', value: '5',
              icon: Icons.calendar_today_outlined, iconBg: AppColors.infoSurface, iconColor: AppColors.info, subtitle: '')),
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
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: Row(children: [
                    _TabBtn(label: 'Staff List', active: _tab.index == 0, onTap: () => setState(() => _tab.index = 0)),
                    const SizedBox(width: 16),
                    _TabBtn(label: 'Schedules', active: _tab.index == 1, onTap: () => setState(() => _tab.index = 1)),
                    const SizedBox(width: 16),
                    _TabBtn(label: 'Attendance', active: _tab.index == 2, onTap: () => setState(() => _tab.index = 2)),
                  ]),
                ),
                Divider(height: 1, color: isDark ? AppColors.darkBorder : AppColors.border),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search staff by name, ID or role...',
                          prefixIcon: const Icon(Icons.search, size: 16, color: AppColors.textTertiary),
                          contentPadding: const EdgeInsets.symmetric(vertical: 0),
                          fillColor: isDark ? AppColors.darkBackground : AppColors.background,
                          filled: true,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.border)),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.border)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    AppButton(label: 'All Branches', icon: Icons.keyboard_arrow_down,
                      style: AppButtonStyle.outlined, small: true, onPressed: () {}),
                    const SizedBox(width: 8),
                    AppButton(label: 'All Roles', icon: Icons.keyboard_arrow_down,
                      style: AppButtonStyle.outlined, small: true, onPressed: () {}),
                  ]),
                ),
                Divider(height: 1, color: isDark ? AppColors.darkBorder : AppColors.border),
                Container(
                  color: isDark ? AppColors.darkSurface : const Color(0xFFF9FAFB),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: const Row(children: [
                    Expanded(flex: 3, child: _H('EMPLOYEE')),
                    Expanded(flex: 1, child: _H('ROLE')),
                    Expanded(flex: 2, child: _H('BRANCH')),
                    Expanded(flex: 2, child: _H('SHIFT STATUS')),
                    Expanded(flex: 3, child: _H('CONTACT')),
                    SizedBox(width: 40, child: _H('ACTIONS')),
                  ]),
                ),
                Divider(height: 1, color: isDark ? AppColors.darkBorder : AppColors.border),
                ..._employees.map((e) => Column(children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    child: Row(children: [
                      Expanded(flex: 3, child: Row(children: [
                        CircleAvatar(radius: 18, backgroundColor: AppColors.border,
                          child: Text(e.name[0], style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.textPrimary))),
                        const SizedBox(width: 10),
                        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(e.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                          Text(e.id, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                        ]),
                      ])),
                      Expanded(flex: 1, child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: _roleColor(e.role).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: _roleColor(e.role).withOpacity(0.3)),
                        ),
                        child: Text(e.role, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: _roleColor(e.role))),
                      )),
                      Expanded(flex: 2, child: Text(e.branch,
                        style: const TextStyle(fontSize: 13, color: AppColors.textSecondary))),
                      Expanded(flex: 2, child: AppBadge(label: e.shiftStatus, type: _shiftType(e.shiftStatus), dot: true)),
                      Expanded(flex: 3, child: Text(e.contact,
                        style: const TextStyle(fontSize: 11, color: AppColors.textSecondary), overflow: TextOverflow.ellipsis)),
                      SizedBox(width: 40, child: IconButton(
                        icon: const Icon(Icons.more_vert, size: 16, color: AppColors.textSecondary), onPressed: () {})),
                    ]),
                  ),
                  if (e != _employees.last) Divider(height: 1, color: isDark ? AppColors.darkBorder : AppColors.border),
                ])),
                Divider(height: 1, color: isDark ? AppColors.darkBorder : AppColors.border),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(children: [
                    Text('Showing 1–10 of 42 employees',
                      style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                    const Spacer(),
                    ...[1, 2, 3].map((p) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      child: GestureDetector(
                        onTap: () => setState(() => _page = p),
                        child: Container(
                          width: 30, height: 30,
                          decoration: BoxDecoration(
                            color: _page == p ? AppColors.primary : Colors.transparent,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: _page == p ? AppColors.primary : AppColors.border),
                          ),
                          child: Center(child: Text('$p',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600,
                              color: _page == p ? Colors.white : AppColors.textSecondary))),
                        ),
                      ),
                    )),
                    const SizedBox(width: 4),
                    IconButton(icon: const Icon(Icons.chevron_right, size: 18, color: AppColors.textSecondary), onPressed: () {}),
                  ]),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _OptimizationCard()),
              const SizedBox(width: 20),
              Expanded(child: _ShiftDistributionCard(isDark: isDark)),
            ],
          ),
        ],
      ),
    );
  }
}

class _TabBtn extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;
  const _TabBtn({required this.label, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(children: [
        Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600,
          color: active ? AppColors.primary : AppColors.textSecondary)),
        const SizedBox(height: 8),
        if (active) Container(height: 2, width: 60, color: AppColors.primary),
      ]),
    ),
  );
}

class _H extends StatelessWidget {
  final String text;
  const _H(this.text);
  @override
  Widget build(BuildContext context) => Text(text,
    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700,
      color: AppColors.textSecondary, letterSpacing: 0.5));
}

class _OptimizationCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(12)),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: const [
          Icon(Icons.auto_fix_high_rounded, color: Colors.white70, size: 16),
          SizedBox(width: 6),
          Text('Optimization Suggestion',
            style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700)),
        ]),
        const SizedBox(height: 12),
        const Text(
          'Based on peak morning traffic at the Downtown Branch, adding an additional Cashier from 08:00 to 10:00 could reduce wait times by 15%.',
          style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.5),
        ),
        const SizedBox(height: 16),
        OutlinedButton(
          onPressed: () {},
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.white,
            side: const BorderSide(color: Colors.white),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: const Text('Review Schedule', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
        ),
      ],
    ),
  );
}

class _ShiftDistributionCard extends StatelessWidget {
  final bool isDark;
  const _ShiftDistributionCard({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final bg = isDark ? AppColors.darkCard : const Color(0xFFF0F4FA);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.border)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Shift Distribution', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
          const SizedBox(height: 16),
          _ShiftBar('Morning Shift (06:00 - 14:00)', 16, 20),
          const SizedBox(height: 12),
          _ShiftBar('Afternoon Shift (14:00 - 22:00)', 12, 20),
          const SizedBox(height: 12),
          _ShiftBar('Night Shift (22:00 - 06:00)', 4, 8),
        ],
      ),
    );
  }
}

class _ShiftBar extends StatelessWidget {
  final String label;
  final int filled, total;
  const _ShiftBar(this.label, this.filled, this.total);

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(children: [
        Expanded(child: Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary))),
        Text('$filled/$total', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
      ]),
      const SizedBox(height: 6),
      ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: LinearProgressIndicator(
          value: filled / total,
          minHeight: 6,
          backgroundColor: AppColors.border,
          valueColor: const AlwaysStoppedAnimation(AppColors.primary),
        ),
      ),
    ],
  );
}
