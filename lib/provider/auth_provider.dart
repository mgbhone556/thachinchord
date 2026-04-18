import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:thachinchord/service/auth_service.dart';
import 'package:thachinchord/service/database_service.dart';

// Service ကို access လုပ်ရန် provider
final authServiceProvider = Provider((ref) => AuthService());

// User ရဲ့ login state ကို stream ကြည့်ရန် provider
final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(authServiceProvider).authStateChanges;
});

// Database Service Provider
final databaseServiceProvider = Provider((ref) => DatabaseService());

// သီချင်းစာရင်းကို အမြဲ Watch နေမည့် StreamProvider
final songsStreamProvider = StreamProvider<List<Map<String, dynamic>>>((ref) {
  return ref.watch(databaseServiceProvider).getSongs();
});

// Admin ဟုတ်မဟုတ် စစ်ဆေးမည့် FutureProvider
final isAdminProvider = FutureProvider<bool>((ref) async {
  final user = ref.watch(authStateProvider).value;
  if (user == null) return false;

  final doc = await FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .get();
  return doc.data()?['role'] == 'admin';
});
