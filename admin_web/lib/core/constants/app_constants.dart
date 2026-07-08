class AppConstants {
  static const String appName = 'Artisan Brew';
  static const String appSubtitle = 'Admin Terminal';

  // Layout
  static const double sidebarWidth = 220.0;
  static const double sidebarCollapsedWidth = 64.0;
  static const double topBarHeight = 64.0;
  static const double cardRadius = 12.0;
  static const double pageHPad = 24.0;
  static const double pageVPad = 24.0;

  // Breakpoints
  static const double mobileBreakpoint = 600.0;
  static const double tabletBreakpoint = 1024.0;
  static const double desktopBreakpoint = 1280.0;
}

class NavItem {
  final String label;
  final String icon;
  final String route;

  const NavItem({required this.label, required this.icon, required this.route});
}
