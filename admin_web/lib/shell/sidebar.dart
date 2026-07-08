import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../core/theme/app_colors.dart';
import '../core/providers/auth_provider.dart';
import '../core/providers/theme_provider.dart';

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
  _NavItem('Staff', Icons.people_rounded, '/staff'),
  _NavItem('Customers', Icons.person_rounded, '/customers'),
  _NavItem('Delivery', Icons.delivery_dining_rounded, '/delivery'),
  _NavItem('Purchases', Icons.shopping_cart_rounded, '/purchases'),
  _NavItem('Reports', Icons.bar_chart_rounded, '/reports'),
  _NavItem('Settings', Icons.settings_rounded, '/settings'),
];

class AppSidebar extends StatelessWidget {
  const AppSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDark;
    final auth = context.watch<AuthProvider>();
    final location = GoRouterState.of(context).matchedLocation;
    final bg = isDark ? AppColors.darkSurface : AppColors.white;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;

    return Container(
      width: 220,
      decoration: BoxDecoration(
        color: bg,
        border: Border(right: BorderSide(color: borderColor)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo area
          Container(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
            child: Row(
              children: [
                Container(
                  width: 36, height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.local_cafe_rounded, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Artisan Brew',
                      style: TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                      ),
                    ),
                    Text('Admin Terminal',
                      style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          const SizedBox(height: 8),
          // Nav items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: _navItems.map((item) {
                final isActive = location.startsWith(item.route);
                return _SidebarTile(item: item, isActive: isActive, isDark: isDark);
              }).toList(),
            ),
          ),
          const Divider(height: 1),
          // KDS shortcut
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: _KdsTile(isDark: isDark),
          ),
          const Divider(height: 1),
          // User profile at bottom
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: AppColors.primarySurface,
                  child: Text(auth.userInitials,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(auth.userName,
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(auth.userRole,
                        style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                      ),
                    ],
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

class _SidebarTile extends StatelessWidget {
  final _NavItem item;
  final bool isActive;
  final bool isDark;
  const _SidebarTile({required this.item, required this.isActive, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Material(
        color: isActive ? AppColors.primarySurface : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () => context.go(item.route),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Icon(item.icon,
                  size: 18,
                  color: isActive ? AppColors.primary : AppColors.textSecondary,
                ),
                const SizedBox(width: 10),
                Text(item.label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                    color: isActive ? AppColors.primary
                        : (isDark ? AppColors.darkTextSecondary : AppColors.textSecondary),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _KdsTile extends StatelessWidget {
  final bool isDark;
  const _KdsTile({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isDark ? AppColors.darkCard : AppColors.background,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => context.go('/kds'),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              const Icon(Icons.kitchen_rounded, size: 18, color: AppColors.textSecondary),
              const SizedBox(width: 10),
              Text('Kitchen Display',
                style: TextStyle(
                  fontSize: 13, fontWeight: FontWeight.w500,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primarySurface,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text('KDS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.primary)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
