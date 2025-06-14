import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme/theme_provider.dart';
import '../core/localization/app_localizations.dart';
import '../core/accessibility/accessibility_provider.dart';
import '../providers/auth_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Language Settings
          _buildSectionHeader(context, l10n.language, Icons.language),
          _buildLanguageSettings(context),
          
          const SizedBox(height: 24),
          
          // Accessibility Settings
          _buildSectionHeader(context, l10n.accessibility, Icons.accessibility),
          _buildAccessibilitySettings(context),
          
          const SizedBox(height: 24),
          
          // Dashboard Customization
          _buildSectionHeader(context, l10n.customize, Icons.dashboard),
          _buildDashboardSettings(context),
          
          const SizedBox(height: 24),
          
          // About Section
          _buildSectionHeader(context, 'About', Icons.info),
          _buildAboutSection(context),
          
          const SizedBox(height: 24),
          
          // Account Section
          _buildSectionHeader(context, 'Account', Icons.person),
          _buildAccountSection(context),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).primaryColor, size: 24),
          const SizedBox(width: 12),
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageSettings(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final languageProvider = Provider.of<LanguageProvider>(context);
    
    return Card(
      child: Column(
        children: AppLocalizations.supportedLocales.map((locale) {
          final languageName = _getLanguageName(locale.languageCode);
          return RadioListTile<String>(
            title: Text(languageName),
            value: locale.languageCode,
            groupValue: languageProvider.locale.languageCode,
            onChanged: (String? value) {
              if (value != null) {
                languageProvider.setLocale(Locale(value, ''));
              }
            },
          );
        }).toList(),
      ),
    );
  }

  Widget _buildAccessibilitySettings(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final accessibilityProvider = Provider.of<AccessibilityProvider>(context);
    
    return Card(
      child: Column(
        children: [
          SwitchListTile(
            title: Text(l10n.screenReader),
            subtitle: Text(l10n.enableScreenReaderSupport),
            value: accessibilityProvider.screenReaderEnabled,
            onChanged: accessibilityProvider.setScreenReaderEnabled,
          ),
          SwitchListTile(
            title: Text(l10n.highContrast),
            subtitle: Text(l10n.increaseContrastForBetterVisibility),
            value: accessibilityProvider.highContrastEnabled,
            onChanged: accessibilityProvider.setHighContrastEnabled,
          ),
          SwitchListTile(
            title: Text(l10n.largeText),
            subtitle: Text(l10n.increaseTextSizeForBetterReadability),
            value: accessibilityProvider.largeTextEnabled,
            onChanged: accessibilityProvider.setLargeTextEnabled,
          ),
          SwitchListTile(
            title: Text(l10n.reduceMotion),
            subtitle: Text(l10n.reduceAnimationsForMotionSensitivity),
            value: accessibilityProvider.reduceMotionEnabled,
            onChanged: accessibilityProvider.setReduceMotionEnabled,
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardSettings(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: Text(l10n.customize),
            subtitle: Text(l10n.customizeYourDashboardLayout),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Navigate to dashboard customization page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DashboardCustomizationPage(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.add),
            title: Text(l10n.addWidget),
            subtitle: Text(l10n.addNewWidgetsToYourDashboard),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Navigate to widget selection page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const WidgetSelectionPage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.info),
            title: Text(l10n.version),
            subtitle: const Text('1.0.0'),
          ),
          ListTile(
            leading: const Icon(Icons.description),
            title: Text(l10n.privacyPolicy),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Navigate to privacy policy
            },
          ),
          ListTile(
            leading: const Icon(Icons.description),
            title: Text(l10n.termsOfService),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Navigate to terms of service
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAccountSection(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.email),
            title: const Text('Email'),
            subtitle: Text(authProvider.userEmail.isNotEmpty 
                ? authProvider.userEmail 
                : 'Not logged in'),
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Logout', style: TextStyle(color: Colors.red)),
            onTap: () => _showLogoutDialog(context),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                final authProvider = Provider.of<AuthProvider>(context, listen: false);
                await authProvider.logout();
                if (context.mounted) {
                  Navigator.of(context).pushReplacementNamed('/login');
                }
              },
              child: const Text('Logout', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  String _getLanguageName(String languageCode) {
    switch (languageCode) {
      case 'en':
        return 'English';
      case 'es':
        return 'Español';
      case 'fr':
        return 'Français';
      case 'ar':
        return 'العربية';
      case 'zh':
        return '中文';
      default:
        return 'English';
    }
  }
}

// Placeholder pages for dashboard customization
class DashboardCustomizationPage extends StatelessWidget {
  const DashboardCustomizationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.customizeDashboard),
      ),
      body: Center(
        child: Text(l10n.dashboardCustomizationComingSoon),
      ),
    );
  }
}

class WidgetSelectionPage extends StatelessWidget {
  const WidgetSelectionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.addWidgets),
      ),
      body: Center(
        child: Text(l10n.widgetSelectionComingSoon),
      ),
    );
  }
} 