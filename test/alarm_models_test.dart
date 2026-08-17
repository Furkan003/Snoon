import 'package:flutter_test/flutter_test.dart';
import 'package:snoon/models/alarm_models.dart';
import 'package:timezone/data/latest.dart' as timezone_data;

void main() {
  timezone_data.initializeTimeZones();

  group('AlarmItem.nextOccurrence', () {
    test('aralık alarmında sıradaki dakikayı bulur', () {
      final alarm = AlarmItem(
        id: 'range',
        hour: 7,
        minute: 0,
        label: 'Sabah',
        repeatDays: const [1, 2, 3, 4, 5, 6, 7],
        rangeEndMinutes: 7 * 60 + 30,
        intervalMinutes: 5,
      );

      final next = alarm.nextOccurrence(from: DateTime(2026, 8, 16, 7, 12));

      expect(next, DateTime(2026, 8, 16, 7, 15));
    });

    test('grup istisna tarihini atlar', () {
      final alarm = AlarmItem(
        id: 'weekday',
        hour: 7,
        minute: 0,
        label: 'İş',
        repeatDays: const [1, 2, 3, 4, 5, 6, 7],
      );
      const group = AlarmGroup(
        id: 'work',
        name: 'İş',
        colorValue: 0xFF8B5CF6,
        excludedDates: ['2026-08-17'],
      );

      final next = alarm.nextOccurrence(
        from: DateTime(2026, 8, 16, 8),
        group: group,
      );

      expect(next, DateTime(2026, 8, 18, 7));
    });

    test('bugünlük alarm ve grup kaydırmalarını birlikte uygular', () {
      final alarm = AlarmItem(
        id: 'shifted',
        hour: 7,
        minute: 0,
        label: 'Kaydırılan',
        repeatDays: const [1, 2, 3, 4, 5, 6, 7],
        todayShiftDate: '2026-08-16',
        todayShiftMinutes: 15,
      );
      const group = AlarmGroup(
        id: 'work',
        name: 'İş',
        colorValue: 0xFF8B5CF6,
        todayShiftDate: '2026-08-16',
        todayShiftMinutes: 30,
      );

      final next = alarm.nextOccurrence(
        from: DateTime(2026, 8, 16, 6),
        group: group,
      );

      expect(next, DateTime(2026, 8, 16, 7, 45));
    });

    test('tatil sonuna kadar alarm üretmez', () {
      final alarm = AlarmItem(
        id: 'paused',
        hour: 7,
        minute: 0,
        label: 'Tatil',
        repeatDays: const [1, 2, 3, 4, 5, 6, 7],
        pausedUntil: DateTime(2026, 8, 20),
      );

      final next = alarm.nextOccurrence(from: DateTime(2026, 8, 16, 6));

      expect(next, DateTime(2026, 8, 21, 7));
    });

    test('geçmiş tek seferlik alarm yeniden planlanmaz', () {
      final alarm = AlarmItem(
        id: 'once',
        hour: 7,
        minute: 0,
        label: 'Tek sefer',
        oneShotDate: DateTime(2026, 8, 16),
      );

      final next = alarm.nextOccurrence(from: DateTime(2026, 8, 16, 8));

      expect(next, isNull);
    });

    test('bozuk sıfır aralık değeri sonsuz döngüye girmez', () {
      final alarm = AlarmItem(
        id: 'safe-range',
        hour: 7,
        minute: 0,
        label: 'Güvenli aralık',
        repeatDays: const [1, 2, 3, 4, 5, 6, 7],
        rangeEndMinutes: 7 * 60 + 5,
        intervalMinutes: 0,
      );

      final next = alarm.nextOccurrence(from: DateTime(2026, 8, 16, 7, 2));

      expect(next, DateTime(2026, 8, 16, 7, 3));
    });

    test('kapalı alarm için tarih üretmez', () {
      const alarm = AlarmItem(
        id: 'disabled',
        hour: 7,
        minute: 0,
        label: 'Kapalı',
        enabled: false,
        repeatDays: [1, 2, 3, 4, 5, 6, 7],
      );

      expect(alarm.nextOccurrence(from: DateTime(2026, 8, 16, 6)), isNull);
    });

    test('birden fazla tekrar gününden doğru sıradakini seçer', () {
      const alarm = AlarmItem(
        id: 'multi-day',
        hour: 7,
        minute: 30,
        label: 'Pazartesi Çarşamba Cuma',
        repeatDays: [1, 3, 5],
      );

      expect(
        alarm.nextOccurrence(from: DateTime(2026, 8, 17, 8)),
        DateTime(2026, 8, 19, 7, 30),
      );
      expect(
        alarm.nextOccurrence(from: DateTime(2026, 8, 19, 6)),
        DateTime(2026, 8, 19, 7, 30),
      );
      expect(
        alarm.nextOccurrence(from: DateTime(2026, 8, 21, 8)),
        DateTime(2026, 8, 24, 7, 30),
      );
    });

    test('tek seferlik gelecek tarih yalnızca bir kez planlanır', () {
      final alarm = AlarmItem(
        id: 'future-once',
        hour: 9,
        minute: 15,
        label: 'Randevu',
        oneShotDate: DateTime(2026, 9, 2),
      );

      expect(
        alarm.nextOccurrence(from: DateTime(2026, 8, 16)),
        DateTime(2026, 9, 2, 9, 15),
      );
      expect(alarm.nextOccurrence(from: DateTime(2026, 9, 2, 9, 16)), isNull);
    });

    test('aralık alarmı bitiş saatini dahil eder', () {
      const alarm = AlarmItem(
        id: 'inclusive-range',
        hour: 7,
        minute: 0,
        label: 'Aralık',
        repeatDays: [1, 2, 3, 4, 5, 6, 7],
        rangeEndMinutes: 7 * 60 + 30,
        intervalMinutes: 5,
      );

      expect(
        alarm.nextOccurrence(from: DateTime(2026, 8, 16, 7, 29)),
        DateTime(2026, 8, 16, 7, 30),
      );
      expect(
        alarm.nextOccurrence(from: DateTime(2026, 8, 16, 7, 30)),
        DateTime(2026, 8, 17, 7),
      );
    });

    test('gece yarısını geçen aralık ertesi güne devam eder', () {
      const alarm = AlarmItem(
        id: 'overnight',
        hour: 23,
        minute: 55,
        label: 'Gece aralığı',
        repeatDays: [1],
        rangeEndMinutes: 24 * 60 + 5,
        intervalMinutes: 5,
      );

      final next = alarm.nextOccurrence(from: DateTime(2026, 8, 17, 23, 56));

      expect(next, DateTime(2026, 8, 18, 0, 0));
      expect(alarm.isRange, isTrue);
    });

    test('gece yarısından sonra önceki günün aralığını sürdürür', () {
      const alarm = AlarmItem(
        id: 'overnight-continuation',
        hour: 23,
        minute: 55,
        label: 'Gece aralığı',
        repeatDays: [1],
        rangeEndMinutes: 24 * 60 + 15,
        intervalMinutes: 5,
      );

      final next = alarm.nextOccurrence(from: DateTime(2026, 8, 18, 0, 1));

      expect(next, DateTime(2026, 8, 18, 0, 5));
    });

    test('alarm ve grup tatilleri içinden en uzun olanı uygular', () {
      final alarm = AlarmItem(
        id: 'double-pause',
        hour: 7,
        minute: 0,
        label: 'Tatil',
        repeatDays: const [1, 2, 3, 4, 5, 6, 7],
        pausedUntil: DateTime(2026, 8, 20),
      );
      final group = AlarmGroup(
        id: 'work',
        name: 'İş',
        colorValue: 0xFF8B5CF6,
        pausedUntil: DateTime(2026, 8, 25),
      );

      expect(
        alarm.nextOccurrence(from: DateTime(2026, 8, 16, 6), group: group),
        DateTime(2026, 8, 26, 7),
      );
    });

    test('JSON dönüşümü gelişmiş alarm alanlarını korur', () {
      final original = AlarmItem(
        id: 'roundtrip',
        hour: 6,
        minute: 45,
        label: 'Detaylı',
        repeatDays: const [1, 3, 5],
        groupId: 'work',
        rangeEndMinutes: 430,
        intervalMinutes: 2,
        vibrate: false,
        deleteAfterRinging: true,
        ringtoneUri: 'content://alarm/1',
        ringtoneName: 'Zil',
        dismissTask: DismissTask.math,
        pausedUntil: DateTime(2026, 8, 20),
        todayShiftDate: '2026-08-16',
        todayShiftMinutes: 15,
        createdAt: DateTime(2026, 8, 1),
      );

      final restored = AlarmItem.fromJson(original.toJson());

      expect(restored.toJson(), original.toJson());
    });
  });

  group('WorldCity', () {
    test('Londra yaz ve kış saati farkını otomatik uygular', () {
      const london = WorldCity(
        name: 'Londra',
        offsetMinutes: 0,
        timeZoneId: 'Europe/London',
      );

      expect(london.offsetAt(DateTime.utc(2026, 1, 15)), 0);
      expect(london.offsetAt(DateTime.utc(2026, 7, 15)), 60);
    });

    test('New York yaz ve kış saati farkını otomatik uygular', () {
      const newYork = WorldCity(
        name: 'New York',
        offsetMinutes: -300,
        timeZoneId: 'America/New_York',
      );

      expect(newYork.offsetAt(DateTime.utc(2026, 1, 15)), -300);
      expect(newYork.offsetAt(DateTime.utc(2026, 7, 15)), -240);
    });
  });
}
