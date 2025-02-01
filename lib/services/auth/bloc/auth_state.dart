import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/services/auth/auth_user.dart';

@immutable
abstract class AuthState {
  final bool isLoading;
  final String? LoadingText;
  const AuthState({
    required this.isLoading,
    this.LoadingText = 'Please wait a moment',
  });
}

class AuthStateUninitialized extends AuthState {
  const AuthStateUninitialized({required bool isLoading})
      : super(isLoading: isLoading);
}

class AuthStateLoggedIn extends AuthState {
  final AuthUser user;

  AuthStateLoggedIn({
    required this.user,
    required bool isLoading,
  }) : super(isLoading: isLoading);
}

class AuthStateRegistering extends AuthState {
  final Exception? exception;
  AuthStateRegistering({
    required this.exception,
    required bool isLoading,
    required String loadingText,
  }) : super(isLoading: isLoading, LoadingText: loadingText);
}

class AuthStateNeedsVerification extends AuthState {
  const AuthStateNeedsVerification({required bool isLoading})
      : super(isLoading: isLoading);
}

class AuthStateLoggedOut extends AuthState with EquatableMixin {
  final Exception? exception;
  const AuthStateLoggedOut({
    required this.exception,
    required bool isLoading,
    required String? loadingText,
  }) : super(isLoading: isLoading, LoadingText: loadingText);

  @override
  List<Object?> get props => [exception, isLoading];
}

class AuthStateForgotPassword extends AuthState {
  final Exception? exception;
  final bool sent;

  AuthStateForgotPassword({
    required super.isLoading,
    required this.exception,
    required this.sent,
  });
}
