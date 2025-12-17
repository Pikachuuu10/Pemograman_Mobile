// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:form_feedback_app/main.dart';

void main() {
  testWidgets('Form Feedback App UI Test', (WidgetTester tester) async {
    // Jalankan aplikasi
    await tester.pumpWidget(FormFeedbackApp());

    // Pastikan halaman form muncul
    expect(find.text('💬 Formulir Feedback'), findsOneWidget);
    expect(find.text('Bagikan pendapatmu dengan kami'), findsOneWidget);

    // Isi nama dan komentar
    await tester.enterText(find.byType(TextField).at(0), 'Erika');
    await tester.enterText(find.byType(TextField).at(1), 'Desainnya keren banget!');
    await tester.pump();

    // Pilih rating 4 bintang
    await tester.tap(find.byIcon(Icons.star_border_rounded).at(3));
    await tester.pump();

    // Pastikan label rating berubah
    expect(find.textContaining('Bagus banget'), findsOneWidget);

    // Tekan tombol kirim
    await tester.tap(find.text('Kirim Feedback'));
    await tester.pumpAndSettle();

    // Cek halaman hasil feedback
    expect(find.text('📊 Hasil Feedback'), findsOneWidget);
    expect(find.textContaining('Terima kasih, Erika!'), findsOneWidget);
    expect(find.textContaining('Desainnya keren banget!'), findsOneWidget);
    expect(find.textContaining('Rating: 4 / 5'), findsOneWidget);

    // Kembali ke halaman utama
    await tester.tap(find.text('Kembali'));
    await tester.pumpAndSettle();

    // Pastikan halaman form muncul lagi
    expect(find.text('💬 Formulir Feedback'), findsOneWidget);

    // Tekan tombol lihat semua feedback (icon daftar di AppBar)
    await tester.tap(find.byIcon(Icons.list_alt_outlined));
    await tester.pumpAndSettle();

    // Cek apakah halaman riwayat feedback terbuka
    expect(find.text('📚 Riwayat Feedback'), findsOneWidget);
    expect(find.text('Erika'), findsOneWidget);
    expect(find.text('Desainnya keren banget!'), findsOneWidget);
    expect(find.text('⭐ 4'), findsOneWidget);
  });
}
