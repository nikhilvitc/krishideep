import 'package:firebase_auth/firebase_auth.dart' as auth;
import '../models/user.dart';

class AuthService {
  final auth.FirebaseAuth _firebaseAuth = auth.FirebaseAuth.instance;

  // Get current user
  User? get currentUser {
    final firebaseUser = _firebaseAuth.currentUser;
    if (firebaseUser != null) {
      return User(
        uid: firebaseUser.uid,
        phoneNumber: firebaseUser.phoneNumber ?? '',
        displayName: firebaseUser.displayName,
      );
    }
    return null;
  }

  // Stream of auth changes
  Stream<User?> get authStateChanges {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      if (firebaseUser != null) {
        return User(
          uid: firebaseUser.uid,
          phoneNumber: firebaseUser.phoneNumber ?? '',
          displayName: firebaseUser.displayName,
        );
      }
      return null;
    });
  }

  // Send OTP to phone number
  Future<void> sendOTP({
    required String phoneNumber,
    required Function(String) onCodeSent,
    required Function(String) onError,
    required Function(auth.PhoneAuthCredential) onAutoVerify,
  }) async {
    try {
      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (auth.PhoneAuthCredential credential) {
          onAutoVerify(credential);
        },
        verificationFailed: (auth.FirebaseAuthException e) {
          onError(e.message ?? 'Verification failed');
        },
        codeSent: (String verificationId, int? resendToken) {
          onCodeSent(verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // Handle timeout
        },
      );
    } catch (e) {
      onError(e.toString());
    }
  }

  // Verify OTP
  Future<User?> verifyOTP({
    required String verificationId,
    required String smsCode,
  }) async {
    try {
      final credential = auth.PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );

      final result = await _firebaseAuth.signInWithCredential(credential);
      final firebaseUser = result.user;

      if (firebaseUser != null) {
        return User(
          uid: firebaseUser.uid,
          phoneNumber: firebaseUser.phoneNumber ?? '',
          displayName: firebaseUser.displayName,
          lastLogin: DateTime.now(),
        );
      }
    } catch (e) {
      throw Exception('OTP verification failed: ${e.toString()}');
    }
    return null;
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      throw Exception('Sign out failed: ${e.toString()}');
    }
  }

  // Check if user is logged in
  bool get isLoggedIn {
    return _firebaseAuth.currentUser != null;
  }
}
