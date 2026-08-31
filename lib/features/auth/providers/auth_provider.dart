import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Dummy auth state — replaces real DB auth later.
enum AuthStatus { unauthenticated, loading, authenticated, error }

class AuthState {
  final AuthStatus status;
  final String? errorMessage;
  final String? userEmail;
  final String? userName;

  const AuthState({
    this.status = AuthStatus.unauthenticated,
    this.errorMessage,
    this.userEmail,
    this.userName,
  });

  AuthState copyWith({
    AuthStatus? status,
    String? errorMessage,
    String? userEmail,
    String? userName,
  }) {
    return AuthState(
      status: status ?? this.status,
      errorMessage: errorMessage,
      userEmail: userEmail ?? this.userEmail,
      userName: userName ?? this.userName,
    );
  }
}

class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() => const AuthState();

  /// Dummy login — always succeeds after a fake 1.5s network delay.
  /// Replace the body of this method with real DB auth later.
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(status: AuthStatus.loading);
    await Future.delayed(const Duration(milliseconds: 1500));

    // ── DUMMY VALIDATION ──────────────────────────────────────────
    if (email.isEmpty || password.isEmpty) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: 'Email र Password भर्नु होस्।',
      );
      return false;
    }
    // TODO: Replace with real DB authentication
    state = state.copyWith(
      status: AuthStatus.authenticated,
      userEmail: email,
      userName: email.split('@').first,
    );
    return true;
  }

  /// Dummy signup — always succeeds after a fake 1.5s network delay.
  /// Replace the body of this method with real DB auth later.
  Future<bool> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    state = state.copyWith(status: AuthStatus.loading);
    await Future.delayed(const Duration(milliseconds: 1500));

    // ── DUMMY VALIDATION ──────────────────────────────────────────
    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: 'सबै फिल्ड भर्नु होस्।',
      );
      return false;
    }
    if (password.length < 6) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: 'Password कम्तिमा ६ अक्षरको हुनु पर्छ।',
      );
      return false;
    }
    // TODO: Replace with real DB registration
    state = state.copyWith(
      status: AuthStatus.authenticated,
      userEmail: email,
      userName: name,
    );
    return true;
  }

  void logout() {
    state = const AuthState(status: AuthStatus.unauthenticated);
  }

  void clearError() {
    if (state.status == AuthStatus.error) {
      state = state.copyWith(status: AuthStatus.unauthenticated);
    }
  }
}

final authProvider =
    NotifierProvider<AuthNotifier, AuthState>(() => AuthNotifier());
