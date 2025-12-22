import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
// import 'package:google_fonts/google_fonts.dart'; // Hapus/Comment dulu kalau belum install package-nya

import 'models/calorie_model.dart';
import 'screens/main_screen.dart';
import 'screens/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  
  // Register Adapter & Open Box (Biarkan sama seperti sebelumnya)
  Hive.registerAdapter(FoodItemAdapter());
  Hive.registerAdapter(UserSettingsAdapter());
  Hive.registerAdapter(FastingTaskAdapter());
  
  await Hive.openBox<FoodItem>('foodBox');
  await Hive.openBox<UserSettings>('settingsBox');
  await Hive.openBox<FastingTask>('fastingBox');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // CEK LOGIN DI SINI
    final settingsBox = Hive.box<UserSettings>('settingsBox');
    final userSettings = settingsBox.get('userSettings');
    
    // Logika: Jika userName ada, berarti sudah login.
    final bool isLoggedIn = userSettings?.userName != null;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MyHealth TA',
      theme: _buildTailwindTheme(), // Tema Tailwind kamu yg tadi
      
      // Tentukan halaman awal berdasarkan status login
      home: isLoggedIn ? const MainScreen() : const LoginPage(),
    );
  }

  // ... fungsi _buildTailwindTheme biarkan sama ...
}
  ThemeData _buildTailwindTheme() {
    const primaryColor = Color(0xFF10B981);
    const backgroundColor = Color(0xFFF8FAFC);
    const textColor = Color(0xFF1E293B);

    return ThemeData(
      useMaterial3: true,
      // Set background scaffold di sini
      scaffoldBackgroundColor: backgroundColor,
      
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        surface: Colors.white,
      ),

      // 1. APP BAR
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: textColor,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
        iconTheme: IconThemeData(color: primaryColor),
      ),


      // 3. INPUT TEXT
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
      ),

      // 4. BUTTON
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),

      // 5. NAVIGATION BAR
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.white,
        indicatorColor: primaryColor.withOpacity(0.2),
        elevation: 2,
      ),
    );
}