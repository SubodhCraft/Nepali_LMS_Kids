import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nepali_kids_lms/core/routing/app_router.dart';

void main() {
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
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: true,
      ),
      routerConfig: router,
    );
  }
}
