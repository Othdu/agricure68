import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/localization/app_localizations.dart';

// Define text styles locally since they're not in a separate file
class AppTextStyles {
  static TextStyle headline(BuildContext context) =>
      Theme.of(context).textTheme.headlineSmall!.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          );

  static TextStyle bodyRegular(BuildContext context) =>
      Theme.of(context).textTheme.bodyMedium!.copyWith(
            color: AppColors.textSecondary,
          );
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.profile, style: const TextStyle(color: Colors.white)),
        backgroundColor: AppColors.primary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      size: 60,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'axcess',
                    style: AppTextStyles.headline(context).copyWith(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'axcesstechsolutions@gmail.com',
                    style: AppTextStyles.bodyRegular(context).copyWith(
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            
            const SizedBox(height: 30),
            
            // Profile Sections
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _buildProfileSection(
                    context,
                    'Personal Information',
                    [
                      _buildProfileItem(context, 'Full Name', 'Axcess'),
                      _buildProfileItem(context, 'Email', 'axcesstechsolutions@gmail.com'),
                      _buildProfileItem(context, 'Phone', '+1 234 567 8900'),
                      _buildProfileItem(context, 'Location', 'Farm Location'),
                    ],
                  ),
                  // 'email': 'axcesstechsolutions@gmail.com''name': 'Axcess',
    
                  const SizedBox(height: 24),
                  
                  _buildProfileSection(
                    context,
                    'Farm Information',
                    [
                      _buildProfileItem(context, 'Farm Name', 'Green Valley Farm'),
                      _buildProfileItem(context, 'Farm Size', '50 acres'),
                      _buildProfileItem(context, 'Crop Types', 'Corn, Wheat, Soybeans'),
                      _buildProfileItem(context, 'Experience', '10+ years'),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Logout Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _showLogoutDialog(context),
                      icon: const Icon(Icons.logout, color: Colors.white),
                      label: Text(l10n.logout, style: const TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.error,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection(BuildContext context, String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: _sectionTitleStyle),
        const SizedBox(height: 16),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: items,
          ),
        ),
      ],
    );
  }

  Widget _buildProfileItem(BuildContext context, String title, String value) {
    final textPrimary = Theme.of(context).brightness == Brightness.dark 
        ? Colors.white 
        : Colors.black;
    
    return ListTile(
      title: Text(title, style: TextStyle(color: textPrimary)),
      subtitle: Text(value, style: TextStyle(color: textPrimary.withOpacity(0.7))),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        // Handle item tap
      },
    );
  }

  void _showLogoutDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textPrimary = Theme.of(context).brightness == Brightness.dark 
        ? Colors.white 
        : Colors.black;
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(l10n.logout, style: TextStyle(color: textPrimary)),
          content: Text(l10n.confirmLogout, style: TextStyle(color: textPrimary)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.cancel, style: TextStyle(color: textPrimary)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Handle logout
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
              ),
              child: Text(l10n.logout, style: const TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  TextStyle get _sectionTitleStyle => const TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );
}
