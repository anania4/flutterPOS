import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_badge.dart';

class _CartItem {
  final String name;
  final String note;
  final double price;
  int qty;
  _CartItem({required this.name, required this.note, required this.price, this.qty = 1});
}

class _Product {
  final String name;
  final String desc;
  final double price;
  const _Product(this.name, this.desc, this.price);
}

const _categories = ['Coffee', 'Pastries', 'Breakfast', 'Cold Brew', 'Ice Cream'];
const _products = {
  'Coffee': [
    _Product('Flat White', 'Double shot, creamy', 4.50),
    _Product('Butter Croissant', 'Freshly baked...', 3.75),
    _Product('Signature Cold Brew', '18-hour steel...', 5.20),
    _Product('Caffe Latte', 'Creamy, rich...', 4.25),
    _Product('Long Black', 'Pure espresso...', 3.50),
    _Product('Pain au Chocolat', 'Dark...', 4.10),
    _Product('Matcha Latte', 'Premium...', 5.50),
    _Product('Avocado Toast', 'Sourdough...', 12.00),
  ],
  'Pastries': [
    _Product('Croissant', 'Butter, flaky', 3.50),
    _Product('Muffin', 'Blueberry', 3.00),
    _Product('Danish', 'Apple cinnamon', 4.00),
    _Product('Scone', 'Plain or raisin', 3.25),
  ],
  'Breakfast': [
    _Product('Avocado Toast', 'Sourdough, poached egg', 12.00),
    _Product('Granola Bowl', 'Yogurt, honey', 9.50),
    _Product('Eggs Benedict', 'Hollandaise sauce', 14.00),
  ],
  'Cold Brew': [
    _Product('Classic Cold Brew', '12oz, 18h steep', 5.50),
    _Product('Nitro Cold Brew', 'Smooth, creamy', 6.00),
    _Product('Vanilla Cold Brew', 'Sweet, creamy', 5.75),
  ],
  'Ice Cream': [
    _Product('Vanilla Scoop', 'Single scoop', 4.00),
    _Product('Chocolate Scoop', 'Rich dark', 4.00),
    _Product('Affogato', 'Espresso + vanilla', 6.50),
  ],
};

class PosScreen extends StatefulWidget {
  const PosScreen({super.key});
  @override
  State<PosScreen> createState() => _PosScreenState();
}

class _PosScreenState extends State<PosScreen> {
  String _selectedCategory = 'Coffee';
  bool _isDineIn = true;
  final List<_CartItem> _cart = [
    _CartItem(name: 'Flat White', note: 'Extra Shot, Oat Milk', price: 5.00, qty: 2),
    _CartItem(name: 'Butter Croissant', note: 'Warmed', price: 3.75),
    _CartItem(name: 'Matcha Latte', note: 'Iced', price: 5.50),
  ];
  bool _showPayment = false;

  double get _subtotal => _cart.fold(0, (s, i) => s + i.price * i.qty);
  double get _service => _subtotal * 0.10;
  double get _tax => _subtotal * 0.05;
  double get _total => _subtotal + _service + _tax;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      children: [
        // Left: categories
        _CategoryPanel(
          selected: _selectedCategory,
          onSelect: (c) => setState(() => _selectedCategory = c),
          isDark: isDark,
        ),
        // Center: product grid
        Expanded(
          child: _ProductGrid(
            category: _selectedCategory,
            isDineIn: _isDineIn,
            onToggleType: (v) => setState(() => _isDineIn = v),
            onAdd: (p) => setState(() {
              final existing = _cart.where((c) => c.name == p.name);
              if (existing.isNotEmpty) {
                existing.first.qty++;
              } else {
                _cart.add(_CartItem(name: p.name, note: '', price: p.price));
              }
            }),
            isDark: isDark,
          ),
        ),
        // Right: cart
        _CartPanel(
          cart: _cart,
          subtotal: _subtotal,
          service: _service,
          tax: _tax,
          total: _total,
          isDineIn: _isDineIn,
          onQtyChange: (item, delta) => setState(() {
            item.qty += delta;
            if (item.qty <= 0) _cart.remove(item);
          }),
          onPay: () => setState(() => _showPayment = true),
          isDark: isDark,
        ),
        if (_showPayment)
          _PaymentDialog(
            total: _total,
            onClose: () => setState(() => _showPayment = false),
            onComplete: () {
              setState(() { _cart.clear(); _showPayment = false; });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Payment successful! Order sent to kitchen.'),
                  backgroundColor: AppColors.success));
            },
          ),
      ],
    );
  }
}

class _CategoryPanel extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onSelect;
  final bool isDark;
  const _CategoryPanel({required this.selected, required this.onSelect, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final bg = isDark ? AppColors.darkSurface : AppColors.white;
    final border = isDark ? AppColors.darkBorder : AppColors.border;
    return Container(
      width: 180,
      decoration: BoxDecoration(
        color: bg, border: Border(right: BorderSide(color: border))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 20, 16, 12),
            child: Text('Categories', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700,
              color: AppColors.textSecondary, letterSpacing: 0.5)),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              children: _categories.map((c) {
                final isActive = c == selected;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Material(
                    color: isActive ? AppColors.primarySurface : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    child: InkWell(
                      onTap: () => onSelect(c),
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        child: Text(c, style: TextStyle(
                          fontSize: 14,
                          fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                          color: isActive ? AppColors.primary : AppColors.textSecondary,
                        )),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                _SideLink(icon: Icons.point_of_sale_rounded, label: 'POS'),
                _SideLink(icon: Icons.receipt_long_rounded, label: 'Orders'),
                _SideLink(icon: Icons.inventory_2_rounded, label: 'Inventory'),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Material(
              color: isDark ? AppColors.darkCard : AppColors.background,
              borderRadius: BorderRadius.circular(8),
              child: InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(8),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: Row(
                    children: [
                      Icon(Icons.lock_outline, size: 16, color: AppColors.error),
                      SizedBox(width: 8),
                      Text('Lock Screen', style: TextStyle(fontSize: 13, color: AppColors.error, fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SideLink extends StatelessWidget {
  final IconData icon;
  final String label;
  const _SideLink({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 2),
    child: Row(
      children: [
        Icon(icon, size: 16, color: AppColors.textSecondary),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
      ],
    ),
  );
}

class _ProductGrid extends StatelessWidget {
  final String category;
  final bool isDineIn;
  final ValueChanged<bool> onToggleType;
  final ValueChanged<_Product> onAdd;
  final bool isDark;
  const _ProductGrid({required this.category, required this.isDineIn,
    required this.onToggleType, required this.onAdd, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final products = _products[category] ?? [];
    return Column(
      children: [
        // Top bar with order type toggle and search
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : AppColors.white,
            border: Border(bottom: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.border)),
          ),
          child: Row(
            children: [
              // Dine-in / Takeaway toggle
              Container(
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCard : AppColors.background,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.border),
                ),
                child: Row(
                  children: [
                    _TypeToggle(label: 'DINE-IN', active: isDineIn, onTap: () => onToggleType(true)),
                    _TypeToggle(label: 'TAKEAWAY', active: !isDineIn, onTap: () => onToggleType(false)),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search item name or SKU...',
                    prefixIcon: const Icon(Icons.search, size: 18, color: AppColors.textTertiary),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    filled: true,
                    fillColor: isDark ? AppColors.darkCard : AppColors.background,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.border)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.border)),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      borderSide: BorderSide(color: AppColors.primary),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('$category Selection',
                  style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 16),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    childAspectRatio: 0.72,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: products.length,
                  itemBuilder: (_, i) => _ProductCard(
                    product: products[i],
                    isDark: isDark,
                    onAdd: () => onAdd(products[i]),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _TypeToggle extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;
  const _TypeToggle({required this.label, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: active ? AppColors.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(7),
      ),
      child: Text(label, style: TextStyle(
        fontSize: 12, fontWeight: FontWeight.w700,
        color: active ? Colors.white : AppColors.textSecondary,
      )),
    ),
  );
}

class _ProductCard extends StatelessWidget {
  final _Product product;
  final VoidCallback onAdd;
  final bool isDark;
  const _ProductCard({required this.product, required this.onAdd, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final bg = isDark ? AppColors.darkCard : AppColors.white;
    final border = isDark ? AppColors.darkBorder : AppColors.border;
    return Container(
      decoration: BoxDecoration(
        color: bg, borderRadius: BorderRadius.circular(12), border: Border.all(color: border)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  child: Container(
                    width: double.infinity,
                    color: AppColors.background,
                    child: const Icon(Icons.local_cafe_rounded, size: 40, color: AppColors.border),
                  ),
                ),
                Positioned(
                  top: 8, right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary, borderRadius: BorderRadius.circular(6)),
                    child: Text('\$${product.price.toStringAsFixed(2)}',
                      style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.name, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary)),
                Text(product.desc, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                  maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity, height: 32,
                  child: ElevatedButton.icon(
                    onPressed: onAdd,
                    icon: const Icon(Icons.add, size: 14),
                    label: const Text('ADD', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
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

class _CartPanel extends StatelessWidget {
  final List<_CartItem> cart;
  final double subtotal, service, tax, total;
  final bool isDineIn;
  final Function(_CartItem, int) onQtyChange;
  final VoidCallback onPay;
  final bool isDark;
  const _CartPanel({required this.cart, required this.subtotal, required this.service,
    required this.tax, required this.total, required this.isDineIn,
    required this.onQtyChange, required this.onPay, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final bg = isDark ? AppColors.darkSurface : AppColors.white;
    final border = isDark ? AppColors.darkBorder : AppColors.border;
    return Container(
      width: 300,
      decoration: BoxDecoration(color: bg, border: Border(left: BorderSide(color: border))),
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Order #421', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                      const Text('Table 08 • Server: Marcus',
                        style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                    ],
                  ),
                ),
                Icon(Icons.delete_outline, color: AppColors.error, size: 20),
              ],
            ),
          ),
          Divider(height: 1, color: border),
          Expanded(
            child: cart.isEmpty
                ? const Center(child: Text('Cart is empty', style: TextStyle(color: AppColors.textTertiary)))
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: cart.length,
                    separatorBuilder: (_, __) => Divider(height: 1, color: border),
                    itemBuilder: (_, i) {
                      final item = cart[i];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        child: Row(
                          children: [
                            // qty control
                            Container(
                              decoration: BoxDecoration(
                                color: AppColors.primarySurface, borderRadius: BorderRadius.circular(6)),
                              child: Row(
                                children: [
                                  SizedBox(width: 24, height: 24,
                                    child: IconButton(padding: EdgeInsets.zero, iconSize: 14,
                                      icon: const Icon(Icons.remove, color: AppColors.primary),
                                      onPressed: () => onQtyChange(item, -1))),
                                  Text('${item.qty}', style: const TextStyle(fontSize: 12,
                                    fontWeight: FontWeight.w700, color: AppColors.primary)),
                                  SizedBox(width: 24, height: 24,
                                    child: IconButton(padding: EdgeInsets.zero, iconSize: 14,
                                      icon: const Icon(Icons.add, color: AppColors.primary),
                                      onPressed: () => onQtyChange(item, 1))),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item.name, style: const TextStyle(fontSize: 13,
                                    fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                                  if (item.note.isNotEmpty)
                                    Text(item.note, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                                ],
                              ),
                            ),
                            Text('\$${(item.price * item.qty).toStringAsFixed(2)}',
                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                          ],
                        ),
                      );
                    },
                  ),
          ),
          Divider(height: 1, color: border),
          // Quick actions
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Expanded(child: _QuickAction(icon: Icons.percent, label: 'Discount', onTap: () {})),
                const SizedBox(width: 6),
                Expanded(child: _QuickAction(icon: Icons.call_split, label: 'Split Bill', onTap: () {})),
                const SizedBox(width: 6),
                Expanded(child: _QuickAction(icon: Icons.note_add_outlined, label: 'Add Note', onTap: () {})),
              ],
            ),
          ),
          Divider(height: 1, color: border),
          // Totals
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _TotalRow('Subtotal', '\$${subtotal.toStringAsFixed(2)}'),
                const SizedBox(height: 6),
                _TotalRow('Service Charge (10%)', '\$${service.toStringAsFixed(2)}'),
                const SizedBox(height: 6),
                _TotalRow('Tax (GST)', '\$${tax.toStringAsFixed(2)}'),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Text('Total', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                    const Spacer(),
                    Text('\$${total.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.primary)),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity, height: 48,
                  child: ElevatedButton.icon(
                    onPressed: cart.isEmpty ? null : onPay,
                    icon: const Icon(Icons.payment_rounded),
                    label: const Text('PROCEED TO PAY', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
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

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _QuickAction({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(8),
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(icon, size: 18, color: AppColors.textSecondary),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
        ],
      ),
    ),
  );
}

class _TotalRow extends StatelessWidget {
  final String label;
  final String value;
  const _TotalRow(this.label, this.value);

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Text(label, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
      const Spacer(),
      Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
    ],
  );
}

class _PaymentDialog extends StatefulWidget {
  final double total;
  final VoidCallback onClose;
  final VoidCallback onComplete;
  const _PaymentDialog({required this.total, required this.onClose, required this.onComplete});
  @override
  State<_PaymentDialog> createState() => _PaymentDialogState();
}

class _PaymentDialogState extends State<_PaymentDialog> {
  String _method = 'card';

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 340,
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(left: BorderSide(color: AppColors.border)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Text('Payment', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                const Spacer(),
                IconButton(onPressed: widget.onClose, icon: const Icon(Icons.close, size: 18)),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(color: AppColors.primarySurface, borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      children: [
                        const Text('Total Amount', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                        const SizedBox(height: 4),
                        Text('\$${widget.total.toStringAsFixed(2)}',
                          style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w800, color: AppColors.primary)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Align(alignment: Alignment.centerLeft,
                    child: Text('Payment Method', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600))),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(child: _MethodBtn(icon: Icons.credit_card, label: 'Card', value: 'card',
                        selected: _method == 'card', onTap: () => setState(() => _method = 'card'))),
                      const SizedBox(width: 10),
                      Expanded(child: _MethodBtn(icon: Icons.money_rounded, label: 'Cash', value: 'cash',
                        selected: _method == 'cash', onTap: () => setState(() => _method = 'cash'))),
                      const SizedBox(width: 10),
                      Expanded(child: _MethodBtn(icon: Icons.qr_code_rounded, label: 'QR Pay', value: 'qr',
                        selected: _method == 'qr', onTap: () => setState(() => _method = 'qr'))),
                    ],
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity, height: 48,
                    child: ElevatedButton(
                      onPressed: widget.onComplete,
                      child: const Text('Complete Payment', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
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

class _MethodBtn extends StatelessWidget {
  final IconData icon;
  final String label, value;
  final bool selected;
  final VoidCallback onTap;
  const _MethodBtn({required this.icon, required this.label, required this.value,
    required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: selected ? AppColors.primarySurface : AppColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: selected ? AppColors.primary : AppColors.border, width: selected ? 2 : 1),
      ),
      child: Column(
        children: [
          Icon(icon, size: 22, color: selected ? AppColors.primary : AppColors.textSecondary),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600,
            color: selected ? AppColors.primary : AppColors.textSecondary)),
        ],
      ),
    ),
  );
}
