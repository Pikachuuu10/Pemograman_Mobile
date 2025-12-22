import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:validasi_form_registrasi/main.dart';

void main() {
  testWidgets('Menampilkan judul form registrasi', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());

    // Pastikan judul muncul
    expect(find.text('Form Registrasi'), findsOneWidget);
    
    // Pastikan field input muncul
    expect(find.text('Nama Lengkap'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
    
    // Pastikan tombol DAFTAR muncul
    expect(find.text('DAFTAR'), findsOneWidget);
  });
}