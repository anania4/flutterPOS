import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/app_badge.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/stat_card.dart';

class _InventoryItem {
  final String name, category, unit, supplier;
  final double stock;
  final bool lowStock;
  const _InventoryItem(this.name, this.category, this.stock, this.unit, this.supplier, {this.lowStock = false});
}

const _items = [
  _InventoryItem('Ethiopian Yirgacheffe Beans', 'Raw Coffee', 42.6, 'kg', 'Global Origin Imports'),
  _InventoryItem('Oat Milk (Barista Edition)', 'Dairy', 12.6, 'litres', 'PurePlant Co.', lowStock: true),
  _InventoryItem('Paper Cups (12oz)', 'Packaging', 5800, 'units', 'Eco-Pack Solutions'),
  _InventoryItem('Vanilla Bean Syrup', 'Syrups', 24.6, 'bottles', 'Artisan Flavors'),
  _InventoryItem('Guatemalan Medium Roast', 'Raw Coffee', 5.5, 'kg', 'Global Origin Imports', lowStock: true),
  _InventoryItem('Almond Milk', 'Dairy', 18.0, 'litres', 'PurePlant Co.'),
  _InventoryItem('Biodegradable Straws', 'Packaging', 2400, 'units', 'Eco-Pack Solutions'),
  _InventoryItem('Caramel Sauce', 'Syrups', 8.0, 'bottles', 'Artisan Flavors'),
];

const _categories = ['All Items', 'Raw Coffee', 'Packaging', 'Dairy', 'Syrups'];

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});
  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  String _cat = 'All Items';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final filtered = _cat == 'All Items' ? _items : _items.where((i) => i.category == _cat).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: 'Inventory Management',
            subtitle: 'Real-time stock monitoring and replenishment across Artisan Brew network.',
            actions: [
              AppButton(label: 'Purchase Orders', icon: Icons.shopping_cart_outlined,
                style: AppButtonStyle.outlined, small: true, onPressed: () {}),
              const SizedBox(width: 10),
              AppButton(label: '+ Add Stock', onPressed: () {}, small: true),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: StatCard(title: 'Stock Health', value: '94%',
                badge: '+2.4% vs last week',
                icon: Icons.health_and_safety_outlined, iconBg: AppColors.successSurface, iconColor: AppColors.success,
                subtitle: '1,284 total SKUs')),
              const SizedBox(width: 16),
              Expanded(child: StatCard(title: 'Total SKUs', value: '1,284',
                icon: Icons.inventory_2_outlined,
                iconBg: AppColors.infoSurface, iconColor: AppColors.info,
                subtitle: '12 active categories')),
              const SizedBox(width: 16),
              Expanded(child: StatCard(title: 'Low Stock Alerts', value: '8',
                isAlert: true, subtitle: '8 items are below safety threshold')),
            ],
          ),
          const SizedBox(height: 20),
          // Category filter + table
          Container(
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCard : AppColors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.border),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                  child: Row(
                    children: [
                      ..._categories.map((c) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: _CatChip(label: c, active: _cat == c,
                          onTap: () => setState(() => _cat = c)),
                      )),
                      const Spacer(),
                      IconButton(icon: const Icon(Icons.filter_list, size: 18, color: AppColors.textSecondary), onPressed: () {}),
                      IconButton(icon: const Icon(Icons.download_outlined, size: 18, color: AppColors.textSecondary), onPressed: () {}),
                    ],
                  ),
                ),
                Divider(height: 1, color: isDark ? AppColors.darkBorder : AppColors.border),
                // Header row
                Container(
                  color: isDark ? AppColors.darkSurface : const Color(0xFFF9FAFB),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: const Row(children: [
                    Expanded(flex: 3, child: _H('ITEM NAME')),
                    Expanded(flex: 2, child: _H('CATEGORY')),
                    Expanded(flex: 1, child: _H('CURRENT STOCK')),
                    Expanded(flex: 1, child: _H('UNIT')),
                    Expanded(flex: 2, child: _H('SUPPLIER')),
                    SizedBox(width: 80, child: _H('ACTIONS')),
                  ]),
                ),
                Divider(height: 1, color: isDark ? AppColors.darkBorder : AppColors.border),
                ...filtered.map((item) => Column(children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    child: Row(children: [
                      Expanded(flex: 3, child: Row(children: [
                        Container(width: 32, height: 32,
                          decoration: BoxDecoration(
                            color: item.lowStock ? AppColors.errorSurface : AppColors.primarySurface,
                            borderRadius: BorderRadius.circular(8)),
                          child: Icon(Icons.inventory_2_outlined, size: 16,
                            color: item.lowStock ? AppColors.error : AppColors.primary)),
                        const SizedBox(width: 10),
                        Text(item.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
                      ])),
                      Expanded(flex: 2, child: _CatTag(item.category)),
                      Expanded(flex: 1, child: Text(item.stock.toString(),
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600,
                          color: item.lowStock ? AppColors.error : AppColors.textPrimary))),
                      Expanded(flex: 1, child: Text(item.unit,
                        style: const TextStyle(fontSize: 13, color: AppColors.textSecondary))),
                      Expanded(flex: 2, child: Text(item.supplier,
                        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary))),
                      SizedBox(width: 80, child: Row(children: [
                        IconButton(icon: const Icon(Icons.edit_outlined, size: 16, color: AppColors.primary), onPressed: () {}),
                        if (item.lowStock)
                          IconButton(icon: const Icon(Icons.add_shopping_cart, size: 16, color: AppColors.warning), onPressed: () {}),
                      ])),
                    ]),
                  ),
                  if (item != filtered.last) Divider(height: 1, color: isDark ? AppColors.darkBorder : AppColors.border),
                ])),
                Divider(height: 1, color: isDark ? AppColors.darkBorder : AppColors.border),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(children: [
                    Text('Showing 1 to ${filtered.length} of ${_items.length} items',
                      style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                    const Spacer(),
                    _PageBtn(label: 'Previous', onTap: () {}),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.primary, borderRadius: BorderRadius.circular(6)),
                      child: const Text('1', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white)),
                    ),
                    _PageBtn(label: '2', onTap: () {}),
                    _PageBtn(label: '3', onTap: () {}),
                    _PageBtn(label: 'Next', onTap: () {}),
                  ]),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () => context.go('/inventory/recipes'),
            icon: const Icon(Icons.menu_book_outlined, size: 16),
            label: const Text('Manage Recipes / Bill of Materials'),
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
    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700,
      color: AppColors.textSecondary, letterSpacing: 0.5));
}

class _CatChip extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;
  const _CatChip({required this.label, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: active ? AppColors.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: active ? AppColors.primary : AppColors.border),
      ),
      child: Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500,
        color: active ? Colors.white : AppColors.textSecondary)),
    ),
  );
}

class _CatTag extends StatelessWidget {
  final String label;
  const _CatTag(this.label);

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
    decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(4),
      border: Border.all(color: AppColors.border)),
    child: Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
  );
}

class _PageBtn extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _PageBtn({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
    ),
  );
}
