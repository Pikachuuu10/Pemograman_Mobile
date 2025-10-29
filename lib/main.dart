import 'package:flutter/material.dart';
import 'detail_page.dart';

void main() {
  runApp(const ProfilDosenApp());
}

class ProfilDosenApp extends StatelessWidget {
  const ProfilDosenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profil Dosen App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 0, 0, 0),
        ),
        useMaterial3: true,
      ),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  final List<Map<String, String>> dosenList = const [
    {
      "nama": "Rizky Santoso, M.T.",
      "jabatan": "Dosen Kecerdasan Buatan",
      "foto":
          "https://images.pexels.com/photos/2379005/pexels-photo-2379005.jpeg",
      "email": "RizkySantoso@kampus.ac.id",
      "telepon": "082135674980",
      "bio":
          "Dosen yang berfokus pada penelitian machine learning dan pengembangan sistem berbasis AI untuk industri modern.",
    },
    {
      "nama": "Anita Muliawati, S.Kom., MTI.",
      "jabatan": "Dosen Keamanan Jaringan",
      "foto":
          "https://images.pexels.com/photos/1239291/pexels-photo-1239291.jpeg",
      "email": "Anita@kampus.ac.id",
      "telepon": "081234567812",
      "bio":
          "Spesialis dalam bidang jaringan komputer, meneliti keamanan jaringan, kriptografi, dan sistem pertahanan siber.",
    },
    {
      "nama": "Ferdian Ramadhan, M.Kom.",
      "jabatan": "Dosen Basis Data dan Pemrograman",
      "foto":
          "https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg",
      "email": "Ferdian@kampus.ac.id",
      "telepon": "087777123456",
      "bio":
          "Berpengalaman dalam pengembangan aplikasi berbasis data, optimasi query SQL, dan integrasi sistem informasi.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("Daftar Dosen"),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 139, 194, 127),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView.builder(
          itemCount: dosenList.length,
          itemBuilder: (context, index) {
            final dosen = dosenList[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailPage(dosen: dosen),
                  ),
                );
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        bottomLeft: Radius.circular(16),
                      ),
                      child: Image.network(
                        dosen["foto"]!,
                        height: 110,
                        width: 110,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              dosen["nama"]!,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 74, 157, 22),
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              dosen["jabatan"]!,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color.fromARGB(255, 144, 223, 7),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: const [
                                Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: Color.fromARGB(255, 0, 177, 18),
                                  size: 16,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  "Lihat Profil",
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 226, 227, 233),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
