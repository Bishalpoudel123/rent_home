// Firebase Auth Service
// Setup: https://firebase.google.com → New Project → Add Flutter app
// Run: flutterfire configure

// firebase_auth र firebase_core pubspec.yaml मा थप्नुहोस्:
// firebase_core: ^2.24.0
// firebase_auth: ^4.15.0
// cloud_firestore: ^4.13.0

import 'package:flutter/foundation.dart';

// TODO: Firebase setup गरेपछि यो uncomment गर्नुहोस्:
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseAuthService {
  // TODO: Uncomment after Firebase setup
  // static final FirebaseAuth _auth = FirebaseAuth.instance;
  // static final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Phone number OTP login (Nepal को लागि best)
  static Future<Map<String, dynamic>> loginWithPhone(String phone) async {
    try {
      // TODO: Firebase phone auth
      // await _auth.verifyPhoneNumber(
      //   phoneNumber: '+977$phone',
      //   verificationCompleted: (PhoneAuthCredential credential) async {
      //     await _auth.signInWithCredential(credential);
      //   },
      //   verificationFailed: (FirebaseAuthException e) {
      //     throw e;
      //   },
      //   codeSent: (String verificationId, int? resendToken) {
      //     // OTP code send भयो
      //   },
      //   codeAutoRetrievalTimeout: (String verificationId) {},
      // );

      // Mock for now
      return {'success': true, 'message': 'OTP पठाइयो'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  /// Verify OTP
  static Future<Map<String, dynamic>> verifyOTP({
    required String verificationId,
    required String otp,
    required String role,
    required String name,
  }) async {
    try {
      // TODO: Firebase OTP verify
      // final credential = PhoneAuthProvider.credential(
      //   verificationId: verificationId,
      //   smsCode: otp,
      // );
      // final userCredential = await _auth.signInWithCredential(credential);
      // Save user to Firestore
      // await _db.collection('users').doc(userCredential.user!.uid).set({
      //   'name': name,
      //   'role': role,
      //   'phone': userCredential.user!.phoneNumber,
      //   'createdAt': FieldValue.serverTimestamp(),
      //   'isVerified': false,
      // });

      return {'success': true};
    } catch (e) {
      return {'success': false, 'message': 'गलत OTP'};
    }
  }

  /// Google Sign-In
  static Future<Map<String, dynamic>> loginWithGoogle() async {
    try {
      // TODO: google_sign_in package थप्नुहोस्
      // final GoogleSignIn googleSignIn = GoogleSignIn();
      // final GoogleSignInAccount? account = await googleSignIn.signIn();
      // final GoogleSignInAuthentication auth = await account!.authentication;
      // final credential = GoogleAuthProvider.credential(
      //   accessToken: auth.accessToken,
      //   idToken: auth.idToken,
      // );
      // await _auth.signInWithCredential(credential);

      return {'success': true};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  static Future<void> logout() async {
    // await _auth.signOut();
    debugPrint('Logged out');
  }
}