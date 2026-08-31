import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _obscurePassword = true;

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
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _onLogin() async {
    if (!_formKey.currentState!.validate()) return;
    final success = await ref.read(authProvider.notifier).login(
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
                    const SizedBox(height: 20),
                    // ── Top illustration ─────────────────────────
                    Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.primary, Color(0xFF2E86C1)],
                        ),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.35),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text('📚', style: TextStyle(fontSize: 54)),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'स्वागत छ! 👋',
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: AppColors.textDark,
                                fontSize: 30,
                              ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'आफ्नो खाताबाट लग इन गर्नुहोस्',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: const Color(0xFF6B8FAE),
                          ),
                    ),
                    const SizedBox(height: 36),
                    // ── Form ─────────────────────────────────────
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
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
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          // Password
                          TextFormField(
                            controller: _passwordCtrl,
                            obscureText: _obscurePassword,
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_) => _onLogin(),
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
                              return null;
                            },
                          ),
                          const SizedBox(height: 8),
                          // Error message
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
                          // Login button
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: isLoading ? null : _onLogin,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                disabledBackgroundColor:
                                    AppColors.primary.withOpacity(0.6),
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
                                  : const Text('लग इन'),
                            ),
                          ),
                          const SizedBox(height: 24),
                          // Divider
                          Row(
                            children: [
                              const Expanded(
                                  child: Divider(color: Color(0xFFD0E8F8))),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                child: Text(
                                  'अथवा',
                                  style: TextStyle(
                                    color: Colors.grey.shade400,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const Expanded(
                                  child: Divider(color: Color(0xFFD0E8F8))),
                            ],
                          ),
                          const SizedBox(height: 20),
                          // Sign up navigation
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'खाता छैन? ',
                                style: TextStyle(
                                  color: Color(0xFF6B8FAE),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  ref.read(authProvider.notifier).clearError();
                                  context.go('/signup');
                                },
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: Size.zero,
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: const Text(
                                  'साइन अप गर्नुहोस्',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.accent,
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
