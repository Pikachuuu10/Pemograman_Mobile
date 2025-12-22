import 'dart:async'; // Butuh ini buat Timer otomatis
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import '../models/calorie_model.dart';

class FastingPage extends StatefulWidget {
  const FastingPage({super.key});

  @override
  State<FastingPage> createState() => _FastingPageState();
}

class _FastingPageState extends State<FastingPage> {
  final Box<FastingTask> fastingBox = Hive.box<FastingTask>('fastingBox');
  final TextEditingController _taskController = TextEditingController();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Nyalakan Timer setiap 10 detik untuk cek otomatis
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      _checkAutoCompletion();
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Matikan timer kalau keluar halaman biar gak boros baterai
    super.dispose();
  }

  // --- LOGIKA UTAMA: CEK OTOMATIS ---
  void _checkAutoCompletion() {
    final now = DateTime.now();
    bool isUpdated = false;

    // Loop semua tugas
    for (var task in fastingBox.values) {
      // Jika BELUM selesai DAN waktu sekarang SUDAH MELEWATI target
      if (!task.isCompleted && now.isAfter(task.targetTime)) {
        task.isCompleted = true; // Otomatis Ceklis ✅
        task.save(); // Simpan ke database
        isUpdated = true;
      }
    }

    // Refresh layar kalau ada yang berubah
    if (isUpdated && mounted) {
      setState(() {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("🎉 Target Puasa Tercapai! Otomatis diceklis."),
            backgroundColor: Colors.green,
          )
        );
      });
    }
  }

  // Fungsi Tambah Jadwal dengan JAM
  void _addFastingTask() async {
    _taskController.clear();
    
    // 1. Input Nama
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Rencana Puasa"),
        content: TextField(
          controller: _taskController,
          decoration: const InputDecoration(
            labelText: "Nama Puasa",
            hintText: "Contoh: Puasa Senin Kamis",
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Lanjut Pilih Jam"),
          ),
        ],
      ),
    );

    if (_taskController.text.isEmpty) return;

    // 2. Pilih Jam Selesai (Time Picker)
    if (!mounted) return;
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 18, minute: 0), // Default jam 6 sore
      helpText: "JAM BERAPA SELESAI PUASA?",
    );

    if (pickedTime != null) {
      // Gabungkan Tanggal Hari Ini + Jam Pilihan
      final now = DateTime.now();
      DateTime targetDateTime = DateTime(
        now.year, now.month, now.day, 
        pickedTime.hour, pickedTime.minute
      );

      // Logika Pintar: Kalau jam yang dipilih LEBIH KECIL dari jam sekarang,
      // Berarti user maksudnya untuk BESOK.
      // (Misal sekarang jam 20.00, user pilih jam 05.00 Subuh, berarti besok)
      if (targetDateTime.isBefore(now)) {
        targetDateTime = targetDateTime.add(const Duration(days: 1));
      }

      // Simpan ke Database
      final newTask = FastingTask(
        title: _taskController.text,
        date: DateTime.now(),
        targetTime: targetDateTime, // Simpan target waktunya
        isCompleted: false,
      );
      fastingBox.add(newTask);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Jadwal Puasa Otomatis")),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addFastingTask,
        label: const Text("Buat Target"),
        icon: const Icon(Icons.timer_sharp),
      ),
      body: ValueListenableBuilder(
        valueListenable: fastingBox.listenable(),
        builder: (context, Box<FastingTask> box, _) {
          final tasks = box.values.toList().cast<FastingTask>();
          
          if (tasks.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.av_timer, size: 80, color: Colors.grey[300]),
                  const SizedBox(height: 10),
                  const Text("Belum ada target puasa.", style: TextStyle(color: Colors.grey)),
                ],
              ),
            );
          }

          // Urutkan biar yang terbaru di atas
          final reversedTasks = tasks.reversed.toList();

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: reversedTasks.length,
            itemBuilder: (context, index) {
              final task = reversedTasks[index];
              
              // Cek status waktu untuk UI
              final now = DateTime.now();
              final isTimePassed = now.isAfter(task.targetTime);
              
              return Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 12),
                color: task.isCompleted ? Colors.green[50] : Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        // Checkbox diganti Icon status (User gak bisa klik manual, sistem yang atur)
                        leading: CircleAvatar(
                          backgroundColor: task.isCompleted 
                              ? Colors.green 
                              : Colors.orange.withOpacity(0.2),
                          child: Icon(
                            task.isCompleted ? Icons.check : Icons.hourglass_bottom,
                            color: task.isCompleted ? Colors.white : Colors.orange,
                          ),
                        ),
                        title: Text(
                          task.title,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                          ),
                        ),
                        subtitle: Text(
                          "Target: ${DateFormat('HH:mm').format(task.targetTime)} • ${DateFormat('d MMM').format(task.targetTime)}",
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.redAccent),
                          onPressed: () => task.delete(),
                        ),
                      ),
                      
                      // Progress Bar atau Status Text
                      if (!task.isCompleted)
                        Container(
                          padding: const EdgeInsets.all(8),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.orange[50],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.orange.withOpacity(0.3))
                          ),
                          child: Text(
                            "⏳ Menunggu waktu buka puasa...",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.orange[800], fontSize: 12),
                          ),
                        ),
                        
                      if (task.isCompleted)
                        Container(
                          padding: const EdgeInsets.all(8),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.green[100],
                            borderRadius: BorderRadius.circular(8)
                          ),
                          child: const Text(
                            "✅ Puasa Selesai!",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}