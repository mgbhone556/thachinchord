import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:thachinchord/auth/login.dart';
import 'package:thachinchord/firebase_options.dart'; // ဤဖိုင်ရှိနေရပါမည်
import 'package:thachinchord/provider/auth_provider.dart';
import 'package:thachinchord/ui/admin.dart';
import 'package:thachinchord/ui/user.dart'; // HomeScreen ရှိရာ လမ်းကြောင်း

void main() async {
  // Flutter binding ကို အရင်လုပ်ပါ
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase ကို Initialize လုပ်ပါ
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    // Riverpod အတွက် ProviderScope မဖြစ်မနေလိုအပ်ပါသည်
    const ProviderScope(child: ThaChinChordApp()),
  );
}

class ThaChinChordApp extends ConsumerWidget {
  const ThaChinChordApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Auth State ကို Watch လုပ်ပြီး User Login ရှိ/မရှိ စစ်ဆေးပါသည်
    final authState = ref.watch(authStateProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ThachinChord',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      // authState ရဲ့ အခြေအနေပေါ်မူတည်ပြီး Screen ပြောင်းပေးပါသည်
      // main.dart ရဲ့ ThaChinChordApp build ထဲမှာ ပြင်ရန်
      home: authState.when(
        data: (user) {
          if (user != null) {
            // User ရှိရင် Role ကို ထပ်စစ်မယ်
            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.uid)
                  .get(),
              builder: (context, roleSnapshot) {
                if (roleSnapshot.connectionState == ConnectionState.waiting) {
                  return const Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  );
                }

                final userData =
                    roleSnapshot.data?.data() as Map<String, dynamic>?;
                final role = userData?['role'] ?? 'user';

                if (role == 'admin') {
                  return const AdminDashboard();
                } else {
                  return const UserApp();
                }
              },
            );
          }
          return const LoginScreen();
        },
        loading: () =>
            const Scaffold(body: Center(child: CircularProgressIndicator())),
        error: (e, trace) => Scaffold(body: Center(child: Text("Error: $e"))),
      ),
    );
  }
}
