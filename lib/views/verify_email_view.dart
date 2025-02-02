import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Email'),
        backgroundColor: Color(0xFF425865),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            children: [
              const Text(
                  'An email verification is sent, click the link to verify your email.'),
              const Text(
                  'If you have not recieved a verification email, press the button below.'),
              TextButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(AuthEventSendVerification());
                  },
                  style: TextButton.styleFrom(
                      backgroundColor: Color(0xFF425865),
                      foregroundColor: Colors.white),
                  child: const Text('Send Verification Email')),
              TextButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(AuthEventLoggingOut());
                  },
                  style: TextButton.styleFrom(
                      backgroundColor: Color(0xFF425865),
                      foregroundColor: Colors.white),
                  child: const Text('Restart'))
            ],
          ),
        ),
      ),
    );
  }
}
