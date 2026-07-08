import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_provider.dart';
import '../providers/pos_provider.dart';

class CartPanel extends StatelessWidget {
  const CartPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final pos = context.watch<PosProvider>();
    final isDark = context.watch<ThemeProvider>().isDark;
    final bgColor = isDark ? AppColors.darkSurface : AppColors.white;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;
    final textColor = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final mutedColor = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    return Container(
      color: bgColor,
      decoration: BoxDecoration(border: Border(left: BorderSide(color: borderColor))),
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
                      Text('Order ${pos.orderNumber}',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: textColor)),
                      Text(pos.tableInfo, style: TextStyle(fontSize: 12, color: mutedColor)),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: pos.clearCart,
                  icon: const Icon(Icons.delete_outline_rounded, size: 18, color: AppColors.error),
                  tooltip: 'Clear Cart',
                ),
              ],
            ),
          ),
          Divider(height: 1, color: borderColor),
          // Cart items
          Expanded(
            child: pos.cart.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.shopping_cart_outlined, size: 40, color: mutedColor),
                        const SizedBox(height: 8),
                        Text('Cart is empty', style: TextStyle(color: mutedColor)),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(12),
                    itemCount: pos.cart.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 4),
                    itemBuilder: (context, i) => _CartItemRow(item: pos.cart[i], isDark: isDark),
                  ),
          ),
          // Action buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                _ActionChip(icon: Icons.percent_rounded, label: 'Discount', isDark: isDark),
                const SizedBox(width: 8),
                _ActionChip(icon: Icons.call_split_rounded, label: 'Split Bill', isDark: isDark),
                const SizedBox(width: 8),
                _ActionChip(icon: Icons.note_alt_outlined, label: 'Add Note', isDark: isDark),
              ],
            ),
          ),
          Divider(height: 1, color: borderColor),
          // Totals
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _TotalRow('Subtotal', '\$${pos.subtotal.toStringAsFixed(2)}', textColor, mutedColor, false),
                const SizedBox(height: 6),
                _TotalRow('Service Charge (10%)', '\$${pos.serviceCharge.toStringAsFixed(2)}', textColor, mutedColor, false),
                const SizedBox(height: 6),
                _TotalRow('Tax (GST)', '\$${pos.tax.toStringAsFixed(2)}', textColor, mutedColor, false),
                const SizedBox(height: 10),
                Divider(height: 1, color: borderColor),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text('Total', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: textColor)),
                    const Spacer(),
                    Text('\$${pos.total.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.primary)),
                  ],
                ),
              ],
            ),
          ),
          // Pay button
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: pos.cart.isEmpty ? null : () => _showPaymentDialog(context, pos),
                icon: const Icon(Icons.payment_rounded, size: 18),
                label: const Text('PROCEED TO PAY', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showPaymentDialog(BuildContext context, PosProvider pos) {
    showDialog(
      context: context,
      builder: (_) => _PaymentDialog(total: pos.total),
    );
  }
}

class _CartItemRow extends StatelessWidget {
  final CartItem item;
  final bool isDark;
  const _CartItemRow({required this.item, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final pos = context.read<PosProvider>();
    final textColor = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final mutedColor = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
    final bg = isDark ? AppColors.darkCard : AppColors.background;

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8)),
      child: Row(
        children: [
          // Qty controls
          Row(
            children: [
              GestureDetector(
                onTap: () => pos.updateQuantity(item.product.id, item.quantity - 1),
                child: Container(
                  width: 22, height: 22,
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkBorder : AppColors.border,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Icon(Icons.remove_rounded, size: 12),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text('${item.quantity}x',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primary)),
              ),
              GestureDetector(
                onTap: () => pos.updateQuantity(item.product.id, item.quantity + 1),
                child: Container(
                  width: 22, height: 22,
                  decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(4)),
                  child: const Icon(Icons.add_rounded, size: 12, color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.product.name,
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: textColor),
                    overflow: TextOverflow.ellipsis),
                if (item.note != null)
                  Text(item.note!, style: TextStyle(fontSize: 11, color: mutedColor)),
              ],
            ),
          ),
          Text('\$${item.total.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: textColor)),
        ],
      ),
    );
  }
}

class _ActionChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isDark;
  const _ActionChip({required this.icon, required this.label, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: OutlinedButton(
        onPressed: () {},
        style: OutlinedButton.styleFrom(
          foregroundColor: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
          side: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.border),
          padding: const EdgeInsets.symmetric(vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Column(
          children: [
            Icon(icon, size: 14),
            const SizedBox(height: 2),
            Text(label, style: const TextStyle(fontSize: 10)),
          ],
        ),
      ),
    );
  }
}

class _TotalRow extends StatelessWidget {
  final String label;
  final String value;
  final Color textColor;
  final Color mutedColor;
  final bool bold;
  const _TotalRow(this.label, this.value, this.textColor, this.mutedColor, this.bold);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(label, style: TextStyle(fontSize: 13, color: mutedColor)),
        const Spacer(),
        Text(value, style: TextStyle(fontSize: 13, fontWeight: bold ? FontWeight.w700 : FontWeight.w500, color: textColor)),
      ],
    );
  }
}

class _PaymentDialog extends StatefulWidget {
  final double total;
  const _PaymentDialog({required this.total});

  @override
  State<_PaymentDialog> createState() => _PaymentDialogState();
}

class _PaymentDialogState extends State<_PaymentDialog> {
  String _method = 'Card';

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SizedBox(
        width: 400,
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Payment', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
              Text('Total: \$${widget.total.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: AppColors.primary)),
              const SizedBox(height: 20),
              const Text('Payment Method', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 10),
              Row(
                children: ['Card', 'Cash', 'QR Code', 'Voucher'].map((m) {
                  final active = _method == m;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _method = m),
                      child: Container(
                        margin: const EdgeInsets.only(right: 6),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: active ? AppColors.primary : AppColors.background,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: active ? AppColors.primary : AppColors.border),
                        ),
                        child: Center(
                          child: Text(m,
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: active ? Colors.white : AppColors.textPrimary)),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
                      child: const Text('Confirm Payment'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
