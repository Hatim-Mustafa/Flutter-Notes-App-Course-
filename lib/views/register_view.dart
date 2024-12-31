import 'package:flutter/material.dart';
import 'package:mynotes/constants/route.dart';
import 'package:mynotes/main.dart';
import 'package:mynotes/services/auth/auth_exception.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/utilities/error_dialog.dart';
import 'dart:developer' as devtools show log;

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  late final TextEditingController _cpassword;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    _cpassword = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _cpassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
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
            Container(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
              width: 300.0,
              child: TextField(
                controller: _cpassword,
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                decoration: const InputDecoration(
                  hintText: 'Re-Enter your password',
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
            TextButton(
              onPressed: () async {
                final email = _email.text;
                final password = _password.text;
                final cpassword = _cpassword.text;
                if (cpassword == password) {
                  try {
                    await AuthService.firebase().createUser(
                      email: email,
                      password: password,
                    );
                    await AuthService.firebase().sendEmailVerification();
                    if (context.mounted) {
                      Navigator.of(context).pushNamed(
                        verifyRoute,
                      );
                    }
                  } on WeakPasswordAuthException {
                    await errorDialog(
                      context,
                      'Weak Password',
                    );
                  } on EmailInUseAuthException {
                    await errorDialog(
                      context,
                      'Email Already in Use',
                    );
                  } on InvalidEmailAuthException {
                    await errorDialog(
                      context,
                      'Invalid Email',
                    );
                  } on ChannelErrorAuthException {
                    await errorDialog(
                      context,
                      'Please complete all the fields',
                    );
                  } on GenericAuthException {
                    await errorDialog(
                      context,
                      'Authentication Error',
                    );
                  }
                } else {
                  await errorDialog(context, 'Passwords do not match');
                }
              },
              style: TextButton.styleFrom(
                  backgroundColor: Colors.blue, foregroundColor: Colors.white),
              child: const Text('Register'),
            ),
            TextButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(loginRoute, (route) => false);
                },
                child: const Text('Already Registered? Login Here.'))
          ],
        ),
      ),
    );
  }
}
