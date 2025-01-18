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


