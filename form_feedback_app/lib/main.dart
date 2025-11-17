import 'package:flutter/material.dart';

void main() {
  runApp(FormFeedbackApp());
}

class FormFeedbackApp extends StatefulWidget {
  @override
  State<FormFeedbackApp> createState() => _FormFeedbackAppState();
}

class _FormFeedbackAppState extends State<FormFeedbackApp> {
  final List<Map<String, dynamic>> feedbackList = [];

  void addFeedback(Map<String, dynamic> feedback) {
    setState(() {
      feedbackList.add(feedback);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Form Feedback App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigoAccent,
          secondary: Colors.deepPurpleAccent,
        ),
        scaffoldBackgroundColor: const Color(0xFFF3F6FF),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontFamily: 'Poppins', fontSize: 16),
        ),
        useMaterial3: true,
      ),
      home: FeedbackFormPage(
        onFeedbackSubmitted: addFeedback,
        feedbackList: feedbackList,
      ),
    );
  }
}

class FeedbackFormPage extends StatefulWidget {
  final void Function(Map<String, dynamic>) onFeedbackSubmitted;
  final List<Map<String, dynamic>> feedbackList;

  const FeedbackFormPage({
    required this.onFeedbackSubmitted,
    required this.feedbackList,
  });

  @override
  State<FeedbackFormPage> createState() => _FeedbackFormPageState();
}

class _FeedbackFormPageState extends State<FeedbackFormPage> {
  final _nameController = TextEditingController();
  final _commentController = TextEditingController();
  int _rating = 3;

  String get ratingLabel {
    switch (_rating) {
      case 5:
        return "Sempurna 🤩";
      case 4:
        return "Bagus banget 🌟";
      case 3:
        return "Cukup baik 😊";
      case 2:
        return "Perlu perbaikan 😐";
      default:
        return "Kurang memuaskan 😔";
    }
  }

  void _submitFeedback() {
    if (_nameController.text.isEmpty || _commentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Harap isi semua kolom 😌"),
          backgroundColor: Colors.indigoAccent,
        ),
      );
      return;
    }

    final feedback = {
      'name': _nameController.text,
      'comment': _commentController.text,
      'rating': _rating,
      'date': DateTime.now(),
    };

    widget.onFeedbackSubmitted(feedback);

    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => FeedbackResultPage(
          name: _nameController.text,
          comment: _commentController.text,
          rating: _rating,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final fade = CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOutCubic,
          );
          return FadeTransition(opacity: fade, child: child);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('💬 Formulir Feedback'),
        centerTitle: true,
        backgroundColor: primary,
        foregroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        actions: [
          IconButton(
            tooltip: "Lihat Semua Feedback",
            icon: const Icon(Icons.list_alt_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      FeedbackHistoryPage(feedbackList: widget.feedbackList),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 45,
              backgroundColor: Colors.indigo.withOpacity(0.15),
              child: const Text("📋", style: TextStyle(fontSize: 42)),
            ),
            const SizedBox(height: 20),
            Text(
              "Bagikan pendapatmu dengan kami",
              style: TextStyle(
                fontSize: 18,
                color: Colors.indigo[700],
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 25),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: "Nama",
                prefixIcon: Icon(Icons.person_outline, color: primary),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _commentController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: "Komentar",
                prefixIcon: Icon(Icons.chat_bubble_outline, color: primary),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 25),
            const Text(
              "Beri Rating:",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    index < _rating
                        ? Icons.star_rounded
                        : Icons.star_border_rounded,
                    color: Colors.amber,
                    size: 35,
                  ),
                  onPressed: () {
                    setState(() {
                      _rating = index + 1;
                    });
                  },
                );
              }),
            ),
            Text(
              ratingLabel,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: _submitFeedback,
              icon: const Icon(Icons.send_rounded),
              label: const Text("Kirim Feedback"),
              style: ElevatedButton.styleFrom(
                backgroundColor: primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 15,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                textStyle: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FeedbackResultPage extends StatelessWidget {
  final String name;
  final String comment;
  final int rating;

  const FeedbackResultPage({
    required this.name,
    required this.comment,
    required this.rating,
  });

  String get emojiFeedback {
    switch (rating) {
      case 5:
        return "🤩";
      case 4:
        return "🌟";
      case 3:
        return "😊";
      case 2:
        return "😐";
      default:
        return "😔";
    }
  }

  String get message {
    switch (rating) {
      case 5:
        return "Sempurna! Terima kasih atas apresiasimu ✨";
      case 4:
        return "Senang mendengar pendapat bagus darimu 🌟";
      case 3:
        return "Masukanmu sangat berarti bagi kami 😊";
      case 2:
        return "Kami akan berusaha lebih baik lagi 🙏";
      default:
        return "Terima kasih atas kejujurannya 💙";
    }
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('📊 Hasil Feedback'),
        centerTitle: true,
        backgroundColor: primary,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Card(
            elevation: 8,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            child: Padding(
              padding: const EdgeInsets.all(25),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(emojiFeedback, style: const TextStyle(fontSize: 60)),
                  const SizedBox(height: 15),
                  Text(
                    "Terima kasih, $name!",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '"$comment"',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    "Rating: $rating / 5 ⭐",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 25),
                  ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_rounded),
                    label: const Text("Kembali"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 35,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class FeedbackHistoryPage extends StatelessWidget {
  final List<Map<String, dynamic>> feedbackList;

  const FeedbackHistoryPage({required this.feedbackList});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('📚 Riwayat Feedback'),
        centerTitle: true,
        backgroundColor: primary,
        foregroundColor: Colors.white,
      ),
      body: feedbackList.isEmpty
          ? const Center(
              child: Text(
                "Belum ada feedback 😅",
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: feedbackList.length,
              itemBuilder: (context, index) {
                final item = feedbackList[index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 4,
                  child: ListTile(
                    leading: const Icon(Icons.person, color: Colors.indigo),
                    title: Text(item['name']),
                    subtitle: Text(item['comment']),
                    trailing: Text("⭐ ${item['rating']}"),
                  ),
                );
              },
            ),
    );
  }
}
