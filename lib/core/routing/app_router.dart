import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nepali_kids_lms/features/splash/presentation/screens/splash_screen.dart';
import 'package:nepali_kids_lms/features/auth/presentation/screens/login_screen.dart';
import 'package:nepali_kids_lms/features/auth/presentation/screens/signup_screen.dart';
import 'package:nepali_kids_lms/features/dashboard/presentation/screens/dashboard_screen.dart';

// Provides the GoRouter instance
final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const DashboardScreen(),
      ),
    ],
  );
});
