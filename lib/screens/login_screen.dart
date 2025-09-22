import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isOtpSent = false;
  bool _isLoading = false;
  String _verificationId = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('login'.tr()),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.green.shade700, Colors.green.shade50],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // App Logo/Icon
                    Container(
                      width: 80,
                      height: 80,
                      child: Image.asset(
                        'assets/images/krisi_deep_logo.png',
                        width: 80,
                        height: 80,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.agriculture,
                              size: 80, color: Colors.white);
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'app_name'.tr(),
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 48),

                    // Login Card
                    Card(
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          children: [
                            if (!_isOtpSent) ...[
                              // Phone Number Input
                              Text(
                                'enter_phone'.tr(),
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 24),
                              TextFormField(
                                controller: _phoneController,
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                  labelText: 'phone_number'.tr(),
                                  prefixText: '+91 ',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  prefixIcon: const Icon(Icons.phone),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter phone number';
                                  }
                                  if (value.length != 10) {
                                    return 'Please enter valid 10-digit number';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 24),
                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: _isLoading ? null : _sendOTP,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green.shade700,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: _isLoading
                                      ? const CircularProgressIndicator(
                                          color: Colors.white,
                                        )
                                      : Text(
                                          'send_otp'.tr(),
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                ),
                              ),
                            ] else ...[
                              // OTP Verification
                              Text(
                                'verify_otp'.tr(),
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'OTP sent to +91 ${_phoneController.text}',
                                style: TextStyle(color: Colors.grey.shade600),
                              ),
                              const SizedBox(height: 24),
                              TextFormField(
                                controller: _otpController,
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                maxLength: 6,
                                decoration: InputDecoration(
                                  labelText: 'enter_otp'.tr(),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  prefixIcon: const Icon(Icons.security),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter OTP';
                                  }
                                  if (value.length != 6) {
                                    return 'Please enter valid 6-digit OTP';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 24),
                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: _isLoading ? null : _verifyOTP,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green.shade700,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: _isLoading
                                      ? const CircularProgressIndicator(
                                          color: Colors.white,
                                        )
                                      : Text(
                                          'verify'.tr(),
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              TextButton(
                                onPressed: _isLoading ? null : _sendOTP,
                                child: Text('resend_otp'.tr()),
                              ),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    _isOtpSent = false;
                                    _otpController.clear();
                                  });
                                },
                                child: Text('back'.tr()),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Language Selection
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Text(
                              'language_selection'.tr(),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    context.setLocale(const Locale('en'));
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        context.locale.languageCode == 'en'
                                            ? Colors.green.shade700
                                            : Colors.grey.shade300,
                                    foregroundColor:
                                        context.locale.languageCode == 'en'
                                            ? Colors.white
                                            : Colors.black,
                                  ),
                                  child: Text('english'.tr()),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    context.setLocale(const Locale('hi'));
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        context.locale.languageCode == 'hi'
                                            ? Colors.green.shade700
                                            : Colors.grey.shade300,
                                    foregroundColor:
                                        context.locale.languageCode == 'hi'
                                            ? Colors.white
                                            : Colors.black,
                                  ),
                                  child: Text('hindi'.tr()),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    context.setLocale(const Locale('ta'));
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        context.locale.languageCode == 'ta'
                                            ? Colors.green.shade700
                                            : Colors.grey.shade300,
                                    foregroundColor:
                                        context.locale.languageCode == 'ta'
                                            ? Colors.white
                                            : Colors.black,
                                  ),
                                  child: Text('tamil'.tr()),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _sendOTP() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final authService = AuthService();
      await authService.sendOTP(
        phoneNumber: '+91${_phoneController.text}',
        onCodeSent: (verificationId) {
          _verificationId = verificationId;
          setState(() {
            _isOtpSent = true;
            _isLoading = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('OTP sent successfully! Use 123456 for demo'),
              backgroundColor: Colors.green,
            ),
          );
        },
        onError: (error) {
          setState(() {
            _isLoading = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to send OTP: $error'),
              backgroundColor: Colors.red,
            ),
          );
        },
        onAutoVerify: (credential) {
          // Auto-verify handled by service
        },
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to send OTP: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _verifyOTP() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final authService = AuthService();
      final user = await authService.verifyOTP(
        verificationId: _verificationId,
        smsCode: _otpController.text,
      );

      if (user != null) {
        // Navigate to main app
        Navigator.of(context).pushReplacementNamed('/main');
      } else {
        throw Exception('Authentication failed');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('OTP verification failed: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }
}
