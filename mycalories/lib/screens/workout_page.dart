import 'package:flutter/material.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';

class WorkoutPage extends StatelessWidget {
  const WorkoutPage({super.key});

  final List<Map<String, dynamic>> exercises = const [
    {"name": "Push Up", "duration": 30, "icon": Icons.fitness_center},
    {"name": "Sit Up", "duration": 45, "icon": Icons.accessibility_new},
    {"name": "Plank", "duration": 60, "icon": Icons.horizontal_rule},
    {"name": "Jumping Jack", "duration": 30, "icon": Icons.directions_run},
    {"name": "Istirahat", "duration": 15, "icon": Icons.coffee},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Jadwal Olahraga")),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: exercises.length,
        itemBuilder: (context, index) {
          final ex = exercises[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 10),
            child: ListTile(
              leading: CircleAvatar(child: Icon(ex['icon'])),
              title: Text(ex['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text("Durasi: ${ex['duration']} detik"),
              trailing: const Icon(Icons.play_circle_fill, color: Colors.teal, size: 35),
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) => WorkoutTimerModal(
                    exerciseName: ex['name'],
                    duration: ex['duration'],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class WorkoutTimerModal extends StatelessWidget {
  final String exerciseName;
  final int duration;

  const WorkoutTimerModal({super.key, required this.exerciseName, required this.duration});

  @override
  Widget build(BuildContext context) {
    final CountDownController controller = CountDownController();

    return Container(
      height: 400,
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Text(exerciseName, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          CircularCountDownTimer(
            duration: duration,
            initialDuration: 0,
            controller: controller,
            width: 150,
            height: 150,
            ringColor: Colors.grey[300]!,
            fillColor: Colors.teal,
            backgroundColor: Colors.white,
            strokeWidth: 15.0,
            strokeCap: StrokeCap.round,
            textStyle: const TextStyle(fontSize: 33.0, color: Colors.teal, fontWeight: FontWeight.bold),
            textFormat: CountdownTextFormat.S,
            isReverse: true,
            isReverseAnimation: true,
            isTimerTextShown: true,
            autoStart: false,
            onComplete: () {
               ScaffoldMessenger.of(context).showSnackBar(
                 SnackBar(content: Text("$exerciseName Selesai!"))
               );
            },
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FloatingActionButton(
                onPressed: () => controller.start(),
                child: const Icon(Icons.play_arrow),
              ),
              FloatingActionButton(
                onPressed: () => controller.pause(),
                backgroundColor: Colors.orange,
                child: const Icon(Icons.pause),
              ),
              FloatingActionButton(
                onPressed: () => controller.restart(),
                backgroundColor: Colors.red,
                child: const Icon(Icons.refresh),
              ),
            ],
          )
        ],
      ),
    );
  }
}