import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme/app_colors.dart';
import '../core/providers/auth_provider.dart';
import '../core/providers/theme_provider.dart';

class TopNavBar extends StatelessWidget {
  const TopNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDark;
    final auth = context.watch<AuthProvider>();
    final bg = isDark ? AppColors.darkSurface : AppColors.white;
    final border = isDark ? AppColors.darkBorder : AppColors.border;

    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: bg,
        border: Border(bottom: BorderSide(color: border)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          // Branch selector
          _BranchSelector(isDark: isDark, auth: auth),
          const SizedBox(width: 16),
          // Search
          Expanded(
            child: Container(
              height: 36,
              constraints: const BoxConstraints(maxWidth: 320),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search data...',
                  prefixIcon: const Icon(Icons.search, size: 18, color: AppColors.textTertiary),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  filled: true,
                  fillColor: isDark ? AppColors.darkCard : AppColors.background,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.primary),
                  ),
                ),
                style: TextStyle(fontSize: 14, color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary),
              ),
            ),
          ),
          const Spacer(),
          // Theme toggle
          IconButton(
            icon: Icon(isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
              color: AppColors.textSecondary, size: 20),
            onPressed: () => context.read<ThemeProvider>().toggleTheme(),
            tooltip: isDark ? 'Light Mode' : 'Dark Mode',
          ),
          // Notifications
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined, color: AppColors.textSecondary, size: 20),
                onPressed: () {},
              ),
              Positioned(
                top: 8, right: 8,
                child: Container(
                  width: 8, height: 8,
                  decoration: const BoxDecoration(color: AppColors.error, shape: BoxShape.circle),
                ),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.help_outline_rounded, color: AppColors.textSecondary, size: 20),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
          // User avatar + name
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: AppColors.primarySurface,
                child: Text(auth.userInitials,
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary),
                ),
              ),
              const SizedBox(width: 8),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(auth.userName,
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary),
                  ),
                  Text(auth.userRole,
                    style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                  ),
                ],
              ),
              const SizedBox(width: 4),
              PopupMenuButton(
                icon: const Icon(Icons.keyboard_arrow_down, size: 16, color: AppColors.textSecondary),
                itemBuilder: (_) => [
                  const PopupMenuItem(value: 'profile', child: Text('Profile')),
                  const PopupMenuItem(value: 'logout', child: Text('Logout')),
                ],
                onSelected: (v) {
                  if (v == 'logout') context.read<AuthProvider>().logout();
                },
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
  final AuthProvider auth;
  const _BranchSelector({required this.isDark, required this.auth});

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
        children: [
          const Icon(Icons.store_rounded, size: 14, color: AppColors.primary),
          const SizedBox(width: 6),
          Text(auth.currentBranch,
            style: TextStyle(
              fontSize: 13, fontWeight: FontWeight.w500,
              color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
            ),
          ),
          const SizedBox(width: 4),
          const Icon(Icons.keyboard_arrow_down, size: 14, color: AppColors.textSecondary),
        ],
      ),
    );
  }
}
