import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../models/calorie_model.dart';

class DietPage extends StatefulWidget {
  const DietPage({super.key});

  @override
  State<DietPage> createState() => _DietPageState();
}

class _DietPageState extends State<DietPage> {
  final Box<FoodItem> foodBox = Hive.box<FoodItem>('foodBox');
  final Box<UserSettings> settingsBox = Hive.box<UserSettings>('settingsBox');
  
  // Controller untuk input makanan
  final TextEditingController _foodNameController = TextEditingController();
  final TextEditingController _calorieController = TextEditingController();

  // Helper untuk ambil data user settings
  UserSettings get _userSettings {
    // Kalau null (belum login), buat default sementara
    return settingsBox.get('userSettings') ?? UserSettings(dailyTarget: 2000, userName: "User");
  }

  int _calculateConsumed() {
    final today = DateTime.now();
    var entries = foodBox.values.where((item) =>
        item.date.year == today.year &&
        item.date.month == today.month &&
        item.date.day == today.day);
    int total = 0;
    for (var item in entries) total += item.calories;
    return total;
  }

  // --- FITUR BARU: EDIT TARGET ---
  void _showEditTargetDialog() {
    // Isi awal text field dengan target yang sekarang
    TextEditingController targetController = TextEditingController(
      text: _userSettings.dailyTarget.toString()
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Ubah Target Harian"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Berapa target kalori barumu?"),
            const SizedBox(height: 10),
            TextField(
              controller: targetController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Target (kkal)",
                suffixText: "kkal",
                prefixIcon: Icon(Icons.flag),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () {
              if (targetController.text.isNotEmpty) {
                // Update Database
                var settings = _userSettings;
                settings.dailyTarget = int.parse(targetController.text);
                settings.save(); // Simpan perubahan ke Hive

                Navigator.pop(context);
                setState(() {}); // Refresh layar
                
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Target diubah jadi ${settings.dailyTarget} kkal"))
                );
              }
            },
            child: const Text("Simpan"),
          ),
        ],
      ),
    );
  }

  void _addFood() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Catat Makanan"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _foodNameController, 
              decoration: const InputDecoration(labelText: "Nama Makanan", hintText: "Cth: Nasi Goreng")
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _calorieController, 
              decoration: const InputDecoration(labelText: "Kalori", suffixText: "kkal"), 
              keyboardType: TextInputType.number
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal")),
          ElevatedButton(
            onPressed: () {
              if (_foodNameController.text.isNotEmpty && _calorieController.text.isNotEmpty) {
                foodBox.add(FoodItem(
                  name: _foodNameController.text,
                  calories: int.parse(_calorieController.text),
                  date: DateTime.now(),
                ));
                _foodNameController.clear();
                _calorieController.clear();
                Navigator.pop(context);
                setState(() {});
              }
            },
            child: const Text("Simpan"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int consumed = _calculateConsumed();
    int target = _userSettings.dailyTarget; // Ambil dari database
    String userName = _userSettings.userName ?? "User";
    
    // Hitung persen (maksimal 1.0 biar gak error grafik)
    double percentage = (target > 0) ? (consumed / target).clamp(0.0, 1.0) : 0.0;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80, // Agak tinggi biar muat sapaan
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Halo, $userName! 👋", 
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)
            ),
            Text(
              "Target: $target kkal", 
              style: TextStyle(fontSize: 14, color: Colors.grey[600])
            ),
          ],
        ),
        actions: [
          // TOMBOL PENGATURAN TARGET
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              icon: const Icon(Icons.settings),
              tooltip: "Ubah Target",
              onPressed: _showEditTargetDialog, // Panggil fungsi edit
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addFood,
        label: const Text("Catat Makan"),
        icon: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          
          // Grafik Lingkaran
          CircularPercentIndicator(
            radius: 85.0,
            lineWidth: 15.0,
            animation: true,
            percent: percentage,
            center: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "${(percentage * 100).toInt()}%",
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
                Text(consumed > target ? "Overlimit!" : "Terisi", style: const TextStyle(fontSize: 12)),
              ],
            ),
            progressColor: consumed > target ? Colors.red : const Color(0xFF10B981),
            backgroundColor: Colors.grey.shade200,
            circularStrokeCap: CircularStrokeCap.round,
            footer: Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: consumed > target ? Colors.red[50] : Colors.green[50],
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: consumed > target ? Colors.red : Colors.green)
                ),
                child: Text(
                  consumed > target 
                    ? "⚠️ Kelebihan ${consumed - target} kkal" 
                    : "Sisa jatah: ${target - consumed} kkal",
                  style: TextStyle(
                    fontWeight: FontWeight.bold, 
                    color: consumed > target ? Colors.red : Colors.green[800]
                  ),
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 30),
          
          // List Makanan
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -5))]
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 25, bottom: 10),
                    child: Text("Riwayat Makan Hari Ini", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                  Expanded(
                    child: ValueListenableBuilder(
                      valueListenable: foodBox.listenable(),
                      builder: (context, Box<FoodItem> box, _) {
                        final today = DateTime.now();
                        // Filter makanan hari ini & urutkan dari yang terbaru
                        var foods = box.values.toList().where((item) =>
                            item.date.year == today.year &&
                            item.date.month == today.month &&
                            item.date.day == today.day).toList();
                        
                        if (foods.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.no_food, size: 50, color: Colors.grey[300]),
                                const SizedBox(height: 10),
                                const Text("Belum ada asupan.", style: TextStyle(color: Colors.grey)),
                              ],
                            ),
                          );
                        }

                        return ListView.builder(
                          itemCount: foods.length,
                          itemBuilder: (context, index) {
                            // Ambil dari belakang (reversed index)
                            final food = foods[foods.length - 1 - index];
                            return Card(
                              elevation: 0,
                              color: Colors.grey[50],
                              margin: const EdgeInsets.only(bottom: 10),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.orange[100],
                                  child: const Icon(Icons.fastfood, color: Colors.orange),
                                ),
                                title: Text(food.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                                subtitle: Text("Jam: ${food.date.hour}:${food.date.minute.toString().padLeft(2, '0')}"),
                                trailing: Text(
                                  "${food.calories} kkal", 
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
                                ),
                                onLongPress: () {
                                  // Hapus item
                                  food.delete();
                                },
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}