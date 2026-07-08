import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_badge.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _bizNameCtrl = TextEditingController(text: 'Artisan Brew Co. Ltd');
  final _addressCtrl = TextEditingController(text: '42 Espresso Lane, Roastery District, Seattle, WA 98101');
  String _sector = 'Specialty Coffee & Bakery';
  Color _brandColor = const Color(0xFF006C49);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Global Settings', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
          const SizedBox(height: 4),
          const Text('Configure your SaaS instance, white-labeling, and financial parameters.',
            style: TextStyle(fontSize: 14, color: AppColors.textSecondary)),
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left: Business Profile + Roles
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    _SectionCard(
                      icon: Icons.business_rounded,
                      title: 'Business Profile',
                      isDark: isDark,
                      child: Column(
                        children: [
                          Row(children: [
                            Expanded(child: _LabeledField(label: 'Legal Business Name', controller: _bizNameCtrl)),
                            const SizedBox(width: 16),
                            Expanded(child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Industry Sector', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
                                const SizedBox(height: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.border),
                                    borderRadius: BorderRadius.circular(8),
                                    color: isDark ? AppColors.darkCard : AppColors.white,
                                  ),
                                  child: Row(children: [
                                    Expanded(child: Text(_sector,
                                      style: const TextStyle(fontSize: 14, color: AppColors.textPrimary))),
                                    const Icon(Icons.keyboard_arrow_down, size: 16, color: AppColors.textSecondary),
                                  ]),
                                ),
                              ],
                            )),
                          ]),
                          const SizedBox(height: 16),
                          _LabeledField(label: 'Primary Headquarters Address', controller: _addressCtrl, maxLines: 3),
                          const SizedBox(height: 16),
                          Align(
                            alignment: Alignment.centerRight,
                            child: AppButton(label: 'Save Changes', onPressed: () {}, small: true),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    _RolesCard(isDark: isDark),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              // Right: Brand Identity + Tax & Payments
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    _SectionCard(
                      icon: Icons.palette_outlined,
                      title: 'Brand Identity',
                      isDark: isDark,
                      child: Column(
                        children: [
                          Container(
                            height: 120,
                            decoration: BoxDecoration(
                              border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.border, style: BorderStyle.solid),
                              borderRadius: BorderRadius.circular(8),
                              color: isDark ? AppColors.darkBackground : AppColors.background,
                            ),
                            child: const Center(child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.upload_file_rounded, color: AppColors.textTertiary, size: 28),
                                SizedBox(height: 6),
                                Text('Upload Logo (SVG/PNG)', style: TextStyle(fontSize: 12, color: AppColors.textTertiary)),
                              ],
                            )),
                          ),
                          const SizedBox(height: 16),
                          const Align(alignment: Alignment.centerLeft,
                            child: Text('Brand Color Accent', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textPrimary))),
                          const SizedBox(height: 8),
                          Row(children: [
                            GestureDetector(
                              onTap: () {},
                              child: Container(
                                width: 40, height: 40,
                                decoration: BoxDecoration(color: _brandColor, borderRadius: BorderRadius.circular(8)),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                controller: TextEditingController(text: '#006c49'),
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.border)),
                                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.border)),
                                ),
                              ),
                            ),
                          ]),
                          const SizedBox(height: 8),
                          const Text('These changes will reflect on all POS terminals and customer receipts.',
                            style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    _TaxCard(isDark: isDark),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget child;
  final bool isDark;
  const _SectionCard({required this.icon, required this.title, required this.child, required this.isDark});

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
          Row(children: [
            Container(padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: AppColors.primarySurface, borderRadius: BorderRadius.circular(8)),
              child: Icon(icon, size: 16, color: AppColors.primary)),
            const SizedBox(width: 10),
            Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
          ]),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

class _LabeledField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final int maxLines;
  const _LabeledField({required this.label, required this.controller, this.maxLines = 1});

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
      const SizedBox(height: 6),
      TextField(controller: controller, maxLines: maxLines, style: const TextStyle(fontSize: 14)),
    ],
  );
}

class _RolesCard extends StatelessWidget {
  final bool isDark;
  const _RolesCard({required this.isDark});

  static const _roles = [
    ('Administrator', 'FULL ACCESS', '3'),
    ('Branch Manager', 'REGIONAL', '12'),
    ('Barista / POS', 'LIMITED', '48'),
  ];

  @override
  Widget build(BuildContext context) {
    final bg = isDark ? AppColors.darkCard : AppColors.white;
    final border = isDark ? AppColors.darkBorder : AppColors.border;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12), border: Border.all(color: border)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Container(padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: AppColors.primarySurface, borderRadius: BorderRadius.circular(8)),
              child: const Icon(Icons.people_alt_outlined, size: 16, color: AppColors.primary)),
            const SizedBox(width: 10),
            const Text('Roles & Permissions',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
            const Spacer(),
            TextButton(onPressed: () {},
              child: const Text('+ New Role', style: TextStyle(fontSize: 13, color: AppColors.primary, fontWeight: FontWeight.w600))),
          ]),
          const SizedBox(height: 12),
          Container(
            color: isDark ? AppColors.darkSurface : const Color(0xFFF9FAFB),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: const Row(children: [
              Expanded(flex: 2, child: Text('ROLE NAME', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.textSecondary, letterSpacing: 0.5))),
              Expanded(child: Text('SCOPE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.textSecondary, letterSpacing: 0.5))),
              Expanded(child: Text('USERS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.textSecondary, letterSpacing: 0.5))),
              SizedBox(width: 40, child: Text('ACTIONS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.textSecondary, letterSpacing: 0.5))),
            ]),
          ),
          Divider(height: 1, color: border),
          ..._roles.map((r) => Column(children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(children: [
                Expanded(flex: 2, child: Text(r.$1, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary))),
                Expanded(child: AppBadge(
                  label: r.$2,
                  type: r.$2 == 'FULL ACCESS' ? BadgeType.success
                      : r.$2 == 'REGIONAL' ? BadgeType.info : BadgeType.neutral,
                )),
                Expanded(child: Text(r.$3, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary))),
                SizedBox(width: 40, child: IconButton(
                  icon: const Icon(Icons.edit_outlined, size: 16, color: AppColors.textSecondary), onPressed: () {})),
              ]),
            ),
            if (r != _roles.last) Divider(height: 1, color: border),
          ])),
        ],
      ),
    );
  }
}

class _TaxCard extends StatelessWidget {
  final bool isDark;
  const _TaxCard({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final bg = isDark ? AppColors.darkCard : AppColors.white;
    final border = isDark ? AppColors.darkBorder : AppColors.border;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12), border: Border.all(color: border)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Container(padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: AppColors.errorSurface, borderRadius: BorderRadius.circular(8)),
              child: const Icon(Icons.receipt_long_outlined, size: 16, color: AppColors.error)),
            const SizedBox(width: 10),
            const Text('Tax & Payments',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
          ]),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primarySurface,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(children: [
              const Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Value Added Tax (VAT)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                  Text('Applied to all standard items', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                ],
              )),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(6)),
                child: const Text('15.0%', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700)),
              ),
            ]),
          ),
          const SizedBox(height: 12),
          const Text('Default Currency', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(border: Border.all(color: border), borderRadius: BorderRadius.circular(8)),
            child: Row(children: [
              const Expanded(child: Text('USD - United States Dollar', style: TextStyle(fontSize: 14, color: AppColors.textPrimary))),
              const Icon(Icons.keyboard_arrow_down, size: 16, color: AppColors.textSecondary),
            ]),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: const Color(0xFF1A1A2E), borderRadius: BorderRadius.circular(8)),
            child: Row(children: [
              const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Stripe Integration', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
                Text('Payouts scheduled every Monday.', style: TextStyle(color: Colors.white54, fontSize: 11)),
              ])),
              AppBadge(label: 'ACTIVE', type: BadgeType.success),
            ]),
          ),
        ],
      ),
    );
  }
}
