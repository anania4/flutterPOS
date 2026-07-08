import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});
  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailCtrl = TextEditingController();
  bool _sent = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Container(
          width: 420,
          padding: const EdgeInsets.all(40),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 24, offset: const Offset(0, 8))],
          ),
          child: _sent ? _successView() : _formView(),
        ),
      ),
    );
  }

  Widget _formView() => Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Container(padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: AppColors.primarySurface, borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.local_cafe_rounded, color: AppColors.primary, size: 22)),
          const SizedBox(width: 10),
          const Text('Artisan Brew', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
        ],
      ),
      const SizedBox(height: 28),
      const Text('Reset Password', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
      const SizedBox(height: 6),
      const Text("Enter your email and we'll send a reset link.", style: TextStyle(fontSize: 14, color: AppColors.textSecondary)),
      const SizedBox(height: 28),
      const Text('Email Address', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
      const SizedBox(height: 6),
      TextField(controller: _emailCtrl, keyboardType: TextInputType.emailAddress,
        decoration: const InputDecoration(hintText: 'admin@artisanbrew.com',
          prefixIcon: Icon(Icons.email_outlined, size: 18, color: AppColors.textTertiary))),
      const SizedBox(height: 20),
      SizedBox(
        width: double.infinity, height: 48,
        child: ElevatedButton(
          onPressed: () => setState(() => _sent = true),
          child: const Text('Send Reset Link', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
        ),
      ),
      const SizedBox(height: 12),
      Center(
        child: TextButton(
          onPressed: () => context.go('/login'),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.arrow_back, size: 14, color: AppColors.primary),
              SizedBox(width: 4),
              Text('Back to login', style: TextStyle(fontSize: 13, color: AppColors.primary)),
            ],
          ),
        ),
      ),
    ],
  );

  Widget _successView() => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(color: AppColors.successSurface, shape: BoxShape.circle),
        child: const Icon(Icons.mark_email_read_outlined, color: AppColors.success, size: 32)),
      const SizedBox(height: 20),
      const Text('Check your email', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
      const SizedBox(height: 8),
      const Text('Reset instructions have been sent to your email address.',
        textAlign: TextAlign.center, style: TextStyle(fontSize: 14, color: AppColors.textSecondary)),
      const SizedBox(height: 24),
      SizedBox(
        width: double.infinity, height: 48,
        child: ElevatedButton(
          onPressed: () => context.go('/login'),
          child: const Text('Back to Login', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
        ),
      ),
    ],
  );
}
