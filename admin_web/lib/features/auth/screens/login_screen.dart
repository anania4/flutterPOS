import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController(text: 'admin@artisanbrew.com');
  final _passCtrl = TextEditingController(text: 'password');
  bool _obscure = true;
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    setState(() { _loading = true; _error = null; });
    final ok = await context.read<AuthProvider>().login(_emailCtrl.text, _passCtrl.text);
    if (!ok && mounted) {
      setState(() { _loading = false; _error = 'Invalid email or password.'; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Row(
        children: [
          // Left branding panel
          Expanded(
            flex: 5,
            child: Container(
              color: AppColors.primary,
              padding: const EdgeInsets.all(48),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.local_cafe_rounded, color: Colors.white, size: 24),
                      ),
                      const SizedBox(width: 12),
                      const Text('Artisan Brew',
                        style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700)),
                    ],
                  ),
                  const Spacer(),
                  const Text('Multi-Branch\nManagement Platform',
                    style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.w800, height: 1.2)),
                  const SizedBox(height: 16),
                  Text('Manage your café empire from a single dashboard.\nReal-time insights, POS, kitchen, and more.',
                    style: TextStyle(color: Colors.white.withOpacity(0.75), fontSize: 15, height: 1.6)),
                  const SizedBox(height: 48),
                  Row(
                    children: [
                      _Feature(icon: Icons.store_rounded, label: 'Multi-Branch'),
                      const SizedBox(width: 24),
                      _Feature(icon: Icons.point_of_sale_rounded, label: 'POS System'),
                      const SizedBox(width: 24),
                      _Feature(icon: Icons.kitchen_rounded, label: 'KDS'),
                    ],
                  ),
                  const SizedBox(height: 48),
                ],
              ),
            ),
          ),
          // Right login form
          Expanded(
            flex: 4,
            child: Center(
              child: Container(
                width: 400,
                padding: const EdgeInsets.all(40),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 24, offset: const Offset(0, 8))],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Welcome back', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                    const SizedBox(height: 6),
                    const Text('Sign in to your admin account', style: TextStyle(fontSize: 14, color: AppColors.textSecondary)),
                    const SizedBox(height: 32),
                    if (_error != null)
                      Container(
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: AppColors.errorSurface,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.error.withOpacity(0.3)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.error_outline, size: 16, color: AppColors.error),
                            const SizedBox(width: 8),
                            Text(_error!, style: const TextStyle(fontSize: 13, color: AppColors.error)),
                          ],
                        ),
                      ),
                    const Text('Email Address', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        hintText: 'admin@artisanbrew.com',
                        prefixIcon: Icon(Icons.email_outlined, size: 18, color: AppColors.textTertiary),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text('Password', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _passCtrl,
                      obscureText: _obscure,
                      decoration: InputDecoration(
                        hintText: '••••••••',
                        prefixIcon: const Icon(Icons.lock_outline, size: 18, color: AppColors.textTertiary),
                        suffixIcon: IconButton(
                          icon: Icon(_obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                            size: 18, color: AppColors.textTertiary),
                          onPressed: () => setState(() => _obscure = !_obscure),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => context.go('/forgot-password'),
                        child: const Text('Forgot password?', style: TextStyle(fontSize: 13, color: AppColors.primary)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _loading ? null : _login,
                        child: _loading
                            ? const SizedBox(width: 20, height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                            : const Text('Sign In', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Feature extends StatelessWidget {
  final IconData icon;
  final String label;
  const _Feature({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(6)),
          child: Icon(icon, color: Colors.white, size: 16),
        ),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500)),
      ],
    );
  }
}
