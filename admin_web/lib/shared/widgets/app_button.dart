import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

enum AppButtonStyle { primary, secondary, outlined, danger, ghost }

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final AppButtonStyle style;
  final bool isLoading;
  final bool small;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.style = AppButtonStyle.primary,
    this.isLoading = false,
    this.small = false,
  });

  @override
  Widget build(BuildContext context) {
    final h = small ? 36.0 : 44.0;
    final px = small ? 14.0 : 20.0;
    final fs = small ? 13.0 : 14.0;

    Color bg, fg, border;
    switch (style) {
      case AppButtonStyle.primary:
        bg = AppColors.primary; fg = Colors.white; border = AppColors.primary;
      case AppButtonStyle.secondary:
        bg = AppColors.primarySurface; fg = AppColors.primary; border = AppColors.primarySurface;
      case AppButtonStyle.outlined:
        bg = Colors.transparent; fg = AppColors.textPrimary; border = AppColors.border;
      case AppButtonStyle.danger:
        bg = Colors.transparent; fg = AppColors.error; border = AppColors.error;
      case AppButtonStyle.ghost:
        bg = Colors.transparent; fg = AppColors.textSecondary; border = Colors.transparent;
    }

    return SizedBox(
      height: h,
      child: Material(
        color: bg,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: px),
            decoration: BoxDecoration(
              border: Border.all(color: border),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isLoading)
                  SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2, color: fg))
                else if (icon != null) ...[
                  Icon(icon, size: 16, color: fg),
                  const SizedBox(width: 6),
                ],
                Text(label, style: TextStyle(fontSize: fs, fontWeight: FontWeight.w600, color: fg)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
