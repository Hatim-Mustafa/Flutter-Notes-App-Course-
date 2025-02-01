import 'package:flutter/material.dart';

@immutable
abstract class AuthEvent {
  const AuthEvent();
}

class AuthEventInitialize extends AuthEvent {
  const AuthEventInitialize();
}

class AuthEventLoggingIn extends AuthEvent {
  final String email;
  final String password;

  AuthEventLoggingIn({required this.email, required this.password});
}

class AuthEventLoggingOut extends AuthEvent {
  const AuthEventLoggingOut();
}

class AuthEventRegisterUser extends AuthEvent {
  final String email;
  final String password;

  AuthEventRegisterUser({required this.email, required this.password});
}

class AuthEventSendVerification extends AuthEvent {
  const AuthEventSendVerification();
}

class AuthEventShouldRegister extends AuthEvent {
  const AuthEventShouldRegister();
}

class AuthEventForgotPassword extends AuthEvent {
  final String? email;
  AuthEventForgotPassword({required this.email});
}
