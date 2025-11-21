import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart'; // Add this import
import 'package:weeklymenu/presentation/view_models/auth_view_model.dart';
import 'package:weeklymenu/l10n/app_localizations.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
      appBar: AppBar(title: Text(appLocalizations.signupButton)),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: appLocalizations.emailHint,
                    border: const OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return appLocalizations
                          .emailHint; // Using emailHint for empty email
                    }
                    if (!value.contains('@')) {
                      return appLocalizations
                          .emailHint; // Using emailHint for invalid email
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: appLocalizations.passwordHint,
                    border: const OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return appLocalizations
                          .passwordHint; // Using passwordHint for empty password
                    }
                    if (value.length < 6) {
                      return appLocalizations
                          .passwordHint; // Using passwordHint for short password
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: appLocalizations
                        .confirmPasswordHint, // Using confirmPasswordHint
                    border: const OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return appLocalizations
                          .confirmPasswordHint; // Using confirmPasswordHint for empty confirm password
                    }
                    if (value != _passwordController.text) {
                      return appLocalizations
                          .confirmPasswordHint; // Using confirmPasswordHint for passwords mismatch
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
                    if (authViewModel.currentUser != null &&
                        !authViewModel.isLoading) {
                      // Successfully signed up, pop to login and then navigate to home
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        context.go('/login'); // Go back to login using GoRouter
                      });
                    }
                    return SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: authViewModel.isLoading
                            ? null
                            : () async {
                                if (_formKey.currentState!.validate()) {
                                  await authViewModel.signUp(
                                    email: _emailController.text,
                                    password: _passwordController.text,
                                  );
                                }
                              },
                        child: authViewModel.isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text(appLocalizations.signupButton),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
