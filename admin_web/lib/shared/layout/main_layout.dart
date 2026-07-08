import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/theme_provider.dart';
import '../../core/constants/app_constants.dart';
import 'sidebar.dart';
import 'top_bar.dart';

class MainLayout extends StatefulWidget {
  final Widget child;
  const MainLayout({super.key, required this.child});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  bool _sidebarCollapsed = false;

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDark;
    final bgColor = isDark ? AppColors.darkBackground : AppColors.background;
    final sidebarBg = isDark ? AppColors.darkSurface : AppColors.white;

    return Scaffold(
      backgroundColor: bgColor,
      body: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: _sidebarCollapsed
                ? AppConstants.sidebarCollapsedWidth
                : AppConstants.sidebarWidth,
            color: sidebarBg,
            child: Sidebar(
              collapsed: _sidebarCollapsed,
              currentRoute: GoRouterState.of(context).uri.toString(),
              onToggle: () => setState(() => _sidebarCollapsed = !_sidebarCollapsed),
            ),
          ),
          Expanded(
            child: Column(
              children: [
                TopBar(sidebarCollapsed: _sidebarCollapsed),
                Expanded(
                  child: widget.child,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
