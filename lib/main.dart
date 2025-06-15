import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'providers/farm_data_provider.dart';
import 'providers/auth_provider.dart';
import 'plant_data_provider.dart';  // Updated import
import 'services/firebase_service.dart';
import 'screens/home_page.dart';
import 'screens/splash_screen.dart';
import 'screens/settings_page.dart';
import 'screens/login_page.dart';
import 'screens/signup_page.dart';
import 'core/theme/app_colors.dart' as theme_colors;
import 'core/localization/app_localizations.dart';
import 'core/accessibility/accessibility_provider.dart';
import 'providers/detections_provider.dart';

// Import AppColors if you need it for global theme setup, otherwise it's encapsulated
// import 'core/theme/app_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  try {
    await Firebase.initializeApp();
  } catch (e) {
    print('Failed to initialize Firebase: $e');
  }
  
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
        
        // Firebase service provider
        ChangeNotifierProvider(create: (_) => FirebaseService()),
        
        // Providers for enhanced UI/UX (removed ThemeProvider)
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ChangeNotifierProvider(create: (_) => AccessibilityProvider()),
        ChangeNotifierProvider(create: (_) => DetectionsProvider()),
      ],
      child: Consumer3<LanguageProvider, AccessibilityProvider, AuthProvider>(
        builder: (context, languageProvider, accessibilityProvider, authProvider, child) {
          // Initialize providers
          languageProvider.initialize();
          accessibilityProvider.initialize();
          
          return MaterialApp(
            title: 'AgriCure',
            
            // Theme configuration - only light theme
            theme: ThemeData(
              useMaterial3: true,
              brightness: Brightness.light,
              colorScheme: ColorScheme.light(
                primary: theme_colors.AppColors.primary,
                primaryContainer: theme_colors.AppColors.primaryLight,
                secondary: theme_colors.AppColors.accent,
                surface: theme_colors.AppColors.cardBackground,
                background: theme_colors.AppColors.background,
                error: theme_colors.AppColors.error,
                onPrimary: Colors.white,
                onSecondary: Colors.white,
                onSurface: theme_colors.AppColors.textPrimary,
                onBackground: theme_colors.AppColors.textPrimary,
                onError: Colors.white,
              ),
              scaffoldBackgroundColor: theme_colors.AppColors.background,
              cardTheme: CardTheme(
                color: theme_colors.AppColors.cardBackground,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              appBarTheme: AppBarTheme(
                backgroundColor: theme_colors.AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 4,
                centerTitle: true,
                titleTextStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme_colors.AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              textTheme: TextTheme(
                headlineLarge: TextStyle(
                  color: theme_colors.AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
                headlineMedium: TextStyle(
                  color: theme_colors.AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
                titleLarge: TextStyle(
                  color: theme_colors.AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
                bodyLarge: TextStyle(
                  color: theme_colors.AppColors.textSecondary,
                ),
                bodyMedium: TextStyle(
                  color: theme_colors.AppColors.textSecondary,
                ),
              ),
              iconTheme: IconThemeData(
                color: theme_colors.AppColors.iconColor,
              ),
            ),
            
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