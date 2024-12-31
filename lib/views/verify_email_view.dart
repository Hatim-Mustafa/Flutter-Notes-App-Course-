import 'package:flutter/material.dart';
import 'package:mynotes/constants/route.dart';
import 'package:mynotes/services/auth/auth_service.dart';

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
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          children: [
            const Text(
                'An email verification is sent, click the link to verify your email.'),
            const Text(
                'If you have not recieved a verification email, press the button below.'),
            TextButton(
                onPressed: () async {
                  await AuthService.firebase().sendEmailVerification();
                },
                style: TextButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white),
                child: const Text('Send Verification Email')),
            TextButton(
                onPressed: () async {
                  await AuthService.firebase().logOut();
                  if (context.mounted) {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      registerRoute,
                      (route) => false,
                    );
                  }
                },
                style: TextButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white),
                child: const Text('Restart'))
          ],
        ),
      ),
    );
  }
}
