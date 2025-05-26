import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/farm_data_provider.dart';
import 'plant_data_provider.dart';  // Updated import
import 'screens/home_page.dart';
// Import AppColors if you need it for global theme setup, otherwise it's encapsulated
// import 'core/theme/app_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sensorProvider = SensorDataProvider();
  await sensorProvider.init();
  runApp(MyApp(sensorProvider: sensorProvider));
}

class MyApp extends StatelessWidget {
  final SensorDataProvider sensorProvider;

  const MyApp({super.key, required this.sensorProvider});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FarmDataProvider()),
        ChangeNotifierProvider.value(value: sensorProvider),
      ],
      child: MaterialApp(
        title: 'AgriCure',
        theme: ThemeData(
          // You can define your global theme here using AppColors if needed
          // primarySwatch: MaterialColor(AppColors.primary.value, { ... }),
          // colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
          useMaterial3: true, // Or false, depending on your preference
          scaffoldBackgroundColor: const Color(0xFFF5F5F5), // Example from AppColors.background
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF4CAF50), // Example from AppColors.primary
            elevation: 4.0,
            iconTheme: IconThemeData(color: Colors.white),
            titleTextStyle: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)
          )
        ),
        home: const HomePage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}