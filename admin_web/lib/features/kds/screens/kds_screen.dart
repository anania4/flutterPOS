import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';

enum KdsOrderState { pending, preparing, ready }

class _KdsOrder {
  final String id;
  final String type;
  final String tableOrName;
  final List<_KdsItem> items;
  final String? specialNote;
  KdsOrderState state;
  Duration elapsed;
  _KdsOrder({required this.id, required this.type, required this.tableOrName,
    required this.items, this.specialNote, this.state = KdsOrderState.pending,
    required this.elapsed});
}

class _KdsItem {
  final String name;
  final int qty;
  final String? note;
  const _KdsItem(this.name, this.qty, [this.note]);
}

class KdsScreen extends StatefulWidget {
  const KdsScreen({super.key});
  @override
  State<KdsScreen> createState() => _KdsScreenState();
}

class _KdsScreenState extends State<KdsScreen> with SingleTickerProviderStateMixin {
  late TabController _tab;
  bool _showCompleted = false;

  final List<_KdsOrder> _orders = [
    _KdsOrder(id: '#2492', type: 'DINE-IN', tableOrName: 'TABLE 12',
      items: [_KdsItem('Flat White', 2, 'Oat Milk, Extra Hot'), _KdsItem('Avocado Smash', 1, 'No Onions, Gluten Free Toast')],
      specialNote: 'Customer has a severe nut allergy. Please sanitize surfaces.',
      state: KdsOrderState.preparing, elapsed: const Duration(minutes: 12, seconds: 15)),
    _KdsOrder(id: '#2495', type: 'DELIVERY', tableOrName: 'UBEREATS',
      items: [_KdsItem('Artisan Burger', 1, 'Rare, No Pickle'), _KdsItem('Truffle Fries', 1)],
      state: KdsOrderState.preparing, elapsed: const Duration(minutes: 6, seconds: 42)),
    _KdsOrder(id: '#2498', type: 'TAKEAWAY', tableOrName: 'SARAH M.',
      items: [_KdsItem('Iced Latte', 1, 'Almond Milk, 1 Sugar')],
      state: KdsOrderState.pending, elapsed: const Duration(minutes: 1, seconds: 15)),
    _KdsOrder(id: '#2499', type: 'DINE-IN', tableOrName: 'TABLE 4',
      items: [_KdsItem('Cappuccino', 3)],
      state: KdsOrderState.pending, elapsed: const Duration(seconds: 45)),
    _KdsOrder(id: '#2500', type: 'TAKEAWAY', tableOrName: 'BEN J.',
      items: [_KdsItem('Bacon Roll', 1, 'Brown Sauce')],
      state: KdsOrderState.pending, elapsed: const Duration(seconds: 12)),
  ];

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() { _tab.dispose(); super.dispose(); }

  String _fmtElapsed(Duration d) {
    final m = d.inMinutes.toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  Color _elapsedColor(Duration d) {
    if (d.inMinutes >= 10) return AppColors.error;
    if (d.inMinutes >= 5) return AppColors.warning;
    return AppColors.success;
  }

  Color _cardBg(KdsOrderState state, Duration elapsed) {
    if (state == KdsOrderState.preparing && elapsed.inMinutes >= 10) return AppColors.kdsCardUrgent;
    if (state == KdsOrderState.preparing && elapsed.inMinutes >= 5) return AppColors.kdsCardWarning;
    if (state == KdsOrderState.ready) return AppColors.kdsCardReady;
    return AppColors.kdsCard;
  }

  @override
  Widget build(BuildContext context) {
    final active = _orders.where((o) => o.state != KdsOrderState.ready || _showCompleted).toList();
    return Scaffold(
      backgroundColor: AppColors.kdsBackground,
      body: Column(
        children: [
          // KDS top bar
          Container(
            color: AppColors.kdsBackground,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              children: [
                const Text('Artisan Brew KDS',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)),
                const SizedBox(width: 20),
                _KdsTabBtn(label: 'Active Orders', active: !_showCompleted,
                  onTap: () => setState(() => _showCompleted = false)),
                const SizedBox(width: 8),
                _KdsTabBtn(label: 'Completed', active: _showCompleted,
                  onTap: () => setState(() => _showCompleted = true)),
                const Spacer(),
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  const Text('ACTIVE ORDERS', style: TextStyle(color: AppColors.darkTextSecondary, fontSize: 10)),
                  Text('${_orders.where((o) => o.state != KdsOrderState.ready).length}',
                    style: const TextStyle(color: AppColors.primaryLight, fontSize: 20, fontWeight: FontWeight.w800)),
                ]),
                const SizedBox(width: 24),
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  const Text('AVG PREP TIME', style: TextStyle(color: AppColors.darkTextSecondary, fontSize: 10)),
                  const Text('08:42', style: TextStyle(color: AppColors.primaryLight, fontSize: 20, fontWeight: FontWeight.w800)),
                ]),
                const SizedBox(width: 16),
                IconButton(icon: const Icon(Icons.notifications_outlined, color: Colors.white54), onPressed: () {}),
                IconButton(icon: const Icon(Icons.settings, color: Colors.white54), onPressed: () => context.go('/dashboard')),
              ],
            ),
          ),
          // Order cards grid
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Wrap(
                spacing: 14,
                runSpacing: 14,
                children: active.map((order) => SizedBox(
                  width: 300,
                  child: _KdsCard(
                    order: order,
                    elapsed: _fmtElapsed(order.elapsed),
                    elapsedColor: _elapsedColor(order.elapsed),
                    cardBg: _cardBg(order.state, order.elapsed),
                    onAction: () => setState(() {
                      if (order.state == KdsOrderState.pending) {
                        order.state = KdsOrderState.preparing;
                      } else if (order.state == KdsOrderState.preparing) {
                        order.state = KdsOrderState.ready;
                      }
                    }),
                  ),
                )).toList(),
              ),
            ),
          ),
          // Status bar
          Container(
            color: const Color(0xFF111111),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              children: [
                Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.success, shape: BoxShape.circle)),
                const SizedBox(width: 6),
                const Text('STATION: KITCHEN-01 (ACTIVE)', style: TextStyle(color: Colors.white54, fontSize: 11)),
                const SizedBox(width: 16),
                const Text('|', style: TextStyle(color: Colors.white38)),
                const SizedBox(width: 16),
                const Text('PRINTER: ONLINE', style: TextStyle(color: Colors.white54, fontSize: 11)),
                const Spacer(),
                const Text('2:41:15 PM', style: TextStyle(color: Colors.white54, fontSize: 11)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _KdsTabBtn extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;
  const _KdsTabBtn({required this.label, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: active ? AppColors.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: active ? AppColors.primary : Colors.white24),
      ),
      child: Text(label, style: TextStyle(
        color: active ? Colors.white : Colors.white54, fontSize: 13, fontWeight: FontWeight.w600)),
    ),
  );
}

class _KdsCard extends StatelessWidget {
  final _KdsOrder order;
  final String elapsed;
  final Color elapsedColor;
  final Color cardBg;
  final VoidCallback onAction;
  const _KdsCard({required this.order, required this.elapsed, required this.elapsedColor,
    required this.cardBg, required this.onAction});

  String get _typeColor {
    switch (order.type) {
      case 'DINE-IN': return '#FF6B6B';
      case 'DELIVERY': return '#FFD166';
      default: return '#06D6A0';
    }
  }

  Color get _typeColorVal {
    switch (order.type) {
      case 'DINE-IN': return const Color(0xFFFF6B6B);
      case 'DELIVERY': return const Color(0xFFFFD166);
      default: return const Color(0xFF06D6A0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isPending = order.state == KdsOrderState.pending;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(order.id, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)),
              const Spacer(),
              Text(elapsed, style: TextStyle(color: elapsedColor, fontSize: 16, fontWeight: FontWeight.w700)),
            ],
          ),
          Row(
            children: [
              Text('${order.type} • ${order.tableOrName}',
                style: TextStyle(color: _typeColorVal, fontSize: 11, fontWeight: FontWeight.w700)),
              const Spacer(),
              const Text('ELAPSED', style: TextStyle(color: Colors.white38, fontSize: 10)),
            ],
          ),
          const SizedBox(height: 14),
          ...order.items.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(child: Text('${item.qty}x ${item.name}',
                      style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600))),
                    Text('Qty ${item.qty}', style: const TextStyle(color: Colors.white54, fontSize: 12)),
                  ],
                ),
                if (item.note != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 8, top: 2),
                    child: Row(
                      children: [
                        Container(width: 2, height: 12, color: AppColors.primaryLight),
                        const SizedBox(width: 6),
                        Text('— ${item.note}', style: const TextStyle(color: Colors.white54, fontSize: 11)),
                      ],
                    ),
                  ),
              ],
            ),
          )),
          if (order.specialNote != null) ...[
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: AppColors.error.withOpacity(0.5)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Icon(Icons.warning_rounded, size: 12, color: AppColors.error),
                    const SizedBox(width: 4),
                    Text('SPECIAL INSTRUCTIONS', style: TextStyle(color: AppColors.error,
                      fontSize: 10, fontWeight: FontWeight.w700)),
                  ]),
                  const SizedBox(height: 4),
                  Text('"${order.specialNote}"',
                    style: const TextStyle(color: Colors.white70, fontSize: 11)),
                ],
              ),
            ),
          ],
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: isPending
                ? OutlinedButton.icon(
                    onPressed: onAction,
                    icon: const Icon(Icons.play_arrow_rounded, size: 16),
                    label: const Text('START PREPARING',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primaryLight,
                      side: const BorderSide(color: AppColors.primaryLight),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  )
                : ElevatedButton.icon(
                    onPressed: onAction,
                    icon: const Icon(Icons.check_circle_outline, size: 16),
                    label: const Text('MARK AS READY',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
