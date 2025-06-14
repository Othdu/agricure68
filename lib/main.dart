import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/farm_data_provider.dart';
import 'providers/auth_provider.dart';
import 'plant_data_provider.dart';  // Updated import
import 'screens/home_page.dart';
import 'screens/splash_screen.dart';
import 'screens/settings_page.dart';
import 'screens/login_page.dart';
import 'screens/signup_page.dart';
import 'core/theme/theme_provider.dart';
import 'core/theme/app_colors.dart';
import 'core/localization/app_localizations.dart';
import 'core/accessibility/accessibility_provider.dart';

// Import AppColors if you need it for global theme setup, otherwise it's encapsulated
// import 'core/theme/app_colors.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FarmDataProvider()),
        ChangeNotifierProvider(
          create: (_) {
            final provider = SensorDataProvider();
            // Initialize in the background
            provider.init();
            return provider;
          },
        ),
        
        // Authentication provider
        ChangeNotifierProvider(
          create: (_) {
            final provider = AuthProvider();
            // Initialize in the background
            provider.initialize();
            return provider;
          },
        ),
        
        // New providers for enhanced UI/UX
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ChangeNotifierProvider(create: (_) => AccessibilityProvider()),
      ],
      child: Consumer4<ThemeProvider, LanguageProvider, AccessibilityProvider, AuthProvider>(
        builder: (context, themeProvider, languageProvider, accessibilityProvider, authProvider, child) {
          // Initialize providers
          themeProvider.initialize();
          languageProvider.initialize();
          accessibilityProvider.initialize();
          
          return MaterialApp(
            title: 'AgriCure',
            
            // Theme configuration
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            
            // Localization configuration
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: languageProvider.locale,
            
            // Accessibility configuration
            builder: (context, child) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaleFactor: accessibilityProvider.textScaleFactor,
                ),
                child: child!,
              );
            },
            
            home: const SplashScreen(),
            routes: {
              '/login': (context) => const LoginPage(),
              '/signup': (context) => const SignupPage(),
              '/home': (context) => const HomePage(),
              '/settings': (context) => const SettingsPage(),
            },
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}