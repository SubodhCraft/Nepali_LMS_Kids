import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

enum AuthStatus { unauthenticated, loading, authenticated, signupSuccess, error }


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
  final _supabase = Supabase.instance.client;

  @override
  AuthState build() {
    // Check if user is already logged in
    final session = _supabase.auth.currentSession;
    if (session != null) {
      return AuthState(
        status: AuthStatus.authenticated,
        userEmail: session.user.email,
        userName: session.user.userMetadata?['name'] ?? session.user.email?.split('@').first,
      );
    }
    return const AuthState();
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(status: AuthStatus.loading);

    if (email.isEmpty || password.isEmpty) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: 'Email and Password cannot be empty',
      );
      return false;
    }

    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      
      if (response.user != null) {
        state = state.copyWith(
          status: AuthStatus.authenticated,
          userEmail: response.user!.email,
          userName: response.user!.userMetadata?['name'] ?? response.user!.email?.split('@').first,
        );
        return true;
      }
    } on AuthException catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.message,
      );
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: 'An unexpected error occurred.',
      );
    }
    return false;
  }

  Future<bool> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    state = state.copyWith(status: AuthStatus.loading);

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: 'Please fill all fields',
      );
      return false;
    }
    if (password.length < 6) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: 'Password must be at least 6 characters',
      );
      return false;
    }

    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {'name': name},
      );
      
      if (response.user != null) {
        // Sign out any auto-created session so user must log in manually
        await _supabase.auth.signOut();
        state = const AuthState(status: AuthStatus.signupSuccess);
        return true;
      }
    } on AuthException catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.message,
      );
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: 'An unexpected error occurred.',
      );
    }
    return false;
  }

  Future<void> logout() async {
    await _supabase.auth.signOut();
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
