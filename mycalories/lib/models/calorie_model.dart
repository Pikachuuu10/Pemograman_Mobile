import 'package:hive/hive.dart';

part 'calorie_model.g.dart';

@HiveType(typeId: 1)
class FoodItem extends HiveObject {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final int calories;
  @HiveField(2)
  final DateTime date;

  FoodItem({required this.name, required this.calories, required this.date});
}

@HiveType(typeId: 2)
class UserSettings extends HiveObject {
  @HiveField(0)
  int dailyTarget;

  @HiveField(1)
  DateTime? fastingStartTime; 

  @HiveField(2)
  int fastingTargetHours; 
  
  // --- TAMBAHAN BARU ---
  @HiveField(3)
  String? userName; // Menyimpan nama user

  UserSettings({
    this.dailyTarget = 2000,
    this.fastingStartTime,
    this.fastingTargetHours = 16,
    this.userName,
  });
}

// --- TAMBAHAN BARU: TODO LIST PUASA ---
@HiveType(typeId: 3)
class FastingTask extends HiveObject {
  @HiveField(0)
  String title;        // Nama Puasa
  
  @HiveField(1)
  bool isCompleted;    // Status Selesai
  
  @HiveField(2)
  DateTime date;       // Tanggal Dibuat

  // --- FIELD BARU ---
  @HiveField(3)
  DateTime targetTime; // Jam berapa harus selesai

  FastingTask({
    required this.title, 
    this.isCompleted = false, 
    required this.date,
    required this.targetTime, // Wajib diisi sekarang
  });
}