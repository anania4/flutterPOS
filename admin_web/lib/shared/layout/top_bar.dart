import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/theme_provider.dart';
import '../../core/constants/app_constants.dart';

class TopBar extends StatelessWidget {
  final bool sidebarCollapsed;
  const TopBar({super.key, required this.sidebarCollapsed});

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDark;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;
    final bgColor = isDark ? AppColors.darkSurface : AppColors.white;
    final textColor = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final mutedColor = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    return Container(
      height: AppConstants.topBarHeight,
      color: bgColor,
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: borderColor, width: 1)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          // Branch selector
          _BranchSelector(isDark: isDark),
          const SizedBox(width: 16),
          // Search
          Expanded(
            child: Container(
              height: 38,
              constraints: const BoxConstraints(maxWidth: 360),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search data...',
                  prefixIcon: Icon(Icons.search_rounded, size: 18, color: mutedColor),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                  isDense: true,
                ),
              ),
            ),
          ),
          const Spacer(),
          // Actions
          _IconBtn(
            icon: Icons.notifications_outlined,
            badge: '2',
            isDark: isDark,
            onTap: () {},
          ),
          const SizedBox(width: 8),
          _IconBtn(
            icon: Icons.help_outline_rounded,
            isDark: isDark,
            onTap: () {},
          ),
          const SizedBox(width: 8),
          // Theme toggle
          IconButton(
            onPressed: () => context.read<ThemeProvider>().toggleTheme(),
            icon: Icon(
              isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
              size: 18,
              color: mutedColor,
            ),
            tooltip: isDark ? 'Light Mode' : 'Dark Mode',
          ),
          const SizedBox(width: 8),
          // User avatar
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: AppColors.primary,
                child: const Text('AR', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
              ),
              const SizedBox(width: 8),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Alex Rivera', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: textColor)),
                  Text('General Manager', style: TextStyle(fontSize: 10, color: mutedColor)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BranchSelector extends StatelessWidget {
  final bool isDark;
  const _BranchSelector({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.border),
        borderRadius: BorderRadius.circular(8),
        color: isDark ? AppColors.darkCard : AppColors.background,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.store_rounded, size: 14, color: AppColors.primary),
          const SizedBox(width: 6),
          Text(
            'Downtown Branch',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
            ),
          ),
          const SizedBox(width: 4),
          Icon(Icons.keyboard_arrow_down_rounded, size: 16, color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary),
        ],
      ),
    );
  }
}

class _IconBtn extends StatelessWidget {
  final IconData icon;
  final String? badge;
  final bool isDark;
  final VoidCallback onTap;

  const _IconBtn({required this.icon, required this.isDark, required this.onTap, this.badge});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        IconButton(
          onPressed: onTap,
          icon: Icon(icon, size: 20, color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary),
        ),
        if (badge != null)
          Positioned(
            right: 6,
            top: 6,
            child: Container(
              width: 16,
              height: 16,
              decoration: const BoxDecoration(color: AppColors.error, shape: BoxShape.circle),
              child: Center(
                child: Text(badge!, style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
      ],
    );
  }
}
