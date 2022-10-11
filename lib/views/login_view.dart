import 'package:flutter/material.dart';
import 'package:flutter_course_for_beginners/constants/routes.dart';
import 'package:flutter_course_for_beginners/services/auth/auth_exceptions.dart';
import 'package:flutter_course_for_beginners/services/auth/auth_service.dart';
import 'package:flutter_course_for_beginners/utilities/show_error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

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
        title: const Text('Login'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _email,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration:
                const InputDecoration(hintText: 'Enter your email here'),
          ),
          TextField(
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.visiblePassword,
            decoration:
                const InputDecoration(hintText: 'Enter you password here'),
          ),
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;

              try {
                await AuthService.firebase().logIn(
                  email: email,
                  password: password,
                );
                final user = AuthService.firebase().currentUser;
                if (user != null) {
                  if (user.isEmailVerified) {
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil(notesRoute, (_) => false);
                  } else {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        verifyEmailRoute, (_) => false);
                  }
                }
              } on UserNotFoundAuthException {
                showErrorDialog(context, 'No user found for that email.');
              } on WrongPasswordAuthException {
                showErrorDialog(
                    context, 'Wrong password provided for that user.');
              } on GenericAuthException {
                showErrorDialog(context, 'An error occurred.');
              } catch (e) {
                showErrorDialog(context, 'Error : $e');
              }
            },
            child: const Text('Login '),
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(registerRoute, (route) => false);
              },
              child: const Text('not registered yet? register here')),
        ],
      ),
    );
  }
}
