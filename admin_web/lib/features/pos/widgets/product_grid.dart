import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_provider.dart';
import '../providers/pos_provider.dart';

class ProductGrid extends StatelessWidget {
  const ProductGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final pos = context.watch<PosProvider>();
    final isDark = context.watch<ThemeProvider>().isDark;
    final products = pos.filteredProducts;

    return Column(
      children: [
        // Top bar
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              // Order type toggle
              Container(
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCard : AppColors.cardBg,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.border),
                ),
                child: Row(
                  children: ['DINE-IN', 'TAKEAWAY'].map((type) {
                    final active = pos.orderType == type;
                    return GestureDetector(
                      onTap: () => pos.setOrderType(type),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: active ? AppColors.primary : Colors.transparent,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(type,
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: active ? Colors.white : (isDark ? AppColors.darkTextSecondary : AppColors.textSecondary))),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(width: 12),
              // Search
              Expanded(
                child: SizedBox(
                  height: 38,
                  child: TextField(
                    onChanged: pos.setSearch,
                    decoration: const InputDecoration(
                      hintText: 'Search item name or SKU...',
                      prefixIcon: Icon(Icons.search_rounded, size: 18),
                      isDense: true,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        // Category title
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text('${pos.selectedCategory} Selection',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary)),
          ),
        ),
        // Grid
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 0.75,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: products.length,
            itemBuilder: (context, i) => _ProductCard(product: products[i], isDark: isDark),
          ),
        ),
      ],
    );
  }
}

class _ProductCard extends StatelessWidget {
  final PosProduct product;
  final bool isDark;
  const _ProductCard({required this.product, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final pos = context.read<PosProvider>();
    final cardColor = isDark ? AppColors.darkCard : AppColors.cardBg;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;
    final textColor = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final mutedColor = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image area
          Expanded(
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.primarySurface,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  ),
                  child: Center(
                    child: Text(product.emoji, style: const TextStyle(fontSize: 40)),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text('\$${product.price.toStringAsFixed(2)}',
                        style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
                  ),
                ),
              ],
            ),
          ),
          // Info
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.name,
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: textColor),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                Text(product.description,
                    style: TextStyle(fontSize: 11, color: mutedColor),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => pos.addToCart(product),
                    icon: const Icon(Icons.add_rounded, size: 14),
                    label: const Text('ADD', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
