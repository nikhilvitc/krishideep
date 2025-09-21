import '../models/user.dart';

class AuthService {
  bool _isLoggedIn = false;
  User? _currentUser;

  // Get current user
  User? get currentUser => _currentUser;

  // Stream of auth changes - Mock implementation
  Stream<User?> get authStateChanges async* {
    yield _currentUser;
  }

  // Send OTP to phone number - Mock implementation
  Future<void> sendOTP({
    required String phoneNumber,
    required Function(String) onCodeSent,
    required Function(String) onError,
    required Function(String) onAutoVerify,
  }) async {
    try {
      // Simulate delay
      await Future.delayed(const Duration(seconds: 2));
      // Mock verification ID
      onCodeSent('mock_verification_id');
    } catch (e) {
      onError(e.toString());
    }
  }

  // Verify OTP - Mock implementation
  Future<User?> verifyOTP({
    required String verificationId,
    required String smsCode,
  }) async {
    try {
      // Simulate delay
      await Future.delayed(const Duration(seconds: 2));

      // Accept demo OTP 123456
      if (smsCode == '123456') {
        _currentUser = User(
          uid: 'demo_user_123',
          phoneNumber: '+91234567890',
          displayName: 'Demo User',
          lastLogin: DateTime.now(),
        );
        _isLoggedIn = true;
        return _currentUser;
      } else {
        throw Exception('Invalid OTP');
      }
    } catch (e) {
      throw Exception('OTP verification failed: ${e.toString()}');
    }
  }

  // Sign out - Mock implementation
  Future<void> signOut() async {
    try {
      _currentUser = null;
      _isLoggedIn = false;
    } catch (e) {
      throw Exception('Sign out failed: ${e.toString()}');
    }
  }

  // Check if user is logged in
  bool get isLoggedIn => _isLoggedIn;
}
