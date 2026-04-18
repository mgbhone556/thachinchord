import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // လက်ရှိ user ရဲ့ အခြေအနေကို နားထောင်ရန်
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // အကောင့်သစ်ဖွင့်ရန် (Sign Up)
  Future<UserCredential?> signUp(String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      rethrow;
    }
  }

  // Login ဝင်ရန် (Sign In)
  Future<UserCredential?> signIn(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      rethrow;
    }
  }

  // Logout ထွက်ရန်
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
