import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/app_badge.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/stat_card.dart';

class _RecipeIngredient {
  String name, unit;
  double qty, unitCost;
  bool inStock;
  _RecipeIngredient({required this.name, required this.qty, required this.unit,
    required this.unitCost, this.inStock = true});
  double get totalCost => qty * unitCost;
}

class RecipeScreen extends StatefulWidget {
  const RecipeScreen({super.key});
  @override
  State<RecipeScreen> createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  final List<_RecipeIngredient> _ingredients = [
    _RecipeIngredient(name: 'Sourdough Bread', qty: 2, unit: 'slices', unitCost: 0.40),
    _RecipeIngredient(name: 'Ripe Avocado', qty: 0.5, unit: 'pcs', unitCost: 1.20, inStock: false),
    _RecipeIngredient(name: 'Micro-greens', qty: 15, unit: 'g', unitCost: 0.05),
    _RecipeIngredient(name: 'Extra Virgin Olive Oil', qty: 10, unit: 'ml', unitCost: 0.02),
    _RecipeIngredient(name: 'Chili Flakes', qty: 2, unit: 'g', unitCost: 0.01),
  ];

  bool _isActive = true;

  double get _totalCost => _ingredients.fold(0, (s, i) => s + i.totalCost);
  double get _sellingPrice => 12.00;
  double get _profit => _sellingPrice - _totalCost;
  double get _margin => (_profit / _sellingPrice) * 100;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Breadcrumb
          Row(children: [
            TextButton(onPressed: () {}, child: const Text('Inventory', style: TextStyle(fontSize: 13, color: AppColors.textSecondary))),
            const Icon(Icons.chevron_right, size: 16, color: AppColors.textTertiary),
            const Text('Recipes', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
          ]),
          const SizedBox(height: 16),
          SectionHeader(
            title: 'Recipe Management',
            subtitle: 'Manage ingredient costs, margins, and inventory impact for your menu items.',
            actions: [AppButton(label: '+ Create New Recipe', onPressed: () {}, small: true)],
          ),
          const SizedBox(height: 20),
          Row(children: [
            Expanded(child: StatCard(title: 'Total Active Recipes', value: '48',
              badge: '+2 this month', icon: Icons.menu_book_outlined,
              iconBg: AppColors.primarySurface, iconColor: AppColors.primary, subtitle: '')),
            const SizedBox(width: 16),
            Expanded(child: StatCard(title: 'Avg. Food Cost', value: '28.4%',
              badge: '— Stable', badgeColor: AppColors.textSecondary,
              icon: Icons.money_outlined, iconBg: AppColors.infoSurface, iconColor: AppColors.info, subtitle: '')),
            const SizedBox(width: 16),
            Expanded(child: StatCard(title: 'Highest Margin Item', value: '82%',
              badge: 'Cold Brew', badgeColor: AppColors.success,
              icon: Icons.trending_up, iconBg: AppColors.successSurface, iconColor: AppColors.success, subtitle: '')),
            const SizedBox(width: 16),
            Expanded(child: StatCard(title: 'Cost Alerts', value: '3',
              isAlert: true, subtitle: 'Above target cost')),
          ]),
          const SizedBox(height: 24),
          // Recipe card
          Container(
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCard : AppColors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.border),
            ),
            child: Column(
              children: [
                // Recipe header
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(children: [
                    Container(width: 52, height: 52,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: AppColors.border),
                      child: const Icon(Icons.breakfast_dining, color: AppColors.textSecondary, size: 28)),
                    const SizedBox(width: 14),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Row(children: [
                        const Text('Signature Avocado Toast',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                        const SizedBox(width: 10),
                        AppBadge(label: 'ACTIVE', type: BadgeType.success),
                      ]),
                      const Text('Last updated: Oct 24, 2023',
                        style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                    ])),
                    const SizedBox(width: 20),
                    _PriceBox(label: 'Selling Price', value: '\$${_sellingPrice.toStringAsFixed(2)}'),
                    const SizedBox(width: 12),
                    _PriceBox(label: 'Profit Margin', value: '${_margin.toStringAsFixed(1)}%',
                      valueColor: AppColors.success),
                  ]),
                ),
                Divider(height: 1, color: isDark ? AppColors.darkBorder : AppColors.border),
                // Cost summary row
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Row(children: [
                    _CostTile('Total Production Cost', '\$${_totalCost.toStringAsFixed(2)}'),
                    _CostTile('Cost per Serving', '\$${_totalCost.toStringAsFixed(2)}'),
                    _CostTile('Expected Profit', '\$${_profit.toStringAsFixed(2)}'),
                    _CostTile('Tax Impact (Est.)', '\$${(_totalCost * 0.28).toStringAsFixed(2)}'),
                  ]),
                ),
                Divider(height: 1, color: isDark ? AppColors.darkBorder : AppColors.border),
                // Ingredient table header
                Container(
                  color: isDark ? AppColors.darkSurface : const Color(0xFFF0F4FF),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: const Row(children: [
                    Expanded(flex: 3, child: _H('INGREDIENT NAME')),
                    Expanded(flex: 1, child: _H('QUANTITY')),
                    Expanded(flex: 1, child: _H('UNIT')),
                    Expanded(flex: 1, child: _H('UNIT COST')),
                    Expanded(flex: 1, child: _H('TOTAL LINE COST')),
                    Expanded(flex: 1, child: _H('STOCK STATUS')),
                    SizedBox(width: 40),
                  ]),
                ),
                Divider(height: 1, color: isDark ? AppColors.darkBorder : AppColors.border),
                ..._ingredients.asMap().entries.map((e) => Column(children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    child: Row(children: [
                      Expanded(flex: 3, child: Row(children: [
                        Icon(Icons.restaurant_menu, size: 16, color: AppColors.textTertiary),
                        const SizedBox(width: 8),
                        Text(e.value.name, style: const TextStyle(fontSize: 13, color: AppColors.textPrimary)),
                      ])),
                      Expanded(flex: 1, child: SizedBox(
                        height: 32, width: 60,
                        child: TextField(
                          controller: TextEditingController(text: e.value.qty.toString()),
                          style: const TextStyle(fontSize: 13),
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(6),
                              borderSide: const BorderSide(color: AppColors.border)),
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6),
                              borderSide: const BorderSide(color: AppColors.border)),
                          ),
                          onChanged: (v) => setState(() => e.value.qty = double.tryParse(v) ?? e.value.qty),
                        ),
                      )),
                      Expanded(flex: 1, child: Row(children: [
                        Text(e.value.unit, style: const TextStyle(fontSize: 13, color: AppColors.textPrimary)),
                        const Icon(Icons.keyboard_arrow_down, size: 14, color: AppColors.textSecondary),
                      ])),
                      Expanded(flex: 1, child: Text('\$${e.value.unitCost.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 13, color: AppColors.textSecondary))),
                      Expanded(flex: 1, child: Text('\$${e.value.totalCost.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimary))),
                      Expanded(flex: 1, child: AppBadge(
                        label: e.value.inStock ? 'In Stock' : 'Low Stock',
                        type: e.value.inStock ? BadgeType.success : BadgeType.warning)),
                      SizedBox(width: 40, child: IconButton(
                        icon: const Icon(Icons.close, size: 16, color: AppColors.textTertiary),
                        onPressed: () => setState(() => _ingredients.removeAt(e.key)),
                      )),
                    ]),
                  ),
                  if (e.key < _ingredients.length - 1)
                    Divider(height: 1, color: isDark ? AppColors.darkBorder : AppColors.border),
                ])),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: GestureDetector(
                    onTap: () => setState(() => _ingredients.add(
                      _RecipeIngredient(name: 'New Ingredient', qty: 1, unit: 'g', unitCost: 0.10))),
                    child: Row(children: const [
                      Icon(Icons.add_circle_outline, size: 18, color: AppColors.primary),
                      SizedBox(width: 8),
                      Text('Add Ingredient', style: TextStyle(fontSize: 13, color: AppColors.primary, fontWeight: FontWeight.w600)),
                    ]),
                  ),
                ),
                Divider(height: 1, color: isDark ? AppColors.darkBorder : AppColors.border),
                // Footer
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(children: [
                    const Text('Recipe Status', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                    const SizedBox(width: 10),
                    Switch(value: _isActive, activeColor: AppColors.primary,
                      onChanged: (v) => setState(() => _isActive = v)),
                    const SizedBox(width: 6),
                    Text(_isActive ? 'Active' : 'Inactive',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600,
                        color: _isActive ? AppColors.success : AppColors.textSecondary)),
                    const SizedBox(width: 16),
                    TextButton.icon(onPressed: () {},
                      icon: const Icon(Icons.visibility_outlined, size: 14),
                      label: const Text('View Inventory Impact', style: TextStyle(fontSize: 13))),
                    const Spacer(),
                    AppButton(label: 'Duplicate', style: AppButtonStyle.outlined, small: true, onPressed: () {}),
                    const SizedBox(width: 10),
                    AppButton(label: 'Delete', style: AppButtonStyle.danger, small: true, onPressed: () {}),
                    const SizedBox(width: 10),
                    AppButton(label: 'Save Recipe', small: true, onPressed: () {}),
                  ]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PriceBox extends StatelessWidget {
  final String label, value;
  final Color? valueColor;
  const _PriceBox({required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    decoration: BoxDecoration(
      border: Border.all(color: AppColors.border), borderRadius: BorderRadius.circular(8)),
    child: Column(children: [
      Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
      const SizedBox(height: 4),
      Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700,
        color: valueColor ?? AppColors.textPrimary)),
    ]),
  );
}

class _CostTile extends StatelessWidget {
  final String label, value;
  const _CostTile(this.label, this.value);

  @override
  Widget build(BuildContext context) => Expanded(child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
      const SizedBox(height: 4),
      Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
    ],
  ));
}

class _H extends StatelessWidget {
  final String text;
  const _H(this.text);
  @override
  Widget build(BuildContext context) => Text(text,
    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700,
      color: AppColors.textSecondary, letterSpacing: 0.5));
}
