import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/constants/route.dart';
import 'package:mynotes/services/auth/auth_exception.dart';
import 'package:mynotes/services/auth/bloc/auth_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';
import 'package:mynotes/services/auth/bloc/auth_state.dart';
import 'package:mynotes/utilities/dialogs/error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log In'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
              width: 300.0,
              child: TextField(
                controller: _email,
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: 'Enter your email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    borderSide: BorderSide(
                      color: Colors.blue, // Border color
                      width: 2.0, // Border width
                    ),
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
              width: 300.0,
              child: TextField(
                controller: _password,
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                decoration: const InputDecoration(
                  hintText: 'Enter your password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    borderSide: BorderSide(
                      color: Colors.blue, // Border color
                      width: 2.0, // Border width
                    ),
                  ),
                ),
              ),
            ),
            BlocListener<AuthBloc, AuthState>(
              listener: (context, state) async {
                if (state is AuthStateLoggedOut) {
                  if (state.exception == UserNotLoggedInAuthException) {
                    await errorDialog(
                      context,
                      'User not found',
                    );
                  } else if (state.exception ==
                      InvalidCredentialsAuthException) {
                    await errorDialog(
                      context,
                      'Invalid username or password',
                    );
                  } else if (state.exception == InvalidEmailAuthException) {
                    await errorDialog(
                      context,
                      'Invalid email',
                    );
                  } else if (state.exception == ChannelErrorAuthException) {
                    await errorDialog(
                      context,
                      'Please complete all the fields',
                    );
                  } else if (state.exception == GenericAuthException) {
                    await errorDialog(
                      context,
                      'Authentication Error',
                    );
                  }
                }
              },
              child: TextButton(
                onPressed: () async {
                  final email = _email.text;
                  final password = _password.text;
                  context.read<AuthBloc>().add(
                        AuthEventLoggingIn(
                          email: email,
                          password: password,
                        ),
                      );
                },
                style: TextButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white),
                child: const Text('Log In'),
              ),
            ),
            TextButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(registerRoute, (route) => false);
                },
                child: const Text('Not registered yet? Register Here.'))
          ],
        ),
      ),
    );
  }
}
