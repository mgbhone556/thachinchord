import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  // လက်ရှိ user ရဲ့ အခြေအနေကို နားထောင်ရန်
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // အကောင့်သစ်ဖွင့်ရန် (Sign Up)
  Future<UserCredential?> signUp(String email, String password) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (credential.user != null) {
        await _updateUserData(credential.user!);
      }
      return credential;
    } catch (e) {
      rethrow;
    }
  }

  // Email/Password ဖြင့် Login ဝင်ရန်
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

  // Google Sign In Logic (Fixed)
  Future<UserCredential?> signInWithGoogle() async {
    try {
      await _googleSignIn.initialize();
      final GoogleSignInAccount? googleUser = await _googleSignIn
          .authenticate();
      if (googleUser == null) return null;
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final List<String> scopes = <String>['email', 'profile'];
      final authorization = await googleUser.authorizationClient
          .authorizationForScopes(scopes);
      final OAuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: authorization?.accessToken,
      );
      UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );
      if (userCredential.user != null) {
        await _updateUserData(userCredential.user!);
      }
      return userCredential;
    } catch (e) {
      debugPrint("Google Sign-In Error: $e");
      return null;
    }
  }

  // Facebook Sign In Logic
  Future<UserCredential?> signInWithFacebook() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();

      if (result.status == LoginStatus.success) {
        final OAuthCredential credential = FacebookAuthProvider.credential(
          result.accessToken!.tokenString,
        );

        UserCredential userCredential = await _auth.signInWithCredential(
          credential,
        );

        if (userCredential.user != null) {
          await _updateUserData(userCredential.user!);
        }

        return userCredential;
      }
      return null;
    } catch (e) {
      print("Facebook Sign-In Error: $e");
      rethrow;
    }
  }

  // Firestore ထဲတွင် User Role သတ်မှတ်ခြင်း (New)
  Future<void> _updateUserData(User user) async {
    final userRef = _db.collection('users').doc(user.uid);
    final doc = await userRef.get();

    if (!doc.exists) {
      await userRef.set({
        'uid': user.uid,
        'email': user.email,
        'role': 'user', // Default က ရိုးရိုး user ဖြစ်သည်
        'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    }
  }

  // Logout ထွက်ရန်
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await FacebookAuth.instance.logOut();
      await _auth.signOut();
    } catch (e) {
      print("Logout Error: $e");
    }
  }
}
