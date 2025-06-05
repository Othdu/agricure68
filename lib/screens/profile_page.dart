import 'package:flutter/material.dart';

// Move these styles to a constant to avoid recreation
const _titleStyle = TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white);
const _emailStyle = TextStyle(color: Colors.white70);
const _sectionTitleStyle = TextStyle(
  fontWeight: FontWeight.bold,
  color: Color(0xFF757575),
  fontSize: 14,
);

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  static const Color primary = Color(0xFF4CAF50);
  static const Color primaryDark = Color(0xFF388E3C);
  static const Color background = Color(0xFFF0F0F0);
  static const Color cardBackground = Colors.white;
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color error = Color(0xFFF44336);

  static const Map<String, String> userData = {
    'name': 'Axcess',
    'email': 'axcesstechsolutions@gmail.com',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 240,
            pinned: true,
            backgroundColor: primary,
            flexibleSpace: FlexibleSpaceBar(
              expandedTitleScale: 1.0,
              titlePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              background: Container(
                color: primary,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 60),
                    const CircleAvatar(
                      radius: 48,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 44,
                        backgroundColor: primary,
                        child: Icon(Icons.person_outline, size: 44, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      userData['name']!,
                      style: _titleStyle,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      userData['email']!,
                      style: _emailStyle,
                    ),
                  ],
                ),
              ),
            ),
            title: const Text("Profile", style: TextStyle(color: Colors.white)),
            centerTitle: true,
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildSectionCard(
                  context,
                  title: "Account Settings",
                  items: [
                    _buildListTile(Icons.edit_outlined, "Edit Profile", () {}),
                    _buildListTile(Icons.notifications_outlined, "Notifications", () {}),
                    _buildListTile(Icons.lock_outline, "Privacy & Security", () {}),
                  ],
                ),
                const SizedBox(height: 16),
                _buildSectionCard(
                  context,
                  title: "Support & More",
                  items: [
                    _buildListTile(Icons.language_outlined, "Language", () {}),
                    _buildListTile(Icons.help_outline, "Help & Support", () {}),
                    _buildListTile(Icons.info_outline, "About Us", () {}),
                  ],
                ),
                const SizedBox(height: 32),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ElevatedButton.icon(
                    onPressed: () => _showLogoutDialog(context),
                    icon: const Icon(Icons.logout, color: Colors.white),
                    label: const Text("Logout", style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: error,
                      minimumSize: const Size.fromHeight(48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard(BuildContext context, {required String title, required List<Widget> items}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: _sectionTitleStyle),
            const Divider(height: 20),
            ...items,
          ],
        ),
      ),
    );
  }

  Widget _buildListTile(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
      leading: CircleAvatar(
        backgroundColor: primary.withOpacity(0.1),
        child: Icon(icon, color: primary),
      ),
      title: Text(title, style: TextStyle(color: textPrimary)),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Logout", style: TextStyle(color: Colors.black)),
        content: const Text("Are you sure you want to log out?", style: TextStyle(color: Colors.black)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel", style: TextStyle(color: Colors.black)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: error),
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Logout", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
