import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/calorie_model.dart';
import 'main_screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _targetController = TextEditingController(text: "2000");
  final Box<UserSettings> settingsBox = Hive.box<UserSettings>('settingsBox');

  void _saveAndLogin() {
    if (_nameController.text.isNotEmpty && _targetController.text.isNotEmpty) {
      // Simpan data user ke Hive
      final settings = UserSettings(
        userName: _nameController.text,
        dailyTarget: int.parse(_targetController.text),
      );
      settingsBox.put('userSettings', settings);

      // Pindah ke Halaman Utama (Replacement biar gak bisa back)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Isi nama dan target dulu ya!"))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Logo / Icon Besar
              const Icon(Icons.health_and_safety, size: 80, color: Color(0xFF10B981)),
              const SizedBox(height: 16),
              
              // 2. Judul Sambutan
              const Text(
                "Selamat Datang di\nMyHealth",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Mulai perjalanan sehatmu hari ini.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey[500]),
              ),
              const SizedBox(height: 40),

              // 3. Form Input Nama
              const Text("Nama Panggilan", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  hintText: "Contoh: Budi",
                  prefixIcon: Icon(Icons.person_outline),
                ),
              ),
              const SizedBox(height: 20),

              // 4. Form Input Target Kalori
              const Text("Target Kalori Harian", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextField(
                controller: _targetController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: "Contoh: 2000",
                  prefixIcon: Icon(Icons.local_fire_department_outlined),
                  suffixText: "kkal",
                ),
              ),

              const SizedBox(height: 40),

              // 5. Tombol Mulai
              ElevatedButton(
                onPressed: _saveAndLogin,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text("Mulai Sekarang 🚀", style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}