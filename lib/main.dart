import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:nepali_kids_lms/core/routing/app_router.dart';
import 'package:nepali_kids_lms/core/theme/app_theme.dart';

// TODO: Replace these with your actual Supabase project credentials
const String supabaseUrl = 'https://isodxbtswahowahieapn.supabase.co';
const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imlzb2R4YnRzd2Fob3dhaGllYXBuIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODgzNjQ0NjQsImV4cCI6MjEwMzk0MDQ2NH0.3F2GV9TDXr-2_sEmZVbAqUruiW8JS19iKgfd2QRBl3A';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
  );

  runApp(
    const ProviderScope(
      child: NepaliKidsLmsApp(),
    ),
  );
}

class NepaliKidsLmsApp extends ConsumerWidget {
  const NepaliKidsLmsApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'Nepali Kids LMS',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: router,
    );
  }
}
