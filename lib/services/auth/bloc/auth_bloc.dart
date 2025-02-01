import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/services/auth/auth_provider.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';
import 'package:mynotes/services/auth/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider provider)
      : super(const AuthStateUninitialized(isLoading: true)) {
    on<AuthEventInitialize>((event, emit) async {
      await provider.initialize();
      final user = provider.currentUser;
      if (user == null) {
        emit(
          AuthStateLoggedOut(
            exception: null,
            isLoading: false,
            loadingText: "",
          ),
        );
      } else if (!user.isEmailVerified) {
        emit(AuthStateNeedsVerification(isLoading: false));
      } else {
        emit(AuthStateLoggedIn(
          user: user,
          isLoading: false,
        ));
      }
    });

    on<AuthEventLoggingIn>((event, emit) async {
      emit(
        AuthStateLoggedOut(
          exception: null,
          isLoading: true,
          loadingText: "Logging In",
        ),
      );
      final email = event.email;
      final password = event.password;
      try {
        final user = await provider.logIn(
          email: email,
          password: password,
        );
        if (!user.isEmailVerified) {
          emit(AuthStateNeedsVerification(isLoading: false));
        } else {
          emit(AuthStateLoggedIn(
            user: user,
            isLoading: false,
          ));
        }
      } on Exception catch (e) {
        emit(
          AuthStateLoggedOut(
            exception: e,
            isLoading: false,
            loadingText: '',
          ),
        );
      }
    });

    on<AuthEventLoggingOut>((event, emit) async {
      emit(AuthStateLoggedOut(
        exception: null,
        isLoading: true,
        loadingText: "Logging Out",
      )); // added by myself
      try {
        await provider.logOut();
        emit(
          AuthStateLoggedOut(
            exception: null,
            isLoading: false,
            loadingText: '',
          ),
        );
      } on Exception catch (e) {
        emit(
          AuthStateLoggedOut(
            exception: e,
            isLoading: false,
            loadingText: '',
          ),
        );
      }
    });

    on<AuthEventSendVerification>(
      (event, emit) async {
        await provider.sendEmailVerification();
        emit(state);
      },
    );

    on<AuthEventRegisterUser>(
      (event, emit) async {
        try {
          emit(AuthStateRegistering(
            exception: null,
            isLoading: true,
            loadingText: 'Registering',
          ));
          await provider.createUser(
            email: event.email,
            password: event.password,
          );
          await provider.sendEmailVerification();
          emit(AuthStateNeedsVerification(isLoading: false));
        } on Exception catch (e) {
          emit(AuthStateRegistering(
            exception: e,
            isLoading: false,
            loadingText: '',
          ));
        }
      },
    );

    on<AuthEventShouldRegister>(
      (event, emit) {
        emit(
          AuthStateRegistering(
            exception: null,
            isLoading: false,
            loadingText: '',
          ),
        );
      },
    );

    on<AuthEventForgotPassword>(
      (event, emit) async {
        emit(
          AuthStateForgotPassword(
            isLoading: false,
            exception: null,
            sent: false,
          ),
        );

        final email = event.email;
        if (email == null) {
          return;
        }

        emit(
          AuthStateForgotPassword(
            isLoading: true,
            exception: null,
            sent: false,
          ),
        );

        try {
          await provider.resetPassword(toEmail: email);
          emit(
            AuthStateForgotPassword(
              isLoading: false,
              exception: null,
              sent: true,
            ),
          );
        } on Exception catch (e) {
          emit(
            AuthStateForgotPassword(
              isLoading: false,
              exception: e,
              sent: false,
            ),
          );
        }
      },
    );
  }
}
