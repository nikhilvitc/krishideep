import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import '../main.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('profile_settings'.tr()),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Header
            _buildProfileHeader(),
            const SizedBox(height: 24),

            // Account Information
            _buildSectionTitle('account_info'.tr()),
            _buildAccountInfo(),
            const SizedBox(height: 24),

            // Preferences
            _buildSectionTitle('preferences'.tr()),
            _buildPreferences(context),
            const SizedBox(height: 24),

            // App Information
            _buildSectionTitle('app_info'.tr()),
            _buildAppInfo(),
            const SizedBox(height: 24),

            // Support
            _buildSectionTitle('support_contact'.tr()),
            _buildSupport(context),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.green.shade600, Colors.green.shade800],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // Profile Avatar
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(40),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: Image.asset(
                'assets/images/krisi_deep_logo.png',
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.person,
                    size: 40,
                    color: Colors.green.shade700,
                  );
                },
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Profile Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'app_name'.tr(),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'app_tagline'.tr(),
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Premium User',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.grey.shade800,
        ),
      ),
    );
  }

  Widget _buildAccountInfo() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildInfoTile(
            Icons.person,
            'Profile',
            'Manage your personal information',
            () {},
          ),
          const Divider(height: 1),
          _buildInfoTile(
            Icons.security,
            'Security',
            'Password and security settings',
            () {},
          ),
          const Divider(height: 1),
          _buildInfoTile(
            Icons.notifications,
            'notifications'.tr(),
            'Manage notification preferences',
            () {},
          ),
        ],
      ),
    );
  }

  Widget _buildPreferences(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Theme Toggle
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return _buildInfoTile(
                themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                'change_theme'.tr(),
                themeProvider.isDarkMode ? 'light_mode'.tr() : 'dark_mode'.tr(),
                () {
                  themeProvider.toggleTheme();
                },
                trailing: Switch(
                  value: themeProvider.isDarkMode,
                  onChanged: (value) {
                    themeProvider.toggleTheme();
                  },
                  activeColor: Colors.green,
                ),
              );
            },
          ),
          const Divider(height: 1),
          // Language Selection
          _buildInfoTile(
            Icons.language,
            'language_selection'.tr(),
            'Select your preferred language',
            () {
              _showLanguageSelection(context);
            },
            trailing: Text(
              _getCurrentLanguageName(context),
              style: TextStyle(
                color: Colors.green.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppInfo() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildInfoTile(
            Icons.info,
            'about_app'.tr(),
            'Learn more about this app',
            () {},
          ),
          const Divider(height: 1),
          _buildInfoTile(
            Icons.update,
            'version'.tr(),
            '1.0.0',
            () {},
            trailing: Text(
              '1.0.0',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const Divider(height: 1),
          _buildInfoTile(
            Icons.build,
            'build_number'.tr(),
            '1',
            () {},
            trailing: Text(
              '1',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSupport(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildInfoTile(
            Icons.help,
            'Help & Support',
            'Get help and contact support',
            () {},
          ),
          const Divider(height: 1),
          _buildInfoTile(
            Icons.privacy_tip,
            'privacy_policy'.tr(),
            'Read our privacy policy',
            () {},
          ),
          const Divider(height: 1),
          _buildInfoTile(
            Icons.description,
            'terms_of_service'.tr(),
            'Read terms of service',
            () {},
          ),
          const Divider(height: 1),
          _buildInfoTile(
            Icons.logout,
            'logout'.tr(),
            'Sign out of your account',
            () {
              _showLogoutDialog(context);
            },
            textColor: Colors.red,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile(
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap, {
    Widget? trailing,
    Color? textColor,
  }) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.green.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: textColor ?? Colors.green.shade600,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: Colors.grey.shade600,
          fontSize: 12,
        ),
      ),
      trailing: trailing ?? Icon(
        Icons.chevron_right,
        color: Colors.grey.shade400,
      ),
      onTap: onTap,
    );
  }

  static void _showLanguageSelection(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'select_language'.tr(),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.language),
                title: const Text('English'),
                trailing: _isCurrentLanguage(context, 'en') ? const Icon(Icons.check, color: Colors.green) : null,
                onTap: () {
                  context.setLocale(const Locale('en'));
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.language),
                title: const Text('हिंदी'),
                trailing: _isCurrentLanguage(context, 'hi') ? const Icon(Icons.check, color: Colors.green) : null,
                onTap: () {
                  context.setLocale(const Locale('hi'));
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.language),
                title: const Text('தமிழ்'),
                trailing: _isCurrentLanguage(context, 'ta') ? const Icon(Icons.check, color: Colors.green) : null,
                onTap: () {
                  context.setLocale(const Locale('ta'));
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  static void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('logout'.tr()),
          content: Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('cancel'.tr()),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                // Implement logout logic here
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Logged out successfully')),
                );
              },
              child: Text('logout'.tr()),
            ),
          ],
        );
      },
    );
  }

  static bool _isCurrentLanguage(BuildContext context, String languageCode) {
    return context.locale.languageCode == languageCode;
  }

  static String _getCurrentLanguageName(BuildContext context) {
    switch (context.locale.languageCode) {
      case 'hi':
        return 'हिंदी';
      case 'ta':
        return 'தமிழ்';
      default:
        return 'English';
    }
  }
}
