import 'package:flutter_test/flutter_test.dart';

import 'package:nugasmana/main.dart';

void main() {
  testWidgets('Aplikasi berhasil dijalankan dan menampilkan navigasi bawah',
      (WidgetTester tester) async {
    // Membangun aplikasi dan memicu satu frame.
    await tester.pumpWidget(const NugasManaApp());

    // Memastikan empat item navigasi bawah tampil.
    expect(find.text('Beranda'), findsWidgets);
    expect(find.text('Jelajah'), findsWidgets);
    expect(find.text('Favorit'), findsWidgets);
    expect(find.text('Profil'), findsWidgets);
  });
}