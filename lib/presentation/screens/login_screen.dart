import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weeklymenu/presentation/view_models/auth_view_model.dart';
import 'package:weeklymenu/l10n/app_localizations.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(appLocalizations.loginButton)),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  key: const Key('email_input_field'),
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: appLocalizations.emailHint,
                    border: const OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return appLocalizations.emailHint;
                    }
                    if (!value.contains('@')) {
                      return appLocalizations.emailHint; // Using emailHint for invalid email
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  key: const Key('password_input_field'),
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: appLocalizations.passwordHint,
                    border: const OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return appLocalizations.passwordHint;
                    }
                    if (value.length < 6) {
                      return appLocalizations.passwordHint; // Using passwordHint for short password
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24.0),
                Consumer<AuthViewModel>(
                  builder: (context, authViewModel, child) {
                    if (authViewModel.errorMessage != null) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _showErrorSnackBar(authViewModel.errorMessage!);
                        authViewModel.clearErrorMessage();
                      });
                    }
                    return SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        key: const Key('login_button'),
                        onPressed: authViewModel.isLoading
                            ? null
                            : () async {
                                if (_formKey.currentState!.validate()) {
                                  await authViewModel.signIn(
                                    email: _emailController.text,
                                    password: _passwordController.text,
                                  );
                                }
                              },
                        child: authViewModel.isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text(appLocalizations.loginButton),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16.0),
                TextButton(
                  onPressed: () {
                    // This navigation will be handled by GoRouter redirect
                  },
                  child: Text('Don\'t have an account? ${appLocalizations.signupButton}'),
                ),
                TextButton(
                  onPressed: () {
                    // This navigation will be handled by GoRouter redirect
                  },
                  child: Text(appLocalizations.forgotPasswordButton),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
