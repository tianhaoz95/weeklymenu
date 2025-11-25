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
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void dispose() {
    _nameController.dispose();
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
    final TextTheme textTheme = Theme.of(context).textTheme;

    // Locally defined colors for this screen
    const Color primaryColor = Color(0xFFE2725B);
    const Color backgroundColor = Color(0xFFFCF9F4);
    const Color textColor = Color(0xFF333333);
    const Color fieldColor = Color(0xFFFFFFFF);
    const Color borderColor = Color(0xFFd1ccc5);
    const Color placeholderColor = Color(0xFF888888);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Branding Section (CulinaryHub logo and text)
                Padding(
                  padding: const EdgeInsets.only(top: 24.0, bottom: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.menu_book, size: 36, color: primaryColor),
                      const SizedBox(width: 8),
                      Text(
                        'CulinaryHub',
                        style: textTheme.titleLarge?.copyWith(
                          color: textColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                // Title Section
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 16.0,
                  ),
                  child: Text(
                    'Create Your Culinary Hub',
                    textAlign: TextAlign.center,
                    style: textTheme.headlineSmall?.copyWith(color: textColor),
                  ),
                ),
                // Remaining form fields will go here
                // Username field
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextFormField(
                    controller: _nameController,
                    keyboardType: TextInputType.text,
                    style: textTheme.bodyMedium?.copyWith(color: textColor),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: fieldColor,
                      hintText: 'e.g., Jamie Oliver',
                      hintStyle: textTheme.bodyMedium?.copyWith(
                        color: placeholderColor,
                      ),
                      prefixIcon: Icon(Icons.person, color: placeholderColor),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: const BorderSide(color: borderColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: const BorderSide(color: borderColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: const BorderSide(
                          color: primaryColor,
                          width: 2.0,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 16.0,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return appLocalizations.nameHint;
                      }
                      return null;
                    },
                  ),
                ),

                // Email field
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: textTheme.bodyMedium?.copyWith(color: textColor),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: fieldColor,
                      hintText: 'you@email.com',
                      hintStyle: textTheme.bodyMedium?.copyWith(
                        color: placeholderColor,
                      ),
                      prefixIcon: Icon(Icons.mail, color: placeholderColor),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: const BorderSide(color: borderColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: const BorderSide(color: borderColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: const BorderSide(
                          color: primaryColor,
                          width: 2.0,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 16.0,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return appLocalizations.emailHint;
                      }
                      if (!value.contains('@')) {
                        return appLocalizations.emailHint;
                      }
                      return null;
                    },
                  ),
                ),
                // Password field
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextFormField(
                    controller: _passwordController,
                    obscureText: !_isPasswordVisible,
                    style: textTheme.bodyMedium?.copyWith(color: textColor),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: fieldColor,
                      hintText: 'Create a password',
                      hintStyle: textTheme.bodyMedium?.copyWith(
                        color: placeholderColor,
                      ),
                      prefixIcon: Icon(Icons.lock, color: placeholderColor),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: placeholderColor,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: const BorderSide(color: borderColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: const BorderSide(color: borderColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: const BorderSide(
                          color: primaryColor,
                          width: 2.0,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 16.0,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return appLocalizations.passwordHint;
                      }
                      if (value.length < 6) {
                        return appLocalizations.passwordHint;
                      }
                      return null;
                    },
                  ),
                ),
                // Confirm Password field
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: !_isConfirmPasswordVisible,
                    style: textTheme.bodyMedium?.copyWith(color: textColor),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: fieldColor,
                      hintText: 'Confirm password',
                      hintStyle: textTheme.bodyMedium?.copyWith(
                        color: placeholderColor,
                      ),
                      prefixIcon: Icon(Icons.lock, color: placeholderColor),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isConfirmPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: placeholderColor,
                        ),
                        onPressed: () {
                          setState(() {
                            _isConfirmPasswordVisible =
                                !_isConfirmPasswordVisible;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: const BorderSide(color: borderColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: const BorderSide(color: borderColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: const BorderSide(
                          color: primaryColor,
                          width: 2.0,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 16.0,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return appLocalizations.confirmPasswordHint;
                      }
                      if (value != _passwordController.text) {
                        return appLocalizations.confirmPasswordHint;
                      }
                      return null;
                    },
                  ),
                ),
                // Password strength indicator
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4.0,
                    vertical: 8.0,
                  ),
                  child: Row(
                    children: List.generate(
                      4,
                      (index) => Expanded(
                        child: Container(
                          height: 4.0,
                          margin: EdgeInsets.only(left: index == 0 ? 0 : 4.0),
                          decoration: BoxDecoration(
                            color: Colors.grey[300], // Placeholder color
                            borderRadius: BorderRadius.circular(2.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0), // Space between fields and button
                // Sign Up Button
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
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        context.go('/login');
                      });
                    }
                    return SizedBox(
                      width: double.infinity,
                      height: 56.0, // Corresponds to h-14 in tailwind
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          elevation: 4.0, // Shadow effect
                          shadowColor: primaryColor.withAlpha(
                            (255 * 0.4).round(),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          textStyle: textTheme.labelLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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
                            : Text(
                                appLocalizations.signupButton,
                                style: const TextStyle(color: Colors.white),
                              ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24.0), // Space after button
                // Already have an account? Log In
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      appLocalizations.alreadyHaveAccount,
                      style: textTheme.bodyMedium?.copyWith(color: textColor),
                    ),
                    TextButton(
                      onPressed: () {
                        context.go('/login');
                      },
                      child: Text(
                        appLocalizations.loginButton,
                        style: textTheme.bodyMedium?.copyWith(
                          color: primaryColor,
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
