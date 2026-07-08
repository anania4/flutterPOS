import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_provider.dart';
import '../../../shared/widgets/section_card.dart';

class _Branch {
  final String name;
  final double revenue;
  final double maxRevenue;
  const _Branch(this.name, this.revenue, this.maxRevenue);
}

class BranchPerformanceList extends StatelessWidget {
  const BranchPerformanceList({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDark;
    final branches = [
      const _Branch('Downtown Artisan', 12450, 15000),
      const _Branch('East Side Roastery', 10120, 15000),
      const _Branch('West End Hub', 8340, 15000),
      const _Branch('Harbor View Coffee', 7900, 15000),
    ];

    return SectionCard(
      title: 'Top Performing Branches',
      height: 320,
      child: Column(
        children: [
          ...branches.map((b) => _BranchRow(branch: b, isDark: isDark)),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.border),
              ),
              child: const Text('View All Branches', style: TextStyle(fontSize: 13)),
            ),
          ),
        ],
      ),
    );
  }
}

class _BranchRow extends StatelessWidget {
  final _Branch branch;
  final bool isDark;
  const _BranchRow({required this.branch, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final ratio = branch.revenue / branch.maxRevenue;
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(branch.name,
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary)),
              ),
              Text('\$${(branch.revenue / 1000).toStringAsFixed(1)}k',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary)),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: ratio,
              minHeight: 6,
              backgroundColor: isDark ? AppColors.darkBorder : AppColors.divider,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}
