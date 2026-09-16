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
import 'package:nepali_kids_lms/features/games/presentation/games_hub_screen.dart';
import 'package:nepali_kids_lms/features/games/memory_match/presentation/memory_match_screen.dart';
import 'package:nepali_kids_lms/features/games/matra_machine/presentation/matra_machine_screen.dart';
import 'package:nepali_kids_lms/features/stories/presentation/screens/stories_list_screen.dart';
import 'package:nepali_kids_lms/features/stories/presentation/screens/story_reader_screen.dart';
import 'package:nepali_kids_lms/features/rewards/presentation/screens/achievements_screen.dart';

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
          final allLetters = NepaliAlphabetData.sections
              .expand((s) => s.letters)
              .toList();
          final letter = allLetters.firstWhere((l) => l.id == letterId);
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
      // ── Games ──────────────────────────────────────────────────────
      GoRoute(
        path: '/games',
        builder: (context, state) => const GamesHubScreen(),
      ),
      GoRoute(
        path: '/games/memory-match',
        builder: (context, state) => const MemoryMatchScreen(),
      ),
      GoRoute(
        path: '/games/matra-machine',
        builder: (context, state) => const MatraMachineScreen(),
      ),
      // ── Stories ──────────────────────────────────────────────────
      GoRoute(
        path: '/stories',
        builder: (context, state) => const StoriesListScreen(),
      ),
      GoRoute(
        path: '/stories/:storyId',
        builder: (context, state) {
          final storyId = state.pathParameters['storyId']!;
          return StoryReaderScreen(storyId: storyId);
        },
      ),
      // ── Achievements ──────────────────────────────────────────────
      GoRoute(
        path: '/achievements',
        builder: (context, state) => const AchievementsScreen(),
      ),
    ],
  );
});
