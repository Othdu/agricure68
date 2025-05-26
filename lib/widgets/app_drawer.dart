import 'package:flutter/material.dart';
import '../screens/profile_page.dart';
import '../screens/contact_us_page.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: const Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Text(
                "AgriUser",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
            accountEmail: Text(
              "agri.user@example.com",
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withOpacity(0.85),
              ),
            ),
            currentAccountPicture: GestureDetector(
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfilePage(),
                  ),
                );
              },
              child: const CircleAvatar(
                backgroundColor: Color(0xFFFF9800),
                child: Icon(
                  Icons.person_outline,
                  size: 50,
                  color: Colors.white,
                ),
              ),
            ),
            decoration: const BoxDecoration(
              color: Color(0xFF388E3C),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard_outlined, color: Color(0xFF388E3C)),
            title: const Text('Dashboard', style: TextStyle(fontSize: 15, color: Color(0xFF212121))),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.article_outlined, color: Color(0xFF388E3C)),
            title: const Text('My Farm Profile', style: TextStyle(fontSize: 15, color: Color(0xFF212121))),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfilePage(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings_outlined, color: Color(0xFF388E3C)),
            title: const Text('App Settings', style: TextStyle(fontSize: 15, color: Color(0xFF212121))),
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Settings Tapped (Not Implemented)')),
              );
            },
          ),
          const Divider(thickness: 1, indent: 16, endIndent: 16),
          ListTile(
            leading: const Icon(Icons.contact_support_outlined, color: Color(0xFF388E3C)),
            title: const Text('Contact Us', style: TextStyle(fontSize: 15, color: Color(0xFF212121))),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ContactUsPage(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.info_outline, color: Color(0xFF388E3C)),
            title: const Text('About AgriCure', style: TextStyle(fontSize: 15, color: Color(0xFF212121))),
            onTap: () {
              Navigator.pop(context);
              showAboutDialog(
                context: context,
                applicationName: 'AgriCure',
                applicationVersion: '1.0.0',
                applicationIcon: const CircleAvatar(
                  backgroundColor: Color(0xFF4CAF50),
                  child: Icon(Icons.agriculture, color: Colors.white),
                ),
                applicationLegalese: '© 2024 AgriCure Solutions',
                children: const <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 15),
                    child: Text('Your smart farming assistant, helping you manage and optimize your agricultural practices.'),
                  )
                ],
              );
            },
          ),
          const Divider(thickness: 1, indent: 16, endIndent: 16),
          ListTile(
            leading: const Icon(Icons.logout_outlined, color: Color(0xFFF44336)),
            title: const Text(
              'Logout',
              style: TextStyle(fontSize: 15, color: Color(0xFFF44336), fontWeight: FontWeight.w600),
            ),
            onTap: () {
              // Navigator.pop(context);
              // ScaffoldMessenger.of(context).showSnackBar(
              //   const SnackBar(content: Text('Logout Tapped (Not Implemented)')),
              // );
            },
          ),
        ],
      ),
    );
  }
} 