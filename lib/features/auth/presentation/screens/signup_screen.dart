import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../providers/auth_provider.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  late AnimationController _animController;
  late Animation<Offset> _slideAnim;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _fadeAnim = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: _animController, curve: Curves.easeIn));
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _onSignup() async {
    if (!_formKey.currentState!.validate()) return;
    final success = await ref.read(authProvider.notifier).signup(
          name: _nameCtrl.text.trim(),
          email: _emailCtrl.text.trim(),
          password: _passwordCtrl.text,
        );
    if (success && mounted) {
      context.go('/dashboard');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final isLoading = authState.status == AuthStatus.loading;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.loginGradient),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
            child: FadeTransition(
              opacity: _fadeAnim,
              child: SlideTransition(
                position: _slideAnim,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 12),
                    // ── Back button ──────────────────────────────
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        onPressed: () {
                          ref.read(authProvider.notifier).clearError();
                          context.go('/login');
                        },
                        icon: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.arrow_back_ios_new_rounded,
                              color: AppColors.primary, size: 20),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // ── Header ───────────────────────────────────
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.accent, Color(0xFFFF5722)],
                        ),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.accent.withOpacity(0.35),
                            blurRadius: 18,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text('🎉', style: TextStyle(fontSize: 44)),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'नयाँ खाता बनाउनुस्!',
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontSize: 28,
                                color: AppColors.textDark,
                              ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'सिकाइको यात्रा सुरु गर्नुहोस् 🚀',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: const Color(0xFF6B8FAE),
                          ),
                    ),
                    const SizedBox(height: 30),
                    // ── Form ─────────────────────────────────────
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          // Full Name
                          TextFormField(
                            controller: _nameCtrl,
                            textInputAction: TextInputAction.next,
                            textCapitalization: TextCapitalization.words,
                            decoration: const InputDecoration(
                              labelText: 'पूरा नाम',
                              hintText: 'राम बहादुर',
                              prefixIcon: Icon(Icons.person_rounded),
                            ),
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) {
                                return 'कृपया आफ्नो नाम लेख्नुहोस्';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 14),
                          // Email
                          TextFormField(
                            controller: _emailCtrl,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                              labelText: 'इमेल',
                              hintText: 'email@example.com',
                              prefixIcon: Icon(Icons.email_rounded),
                            ),
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) {
                                return 'कृपया इमेल लेख्नुहोस्';
                              }
                              if (!v.contains('@')) {
                                return 'मान्य इमेल लेख्नुहोस्';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 14),
                          // Password
                          TextFormField(
                            controller: _passwordCtrl,
                            obscureText: _obscurePassword,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              labelText: 'पासवर्ड',
                              hintText: '••••••••',
                              prefixIcon: const Icon(Icons.lock_rounded),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_rounded
                                      : Icons.visibility_off_rounded,
                                  color: AppColors.primary,
                                ),
                                onPressed: () => setState(
                                    () => _obscurePassword = !_obscurePassword),
                              ),
                            ),
                            validator: (v) {
                              if (v == null || v.isEmpty) {
                                return 'कृपया पासवर्ड लेख्नुहोस्';
                              }
                              if (v.length < 6) {
                                return 'पासवर्ड कम्तिमा ६ अक्षरको हुनु पर्छ';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 14),
                          // Confirm Password
                          TextFormField(
                            controller: _confirmCtrl,
                            obscureText: _obscureConfirm,
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_) => _onSignup(),
                            decoration: InputDecoration(
                              labelText: 'पासवर्ड पुष्टि गर्नुहोस्',
                              hintText: '••••••••',
                              prefixIcon:
                                  const Icon(Icons.lock_outline_rounded),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureConfirm
                                      ? Icons.visibility_rounded
                                      : Icons.visibility_off_rounded,
                                  color: AppColors.primary,
                                ),
                                onPressed: () => setState(
                                    () => _obscureConfirm = !_obscureConfirm),
                              ),
                            ),
                            validator: (v) {
                              if (v == null || v.isEmpty) {
                                return 'पासवर्ड पुष्टि गर्नुहोस्';
                              }
                              if (v != _passwordCtrl.text) {
                                return 'पासवर्ड मेल खाएन';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          // Error
                          if (authState.status == AuthStatus.error)
                            Container(
                              margin: const EdgeInsets.only(top: 8),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.error.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.warning_amber_rounded,
                                      color: AppColors.error, size: 18),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      authState.errorMessage ?? 'त्रुटि भयो।',
                                      style: const TextStyle(
                                        color: AppColors.error,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          const SizedBox(height: 28),
                          // Signup button
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: isLoading ? null : _onSignup,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.accent,
                                disabledBackgroundColor:
                                    AppColors.accent.withOpacity(0.6),
                              ),
                              child: isLoading
                                  ? const SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        color: AppColors.white,
                                        strokeWidth: 2.5,
                                      ),
                                    )
                                  : const Text('साइन अप गर्नुहोस्'),
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Login navigation
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'पहिले नै खाता छ? ',
                                style: TextStyle(
                                  color: Color(0xFF6B8FAE),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  ref.read(authProvider.notifier).clearError();
                                  context.go('/login');
                                },
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: Size.zero,
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: const Text(
                                  'लग इन गर्नुहोस्',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
