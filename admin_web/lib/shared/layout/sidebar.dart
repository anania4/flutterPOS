import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/theme_provider.dart';
import '../../core/constants/app_constants.dart';

class _NavItem {
  final String label;
  final IconData icon;
  final String route;
  const _NavItem(this.label, this.icon, this.route);
}

const _navItems = [
  _NavItem('Dashboard', Icons.grid_view_rounded, '/dashboard'),
  _NavItem('POS', Icons.point_of_sale_rounded, '/pos'),
  _NavItem('Branches', Icons.store_rounded, '/branches'),
  _NavItem('Orders', Icons.receipt_long_rounded, '/orders'),
  _NavItem('Inventory', Icons.inventory_2_rounded, '/inventory'),
  _NavItem('Staff', Icons.badge_rounded, '/staff'),
  _NavItem('Customers', Icons.people_rounded, '/customers'),
  _NavItem('Delivery', Icons.delivery_dining_rounded, '/delivery'),
  _NavItem('Purchases', Icons.shopping_cart_rounded, '/purchases'),
  _NavItem('Reports', Icons.bar_chart_rounded, '/reports'),
  _NavItem('Settings', Icons.settings_rounded, '/settings'),
];

class Sidebar extends StatelessWidget {
  final bool collapsed;
  final String currentRoute;
  final VoidCallback onToggle;

  const Sidebar({
    super.key,
    required this.collapsed,
    required this.currentRoute,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDark;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;

    return Container(
      decoration: BoxDecoration(
        border: Border(right: BorderSide(color: borderColor, width: 1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLogo(context, isDark),
          const SizedBox(height: 8),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              children: _navItems
                  .map((item) => _NavTile(
                        item: item,
                        isActive: currentRoute.startsWith(item.route),
                        collapsed: collapsed,
                      ))
                  .toList(),
            ),
          ),
          _buildFooter(context, isDark),
        ],
      ),
    );
  }

  Widget _buildLogo(BuildContext context, bool isDark) {
    return Container(
      height: AppConstants.topBarHeight,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.local_cafe_rounded, color: Colors.white, size: 18),
          ),
          if (!collapsed) ...[
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppConstants.appName,
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    AppConstants.appSubtitle,
                    style: TextStyle(
                      color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ],
          IconButton(
            onPressed: onToggle,
            icon: Icon(
              collapsed ? Icons.menu_open_rounded : Icons.menu_rounded,
              size: 18,
              color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
            ),
            tooltip: collapsed ? 'Expand' : 'Collapse',
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.primary,
            child: const Text('AR', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
          ),
          if (!collapsed) ...[
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Alex Rivera',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary),
                      overflow: TextOverflow.ellipsis),
                  Text('General Manager',
                      style: TextStyle(fontSize: 10, color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary),
                      overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _NavTile extends StatefulWidget {
  final _NavItem item;
  final bool isActive;
  final bool collapsed;

  const _NavTile({required this.item, required this.isActive, required this.collapsed});

  @override
  State<_NavTile> createState() => _NavTileState();
}

class _NavTileState extends State<_NavTile> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDark;
    final isActive = widget.isActive;

    Color bgColor;
    Color iconColor;
    Color textColor;

    if (isActive) {
      bgColor = AppColors.primarySurface;
      iconColor = AppColors.primary;
      textColor = AppColors.primary;
    } else if (_hovered) {
      bgColor = isDark ? AppColors.darkBorder : AppColors.divider;
      iconColor = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
      textColor = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    } else {
      bgColor = Colors.transparent;
      iconColor = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
      textColor = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () => context.go(widget.item.route),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: const EdgeInsets.only(bottom: 2),
          padding: EdgeInsets.symmetric(
            horizontal: widget.collapsed ? 0 : 10,
            vertical: 9,
          ),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: widget.collapsed ? MainAxisAlignment.center : MainAxisAlignment.start,
            children: [
              Icon(widget.item.icon, size: 18, color: iconColor),
              if (!widget.collapsed) ...[
                const SizedBox(width: 10),
                Text(
                  widget.item.label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                    color: textColor,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
