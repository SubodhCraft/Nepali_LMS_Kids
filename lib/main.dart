import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:nepali_kids_lms/core/routing/app_router.dart';
import 'package:nepali_kids_lms/core/theme/app_theme.dart';

// TODO: Replace these with your actual Supabase project credentials
const String supabaseUrl = 'https://isodxbtswahowahieapn.supabase.co';
const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imlzb2R4YnRzd2Fob3dhaGllYXBuIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODgzNjQ0NjQsImV4cCI6MjEwMzk0MDQ2NH0.3F2GV9TDXr-2_sEmZVbAqUruiW8JS19iKgfd2QRBl3A';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Suppress noisy debug prints from EGL, InputConnection, etc.
  // Comment this out if you need to see full logs during debugging.
  debugPrint = (String? message, {int? wrapWidth}) {
    // Only show our own app logs (they start with a recognizable prefix)
    // Suppress Android system noise
    if (message != null &&
        !message.contains('EGL_emulation') &&
        !message.contains('RemoteInputConnection') &&
        !message.contains('InsetsController')) {
      // ignore: avoid_print
      print(message);
    }
  };

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

class NepaliKidsLmsApp extends ConsumerStatefulWidget {
  const NepaliKidsLmsApp({super.key});

  @override
  ConsumerState<NepaliKidsLmsApp> createState() => _NepaliKidsLmsAppState();
}

class _NepaliKidsLmsAppState extends ConsumerState<NepaliKidsLmsApp> {
  late final StreamSubscription _authSubscription;

  @override
  void initState() {
    super.initState();
    _authSubscription = Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      final event = data.event;
      if (event == AuthChangeEvent.passwordRecovery) {
        // Deep link triggered a password recovery event
        // We push to the update password screen
        ref.read(appRouterProvider).push('/update-password');
      }
    });
  }

  @override
  void dispose() {
    _authSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'Nepali Kids LMS',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: router,
    );
  }
}
