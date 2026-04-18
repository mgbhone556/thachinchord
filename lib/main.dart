import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:thachinchord/auth/login.dart';
import 'package:thachinchord/firebase_options.dart';
import 'package:thachinchord/provider/auth_provider.dart';
import 'package:thachinchord/ui/user.dart';

void main() async {
  // Flutter Widgets တွေကို အရင် bind လုပ်ရပါမယ်
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase ကို စတင်နှိုးဆော်ခြင်း
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    // Riverpod သုံးရင် ProviderScope နဲ့ အုပ်ပေးဖို့ လိုအပ်ပါတယ်
    const ProviderScope(child: ThaChinChordApp()),
  );
}

class ThaChinChordApp extends ConsumerWidget {
  const ThaChinChordApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Auth State ကို စောင့်ကြည့်နေပါမယ်
    final authState = ref.watch(authStateProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ThachinChord',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: authState.when(
        data: (user) {
          if (user != null) {
            return const HomeScreen(); // Login ဝင်ထားရင် Home (App/Web)
          }
          return LoginScreen(); // Login မဝင်ရသေးရင် LoginScreen
        },
        loading: () =>
            const Scaffold(body: Center(child: CircularProgressIndicator())),
        error: (e, trace) =>
            Scaffold(body: Center(child: Text("Error occurred: $e"))),
      ),
    );
  }
}
