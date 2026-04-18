import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:thachinchord/service/auth_service.dart';

// Service ကို access လုပ်ရန် provider
final authServiceProvider = Provider((ref) => AuthService());

// User ရဲ့ login state ကို stream ကြည့်ရန် provider
final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(authServiceProvider).authStateChanges;
});
