// logout.dart ထဲတွင် ပြင်ရန်
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thachinchord/provider/auth_provider.dart';

class LogoutService {
  static Future<void> logout(BuildContext context, WidgetRef ref) async {
    // 1. အတည်ပြုချက်မေးမယ် (Optional ဒါပေမဲ့ ပိုကောင်းပါတယ်)
    bool confirm =
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Logout"),
            content: const Text("အကောင့်ထဲမှ ထွက်ရန် သေချာပါသလား?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text("မထွက်ပါ"),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text("ထွက်မည်"),
              ),
            ],
          ),
        ) ??
        false;

    if (!confirm) return;

    try {
      // 2. Auth State ကို Clear လုပ်ရန် (Firebase ကနေ Sign Out လုပ်ခြင်း)
      await ref.read(authServiceProvider).signOut();

      // 3. Navigator ကို သုံးပြီး အရင် Screen အဟောင်းတွေ အကုန်ဖြတ်ထုတ်မယ်
      // အကယ်၍ main.dart က authState ကို watch နေရင် ဒီ step က option ဖြစ်ပေမယ့်
      // Memory ထဲမှာ ကျန်မနေအောင် လုပ်ပေးတာ ပိုကောင်းပါတယ်
      if (context.mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Logout မအောင်မြင်ပါ: $e')));
      }
    }
  }
}
