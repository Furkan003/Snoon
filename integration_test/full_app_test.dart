import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:snoon/main.dart' as app;
import 'package:snoon/screens/language_selection_page.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Snoon tam uygulama emülatör testi', (tester) async {
    await app.main();
    await tester.pumpAndSettle(const Duration(seconds: 2));
    if (find.byType(LanguageSelectionPage).evaluate().isNotEmpty) {
      await tester.tap(find.text('Türkçe'));
      await tester.scrollUntilVisible(
        find.byType(FilledButton),
        400,
        scrollable: find.byType(Scrollable).last,
      );
      await tester.tap(find.byType(FilledButton));
      await tester.pumpAndSettle(const Duration(seconds: 2));
    }
    expect(find.text('İlk alarmını oluştur'), findsOneWidget);

    // Alarm grubu oluştur.
    await tester.tap(find.byIcon(Icons.folder_outlined));
    await tester.pumpAndSettle();
    expect(find.text('Alarm grupları'), findsOneWidget);
    await tester.tap(find.text('Grup ekle'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField), 'Emülatör Grubu');
    await tester.tap(find.text('Kaydet'));
    await tester.pumpAndSettle();
    expect(find.text('Emülatör Grubu'), findsOneWidget);
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    // Birden çok gün ve zaman aralığı kullanan gerçek Android alarmı oluştur.
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Belirli zaman aralığı'));
    for (final day in ['Pzt', 'Çar', 'Cum']) {
      await tester.tap(find.text(day));
    }
    await tester.scrollUntilVisible(
      find.byType(TextFormField),
      350,
      scrollable: find.byType(Scrollable).last,
    );
    await tester.enterText(find.byType(TextFormField), 'Çok günlü aralık');
    await tester.tap(find.text('Grupsuz'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Emülatör Grubu').last);
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(TextButton, 'Kaydet'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Çok günlü aralık'), findsOneWidget);
    expect(find.textContaining('5 dk aralık'), findsOneWidget);

    // İkinci alarmda kapatma görevi ve sabah rutinini aç.
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
    for (final day in ['Sal', 'Per']) {
      await tester.tap(find.text(day));
    }
    await tester.scrollUntilVisible(
      find.byType(TextFormField),
      350,
      scrollable: find.byType(Scrollable).last,
    );
    await tester.enterText(find.byType(TextFormField), 'Görevli alarm');
    await tester.scrollUntilVisible(
      find.text('Görev yok'),
      400,
      scrollable: find.byType(Scrollable).last,
    );
    await tester.tap(find.text('Görev yok'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Matematik işlemi').last);
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Sabah rutinini kullan'),
      350,
      scrollable: find.byType(Scrollable).last,
    );
    await tester.tap(find.text('Sabah rutinini kullan'));
    await tester.tap(find.widgetWithText(TextButton, 'Kaydet'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Görevli alarm'), findsOneWidget);

    // Dünya saati ve yaz/kış saati verili şehir ekleme.
    await tester.tap(find.text('Dünya'));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('New York'),
      450,
      scrollable: find.byType(Scrollable).last,
    );
    await tester.tap(find.text('New York'));
    await tester.pumpAndSettle();
    expect(find.text('New York'), findsOneWidget);

    // Kronometre: başlat, tur, duraklat ve sıfırla.
    await tester.tap(find.text('Kronometre'));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.play_arrow));
    await tester.pump(const Duration(milliseconds: 350));
    await tester.tap(find.byIcon(Icons.flag_outlined));
    await tester.pump();
    expect(find.text('Tur 1'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.pause));
    await tester.pump();
    await tester.tap(find.byIcon(Icons.refresh));
    await tester.pump();
    expect(find.text('Tur 1'), findsNothing);

    // Zamanlayıcı: gerçek Android kuyruğuna ekle, duraklat ve sıfırla.
    await tester.tap(find.text('Zamanlayıcı'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('1 dk'));
    await tester.tap(find.byIcon(Icons.play_arrow));
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.byIcon(Icons.pause), findsOneWidget);
    await tester.tap(find.byIcon(Icons.pause));
    await tester.pump();
    await tester.tap(find.byIcon(Icons.refresh));
    await tester.pump();

    // Uyku programını aç, günleri ve üretilen uyanma alarmını doğrula.
    await tester.tap(find.text('Uyku'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Uyku programı'));
    await tester.pumpAndSettle();
    expect(find.text('Planlanan uyku süresi'), findsOneWidget);

    // Ayarlar, güvenilirlik ve geçmiş ekranlarını gerçek platform kanalında aç.
    await tester.tap(find.text('Alarm'));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.more_vert));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ayarlar'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Alarm zil sesi'),
      350,
      scrollable: find.byType(Scrollable).last,
    );
    expect(find.text('Alarm zil sesi'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Artan alarm sesi'),
      450,
      scrollable: find.byType(Scrollable).last,
    );
    await tester.tap(find.text('Artan alarm sesi'));
    await tester.pumpAndSettle();
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.more_vert));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Güvenilirlik merkezi'));
    await tester.pumpAndSettle();
    expect(find.text('Güvenilirlik merkezi'), findsOneWidget);
    expect(find.text('Kesin alarm izni'), findsOneWidget);
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.more_vert));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Alarm geçmişi'));
    await tester.pumpAndSettle();
    expect(find.text('Alarm geçmişi'), findsOneWidget);
  });
}
