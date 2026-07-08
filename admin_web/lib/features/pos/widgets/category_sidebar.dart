import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_provider.dart';
import '../providers/pos_provider.dart';

class CategorySidebar extends StatelessWidget {
  const CategorySidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final pos = context.watch<PosProvider>();
    final isDark = context.watch<ThemeProvider>().isDark;
    final bgColor = isDark ? AppColors.darkSurface : AppColors.white;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;

    final catIcons = {
      'Coffee': Icons.local_cafe_rounded,
      'Pastries': Icons.bakery_dining_rounded,
      'Breakfast': Icons.egg_alt_rounded,
      'Cold Brew': Icons.ac_unit_rounded,
      'Smoothies': Icons.blender_rounded,
      'Snacks': Icons.fastfood_rounded,
    };

    return Container(
      width: 180,
      color: bgColor,
      decoration: BoxDecoration(border: Border(right: BorderSide(color: borderColor))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text('Categories',
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary)),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              children: PosProvider.categories.map((cat) {
                final isActive = pos.selectedCategory == cat;
                return GestureDetector(
                  onTap: () => pos.selectCategory(cat),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 2),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: isActive ? AppColors.primarySurface : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(catIcons[cat] ?? Icons.category_rounded, size: 16,
                            color: isActive ? AppColors.primary : (isDark ? AppColors.darkTextSecondary : AppColors.textSecondary)),
                        const SizedBox(width: 10),
                        Text(cat,
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                                color: isActive ? AppColors.primary : (isDark ? AppColors.darkTextSecondary : AppColors.textSecondary))),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          Divider(color: borderColor, height: 1),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                _QuickLink(icon: Icons.point_of_sale_rounded, label: 'POS', isDark: isDark),
                _QuickLink(icon: Icons.receipt_long_rounded, label: 'Orders', isDark: isDark),
                _QuickLink(icon: Icons.inventory_2_rounded, label: 'Inventory', isDark: isDark),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.lock_rounded, size: 14, color: AppColors.error),
              label: const Text('Lock Screen', style: TextStyle(fontSize: 12, color: AppColors.error)),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickLink extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isDark;
  const _QuickLink({required this.icon, required this.label, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Icon(icon, size: 14, color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary),
          const SizedBox(width: 8),
          Text(label, style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary)),
        ],
      ),
    );
  }
}
