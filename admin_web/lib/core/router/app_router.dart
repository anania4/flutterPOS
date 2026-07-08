import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/providers/auth_provider.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/forgot_password_screen.dart';
import '../../features/dashboard/screens/dashboard_screen.dart';
import '../../features/pos/screens/pos_screen.dart';
import '../../features/orders/screens/orders_screen.dart';
import '../../features/kds/screens/kds_screen.dart';
import '../../features/inventory/screens/inventory_screen.dart';
import '../../features/inventory/screens/recipe_screen.dart';
import '../../features/branches/screens/branches_screen.dart';
import '../../features/staff/screens/staff_screen.dart';
import '../../features/reports/screens/reports_screen.dart';
import '../../features/settings/screens/settings_screen.dart';
import '../../features/customers/screens/customers_screen.dart';
import '../../features/delivery/screens/delivery_screen.dart';
import '../../features/purchases/screens/purchases_screen.dart';
import '../../shell/main_shell.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

GoRouter createRouter(AuthProvider authProvider) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/login',
    redirect: (context, state) {
      final isAuth = authProvider.isAuthenticated;
      final isLoginPage = state.matchedLocation == '/login' || state.matchedLocation == '/forgot-password';
      if (!isAuth && !isLoginPage) return '/login';
      if (isAuth && isLoginPage) return '/dashboard';
      return null;
    },
    refreshListenable: authProvider,
    routes: [
      GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
      GoRoute(path: '/forgot-password', builder: (_, __) => const ForgotPasswordScreen()),
      GoRoute(path: '/kds', builder: (_, __) => const KdsScreen()),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          GoRoute(path: '/dashboard', builder: (_, __) => const DashboardScreen()),
          GoRoute(path: '/pos', builder: (_, __) => const PosScreen()),
          GoRoute(path: '/orders', builder: (_, __) => const OrdersScreen()),
          GoRoute(path: '/inventory', builder: (_, __) => const InventoryScreen()),
          GoRoute(path: '/inventory/recipes', builder: (_, __) => const RecipeScreen()),
          GoRoute(path: '/branches', builder: (_, __) => const BranchesScreen()),
          GoRoute(path: '/staff', builder: (_, __) => const StaffScreen()),
          GoRoute(path: '/customers', builder: (_, __) => const CustomersScreen()),
          GoRoute(path: '/delivery', builder: (_, __) => const DeliveryScreen()),
          GoRoute(path: '/purchases', builder: (_, __) => const PurchasesScreen()),
          GoRoute(path: '/reports', builder: (_, __) => const ReportsScreen()),
          GoRoute(path: '/settings', builder: (_, __) => const SettingsScreen()),
        ],
      ),
    ],
  );
}
