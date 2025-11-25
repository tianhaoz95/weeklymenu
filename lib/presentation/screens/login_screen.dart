import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:weeklymenu/presentation/view_models/auth_view_model.dart';
import 'package:weeklymenu/l10n/app_localizations.dart';
import 'package:weeklymenu/presentation/theme/app_theme.dart'; // Import app_theme

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
    final appColors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: appColors.backgroundLight, // Set background from theme
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // App Logo
                Container(
                  margin: const EdgeInsets.only(bottom: 24.0),
                  height: 64,
                  width: 64,
                  decoration: BoxDecoration(
                    color: appColors.primary!.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.menu_book,
                    color: appColors.primary,
                    size: 40,
                  ),
                ),
                // HeadlineText
                Text(
                  appLocalizations.welcomeBack, // Use localized string
                  style: textTheme.headlineSmall?.copyWith(
                    color: appColors.textLight,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                // Subheadline
                Padding(
                  padding: const EdgeInsets.only(bottom: 32.0),
                  child: Text(
                    appLocalizations
                        .loginToYourCookbook, // Use localized string
                    style: textTheme.bodySmall?.copyWith(
                      color: appColors.subtleLight,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                // Email TextField
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        appLocalizations.emailAddress, // Use localized string
                        style: textTheme.labelMedium?.copyWith(
                          color: appColors.textLight,
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: appColors.backgroundLight,
                        borderRadius: BorderRadius.circular(12.0),
                        border: Border.all(color: appColors.borderLight!),
                      ),
                      child: TextFormField(
                        key: const Key('email_input_field'),
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.mail,
                            color: appColors.subtleLight,
                          ),
                          hintText: appLocalizations
                              .emailHint, // Use localized string
                          hintStyle: textTheme.bodyMedium?.copyWith(
                            color: appColors.subtleLight,
                          ),
                          border: InputBorder.none, // Remove default border
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 16.0,
                            horizontal: 12.0,
                          ),
                          isDense: true,
                        ),
                        style: textTheme.bodyMedium?.copyWith(
                          color: appColors.textLight,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return appLocalizations
                                .emailRequired; // New localized string
                          }
                          if (!value.contains('@')) {
                            return appLocalizations
                                .invalidEmail; // New localized string
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                // Password TextField
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        appLocalizations.password, // Use localized string
                        style: textTheme.labelMedium?.copyWith(
                          color: appColors.textLight,
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: appColors.backgroundLight,
                        borderRadius: BorderRadius.circular(12.0),
                        border: Border.all(color: appColors.borderLight!),
                      ),
                      child: TextFormField(
                        key: const Key('password_input_field'),
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.lock,
                            color: appColors.subtleLight,
                          ),
                          hintText: appLocalizations
                              .passwordHint, // Use localized string
                          hintStyle: textTheme.bodyMedium?.copyWith(
                            color: appColors.subtleLight,
                          ),
                          border: InputBorder.none, // Remove default border
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 16.0,
                            horizontal: 12.0,
                          ),
                          isDense: true,
                        ),
                        style: textTheme.bodyMedium?.copyWith(
                          color: appColors.textLight,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return appLocalizations
                                .passwordRequired; // New localized string
                          }
                          if (value.length < 6) {
                            return appLocalizations
                                .passwordTooShort; // New localized string
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12.0), // Spacing for Forgot Password
                // Forgot Password
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      context.go('/forgot-password');
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(50, 30),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      alignment: Alignment.centerRight,
                    ),
                    child: Text(
                      appLocalizations.forgotPasswordButton,
                      style: textTheme.labelSmall?.copyWith(
                        color: appColors.primary,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24.0), // Spacing for Login Button
                // Login Button
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
                        style: ElevatedButton.styleFrom(
                          backgroundColor: appColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                        ),
                        child: authViewModel.isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text(
                                appLocalizations.loginButton,
                                style: textTheme.labelLarge?.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 32.0), // Spacing for Sign Up
                // Sign Up Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      appLocalizations.noAccountYet,
                      style: textTheme.bodySmall?.copyWith(
                        color: appColors.subtleLight,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        context.go('/signup');
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(50, 30),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        alignment: Alignment.centerLeft,
                      ),
                      child: Text(
                        appLocalizations.signupButton,
                        style: textTheme.bodySmall?.copyWith(
                          color: appColors.primary,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
