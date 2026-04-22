import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thachinchord/auth/login.dart';
import '../provider/auth_provider.dart';

class LogoutService {
  static Future<void> logout(BuildContext context, WidgetRef ref) async {
    // Loading ပြသမယ်
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      await ref.read(authServiceProvider).signOut();

      if (context.mounted) {
        // Login Screen ကို သွားပြီး အရင် screen အကုန်ဖျက်မယ်
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context); // loading dialog ပိတ်မယ်
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Logout မအောင်မြင်ပါ။ ${e.toString()}'),
            backgroundColor: Colors.red.shade700,
          ),
        );
      }
    }
  }
}
