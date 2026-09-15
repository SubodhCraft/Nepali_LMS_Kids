import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nepali_kids_lms/features/splash/presentation/screens/splash_screen.dart';
import 'package:nepali_kids_lms/features/auth/presentation/screens/login_screen.dart';
import 'package:nepali_kids_lms/features/auth/presentation/screens/signup_screen.dart';
import 'package:nepali_kids_lms/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:nepali_kids_lms/features/learning_modules/presentation/screens/lessons_home_screen.dart';
import 'package:nepali_kids_lms/features/learning_modules/presentation/screens/alphabet_section_screen.dart';
import 'package:nepali_kids_lms/features/learning_modules/presentation/screens/letter_detail_screen.dart';
import 'package:nepali_kids_lms/features/learning_modules/data/nepali_alphabet_data.dart';

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
        builder: (context, state) => LoginScreen(
          successMessage: state.uri.queryParameters['message'],
        ),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: '/lessons',
        builder: (context, state) => const LessonsHomeScreen(),
      ),
      GoRoute(
        path: '/lessons/section/:sectionId',
        builder: (context, state) {
          final sectionId = state.pathParameters['sectionId']!;
          final section = NepaliAlphabetData.sections
              .firstWhere((s) => s.id == sectionId);
          return AlphabetSectionScreen(section: section);
        },
      ),
      GoRoute(
        path: '/lessons/letter/:letterId',
        builder: (context, state) {
          final letterId = state.pathParameters['letterId']!;
          // Find letter across all sections
          final allLetters = NepaliAlphabetData.sections
              .expand((s) => s.letters)
              .toList();
          final letter = allLetters.firstWhere((l) => l.id == letterId);
          // Get the full list for next/prev navigation
          final sectionId = state.uri.queryParameters['sectionId'] ?? '';
          final sectionLetters = NepaliAlphabetData.sections
              .firstWhere((s) => s.id == sectionId,
                  orElse: () => NepaliAlphabetData.sections.first)
              .letters;
          return LetterDetailScreen(
            letter: letter,
            sectionLetters: sectionLetters,
            sectionId: sectionId,
          );
        },
      ),
    ],
  );
});
