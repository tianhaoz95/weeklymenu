import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weeklymenu/presentation/view_models/auth_view_model.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Settings Content (Placeholder)'),
            const SizedBox(height: 20),
            Consumer<AuthViewModel>(
              builder: (context, authViewModel, child) {
                return ElevatedButton(
                  onPressed: authViewModel.isLoading
                      ? null
                      : () async {
                          await authViewModel.signOut();
                        },
                  child: authViewModel.isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Sign Out'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
