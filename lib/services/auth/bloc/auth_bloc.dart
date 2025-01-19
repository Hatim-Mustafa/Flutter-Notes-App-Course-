import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/services/auth/auth_provider.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';
import 'package:mynotes/services/auth/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider provider) : super(const AuthStateLoading()) {
    on<AuthEventInitialize>((event, emit) async {
      await provider.initialize();
      final user = provider.currentUser;
      if (user == null) {
        emit(AuthStateLoggedOut(null));
      } else if (!user.isEmailVerified) {
        emit(AuthStateNeedsVerification());
      } else {
        emit(AuthStateLoggedIn(user: user));
      }
    });

    on<AuthEventLoggingIn>((event, emit) async {
      final email = event.email;
      final password = event.password;
      try {
        final user = await provider.logIn(
          email: email,
          password: password,
        );
        emit(AuthStateLoggedIn(user: user));
      } on Exception catch (e) {
        emit(AuthStateLoggedOut(e));
      }
    });

    on<AuthEventLoggingOut>((event, emit) async {
      emit(AuthStateLoading());
      try {
        await provider.logOut(); 
        emit(AuthStateLoggedOut(null));
      } on Exception catch (e) {
        emit(AuthStateLogOutFailure(exception: e));
      }
    });
  }
}
