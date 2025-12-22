import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'providers/todo_provider.dart';
import 'utils/app_theme.dart';

// --- BAGIAN INI SANGAT PENTING (JANGAN DIHAPUS) ---
void main() {
  runApp(const MyApp());
}
// --------------------------------------------------

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TodoProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Todo List App',
        theme: AppTheme.lightTheme,
        home: const HomeScreen(),
      ),
    );
  }
}