import 'package:flutter/material.dart';
import '../plant_data_provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  Widget _buildProfileSection(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: Color(0xFF4CAF50),
              child: Icon(
                Icons.person_outline,
                size: 50,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'AgriUser',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'agri.user@example.com',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),
            _buildProfileButton(
              icon: Icons.edit,
              label: 'Edit Profile',
              onTap: () {
                // TODO: Implement edit profile functionality
              },
            ),
            const Divider(height: 32),
            _buildProfileButton(
              icon: Icons.notifications_outlined,
              label: 'Notifications',
              onTap: () {
                // TODO: Implement notifications settings
              },
            ),
            _buildProfileButton(
              icon: Icons.security_outlined,
              label: 'Privacy & Security',
              onTap: () {
                // TODO: Implement privacy settings
              },
            ),
            _buildProfileButton(
              icon: Icons.language_outlined,
              label: 'Language',
              onTap: () {
                // TODO: Implement language settings
              },
            ),
            _buildProfileButton(
              icon: Icons.help_outline,
              label: 'Help & Support',
              onTap: () {
                // TODO: Implement help & support
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF4CAF50)),
      title: Text(label),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: const Color(0xFF4CAF50),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProfileSection(context),
          ],
        ),
      ),
    );
  }
} 