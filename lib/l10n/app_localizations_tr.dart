// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appName => 'Snoon';

  @override
  String get languageTitle => 'Dilini seç';

  @override
  String get languageSubtitle =>
      'Bunu daha sonra Ayarlar\'dan değiştirebilirsin.';

  @override
  String get languageContinue => 'Devam et';

  @override
  String get languageRecommended => 'Cihaz dili';

  @override
  String get languageSetting => 'Uygulama dili';

  @override
  String get languageSettingSubtitle =>
      'Snoon\'un görünüm ve alarm dilini değiştir';

  @override
  String get languageChanged => 'Dil değiştirildi';

  @override
  String get turkish => 'Türkçe';

  @override
  String get english => 'İngilizce';

  @override
  String get german => 'Almanca';

  @override
  String get spanish => 'İspanyolca';

  @override
  String get french => 'Fransızca';

  @override
  String get italian => 'İtalyanca';

  @override
  String get portuguese => 'Portekizce';

  @override
  String get alarm => 'Alarm';

  @override
  String get world => 'Dünya';

  @override
  String get stopwatch => 'Kronometre';

  @override
  String get timer => 'Zamanlayıcı';

  @override
  String get sleep => 'Uyku';

  @override
  String get settings => 'Ayarlar';

  @override
  String get general => 'Genel';

  @override
  String get backup => 'Yedekleme';

  @override
  String get sounds => 'Sesler';

  @override
  String get extraAlarmSettings => 'Ek alarm ayarları';

  @override
  String get off => 'Kapalı';

  @override
  String get ringtonePickerFailed => 'Zil sesi seçici açılamadı.';

  @override
  String get backupSaveFailed => 'Yedek dosyası kaydedilemedi.';

  @override
  String get backupReadFailed => 'Yedek dosyası okunamadı.';

  @override
  String get cancel => 'Vazgeç';

  @override
  String get save => 'Kaydet';

  @override
  String get delete => 'Sil';

  @override
  String get apply => 'Uygula';

  @override
  String get clear => 'Temizle';

  @override
  String get later => 'Daha sonra';

  @override
  String get openSetting => 'Ayarı aç';

  @override
  String get exactAlarmPermission => 'Kesin alarm izni';

  @override
  String get exactAlarmPermissionMessage =>
      'Snoon\'un alarmı tam ayarladığın anda çalabilmesi için Android\'de ‘Alarmlar ve hatırlatıcılar’ izni gerekli.';

  @override
  String get fullScreenPermission => 'Tam ekran alarm izni';

  @override
  String get fullScreenPermissionMessage =>
      'Alarm çalarken kilit ekranında yönetim ekranını gösterebilmek için tam ekran bildirim iznini açmalısın.';

  @override
  String get alarmGroups => 'Alarm grupları';

  @override
  String get groupsIntro =>
      'Bir grubu tatil boyunca duraklatabilir, özel tarihleri atlayabilir veya bugünkü tüm saatlerini birlikte kaydırabilirsin.';

  @override
  String get addGroup => 'Grup ekle';

  @override
  String get newGroup => 'Yeni grup';

  @override
  String get editGroup => 'Grubu düzenle';

  @override
  String get groupName => 'Grup adı';

  @override
  String get groupNameRequired => 'Grup adı yazmalısın.';

  @override
  String pausedUntil(String date) {
    return '$date tarihine kadar duraklatıldı';
  }

  @override
  String exceptionDays(int count) {
    return '$count istisna günü';
  }

  @override
  String get vacationMode => 'Tatil modu';

  @override
  String get notSet => 'Ayarlanmadı';

  @override
  String get exceptionCalendar => 'İstisna takvimi';

  @override
  String get exceptionCalendarSubtitle =>
      'Bu tarihlerde gruptaki hiçbir alarm çalmaz.';

  @override
  String get noExceptionDates => 'Henüz istisna tarihi yok.';

  @override
  String get addDate => 'Tarih ekle';

  @override
  String get bulkShiftToday => 'Bugünlük toplu saat kaydırma';

  @override
  String get todayGroupTimes => 'Bugünkü grup saatleri';

  @override
  String get scheduleUnchanged => 'Kalıcı alarm düzeni değişmez';

  @override
  String get noChange => 'Değiştirme';

  @override
  String get deleteGroup => 'Grubu sil';

  @override
  String get alarmHistory => 'Alarm geçmişi';

  @override
  String get historyEmptySubtitle =>
      'Çalan, ertelenen, kapatılan ve otomatik susturulan alarmlar burada görünür.';

  @override
  String get actionRang => 'Çaldı';

  @override
  String get actionSnoozed => 'Ertelendi';

  @override
  String get actionSnoozeCancelled => 'Erteleme iptal edildi';

  @override
  String get actionDismissed => 'Kapatıldı';

  @override
  String get actionAutoSilenced => 'Otomatik susturuldu';

  @override
  String get reliabilityCenter => 'Güvenilirlik merkezi';

  @override
  String get createFirstAlarm => 'İlk alarmını oluştur';

  @override
  String get createFirstAlarmSubtitle =>
      'Tek bir alarm veya zaman aralığı için + düğmesini kullan.';

  @override
  String get noActiveAlarm => 'Etkin alarm yok';

  @override
  String get newAlarm => 'Yeni alarm';

  @override
  String get editAlarm => 'Alarmı düzenle';

  @override
  String get specificTimeRange => 'Belirli zaman aralığı';

  @override
  String get specificTimeRangeSubtitle =>
      'İki saat arasında otomatik olarak birden fazla alarm oluştur';

  @override
  String get rangeNextDay => 'Bitiş saati ertesi gün olarak uygulanır.';

  @override
  String get repeat => 'Tekrar';

  @override
  String get alarmInformation => 'Alarm bilgileri';

  @override
  String get beforeDismiss => 'Kapatmadan önce';

  @override
  String get morningRoutine => 'Sabah rutini';

  @override
  String get rangeMorningUnavailable =>
      'Aralık alarmında yedek alarmlar çakışacağı için kullanılamaz';

  @override
  String get disabledByDefault => 'Varsayılan olarak kapalıdır';

  @override
  String get endTime => 'Bitiş saati';

  @override
  String get ringInterval => 'Çalma aralığı';

  @override
  String get label => 'Etiket';

  @override
  String get labelHint => 'Örn. İşe hazırlan';

  @override
  String get alarmGroup => 'Alarm grubu';

  @override
  String get noGroup => 'Grupsuz';

  @override
  String get ringtone => 'Zil sesi';

  @override
  String get vibrateWhenRinging => 'Alarm çaldığında titret';

  @override
  String get deleteAfterRinging => 'Çaldıktan sonra sil';

  @override
  String get oneTimeAlarmOnly => 'Tek seferlik alarm için kullanılır';

  @override
  String get dismissTask => 'Alarmı kapatma görevi';

  @override
  String get noTask => 'Görev yok';

  @override
  String get mathTask => 'Matematik işlemi';

  @override
  String get shakeTask => 'Telefonu 5 kez salla';

  @override
  String get useMorningRoutine => 'Sabah rutinini kullan';

  @override
  String get gentlePreAlert => 'Yumuşak ön uyarı';

  @override
  String get backupAlarm => 'Yedek alarm';

  @override
  String get backupAlarmSubtitle => 'İlk alarm kapatılmazsa tekrar çalar';

  @override
  String get appearance => 'Görünüm';

  @override
  String get systemTheme => 'Sistem temasını kullan';

  @override
  String get darkTheme => 'Koyu tema';

  @override
  String get lightTheme => 'Açık tema';

  @override
  String get changeSystemTime => 'Sistem saatini değiştir';

  @override
  String get changeSystemTimeSubtitle =>
      'Android tarih ve saat ayarlarını açar';

  @override
  String get reliabilityCenterSubtitle =>
      'İzinleri, alarm sesini ve pil kısıtlamalarını kontrol et';

  @override
  String get exportBackup => 'Yedeği dışa aktar';

  @override
  String get exportBackupSubtitle =>
      'Alarmları ve ayarları JSON dosyası olarak kaydet';

  @override
  String get restoreBackup => 'Yedekten geri yükle';

  @override
  String get restoreBackupSubtitle => 'Bir Snoon JSON yedeği seç';

  @override
  String get restoreBackupQuestion => 'Yedeği geri yükle?';

  @override
  String get restoreBackupWarning =>
      'Mevcut alarmlar ve ayarlar seçilen dosyanın içeriğiyle değiştirilecek.';

  @override
  String get chooseFile => 'Dosya seç';

  @override
  String get backupSaved => 'Snoon yedeği kaydedildi.';

  @override
  String get backupRestored => 'Snoon yedeği geri yüklendi.';

  @override
  String get backupCancelled => 'Yedek işlemi iptal edildi.';

  @override
  String get alarmRingtone => 'Alarm zil sesi';

  @override
  String get timerRingtone => 'Zamanlayıcı zil sesi';

  @override
  String get alarmVolume => 'Zil sesi düzeyi';

  @override
  String get autoSilence => 'Otomatik susturma';

  @override
  String get increasingVolume => 'Artan alarm sesi';

  @override
  String get increasingVolumeSubtitle => 'Ses ilk 30 saniyede yavaşça yükselir';

  @override
  String get snooze => 'Ertele';

  @override
  String get maximumSnoozes => 'Azami erteleme sayısı';

  @override
  String get volumeButtons => 'Ses tuşları';

  @override
  String get volumeChange => 'Ses düzeyini değiştir';

  @override
  String get snoozeAlarm => 'Alarmı ertele';

  @override
  String get dismissAlarm => 'Alarmı kapat';

  @override
  String get notifyBeforeRinging => 'Çalmadan önce bildirim';

  @override
  String get showOnLockScreen => 'Alarmları kilit ekranında göster';

  @override
  String minutesShort(int count) {
    return '$count dk';
  }

  @override
  String minutesBefore(int count) {
    return '$count dk önce';
  }

  @override
  String minutesAfter(int count) {
    return '$count dk sonra';
  }

  @override
  String timesCount(int count) {
    return '$count kez';
  }

  @override
  String maximumTimes(int count) {
    return 'En fazla $count kez';
  }

  @override
  String alarmsCount(int count) {
    return '$count alarm';
  }

  @override
  String selectedCount(int count) {
    return '$count seçildi';
  }

  @override
  String get alarmsDeleteQuestion => 'Alarmları sil?';

  @override
  String alarmsDeleteMessage(int count) {
    return '$count alarm kalıcı olarak silinecek.';
  }

  @override
  String get pauseUntilDate => 'Tarihe kadar duraklat';

  @override
  String get shiftToday => 'Bugünlük kaydır';

  @override
  String get pauseDateHelp => 'ALARMLAR NE ZAMANA KADAR DURAKLATILSIN?';

  @override
  String pauseSuccess(int count, String date) {
    return '$count alarm $date tarihine kadar duraklatıldı.';
  }

  @override
  String get shiftTodayTitle => 'Bugünkü alarmları kaydır';

  @override
  String get shiftTodaySubtitle =>
      'Düzenli program değişmez; yalnızca bugünkü çalma saatleri etkilenir.';

  @override
  String shiftSuccess(int count, int minutes, String direction) {
    return '$count alarm bugün $minutes dakika $direction alındı.';
  }

  @override
  String get forward => 'ileri';

  @override
  String get backward => 'geri';

  @override
  String get nextAlarm => 'Sıradaki alarm';

  @override
  String get once => 'Bir kez';

  @override
  String get everyDay => 'Her gün';

  @override
  String get weekdays => 'Hafta içi';

  @override
  String get weekend => 'Hafta sonu';

  @override
  String intervalEvery(int count) {
    return '$count dk aralık';
  }

  @override
  String get paused => 'Duraklatıldı';

  @override
  String todayOffset(int count) {
    return '$count dk bugün';
  }

  @override
  String get noHistory => 'Henüz alarm geçmişi yok';

  @override
  String get clearHistory => 'Geçmişi temizle';

  @override
  String get worldClock => 'Dünya Saati';

  @override
  String get searchCity => 'Şehir ara';

  @override
  String get cityNotFound => 'Şehir bulunamadı';

  @override
  String get customTimer => 'Özel zamanlayıcı';

  @override
  String get hours => 'Saat';

  @override
  String get minutes => 'Dakika';

  @override
  String get seconds => 'Saniye';

  @override
  String hourShort(int count) {
    return '$count sa';
  }

  @override
  String get invalidDuration => 'Geçerli bir süre yazmalısın.';

  @override
  String get custom => 'Özel';

  @override
  String get start => 'Başlat';

  @override
  String get pause => 'Duraklat';

  @override
  String get reset => 'Sıfırla';

  @override
  String get lap => 'Tur';

  @override
  String lapNumber(int count) {
    return 'Tur $count';
  }

  @override
  String get sleepSchedule => 'Uyku programı';

  @override
  String get plannedSleepDuration => 'Planlanan uyku süresi';

  @override
  String get sleepReminderAndWakeAlarm =>
      'Yatma hatırlatıcısı ve uyanma alarmı';

  @override
  String get scheduleDays => 'Program günleri';

  @override
  String get atLeastOneSleepDay =>
      'Uyku programı için en az bir gün seçili kalmalı.';

  @override
  String get sleepScheduleSubtitle =>
      'Yatmadan önce hatırlatma al ve uyanma saatini düzenli tut';

  @override
  String get bedtime => 'Yatma zamanı';

  @override
  String get wakeTime => 'Uyanma zamanı';

  @override
  String get windDownTime => 'Rahatlama süresi';

  @override
  String get windDownSubtitle => 'Yatma zamanından önce bildirim gönderilir';

  @override
  String get addCity => 'Şehir ekle';

  @override
  String get tryDifferentCity => 'Farklı bir şehir adı deneyebilirsin.';

  @override
  String get localTime => 'Yerel saat';

  @override
  String localTimeDifference(int hours, int minutes, String direction) {
    return 'Yerel saatten $hours sa $minutes dk $direction';
  }

  @override
  String get testAlarm => 'Test alarmı';

  @override
  String get testAlarmType => 'Test alarmı türü';

  @override
  String get dismissDirectly => 'Alarmı doğrudan kapat';

  @override
  String get verifyDismissTask => 'Kapatma görevini de doğrula';

  @override
  String get alarmsReady => 'Alarmlar hazır';

  @override
  String get checkPermissions => 'İzinleri kontrol et';

  @override
  String get alarmsReadySubtitle => 'Kesin alarm ve bildirim izinleri açık.';

  @override
  String get permissionsWarningSubtitle =>
      'Eksik izinler alarmın geç veya sessiz çalmasına neden olabilir.';

  @override
  String get exactAlarmCheckSubtitle =>
      'Alarmın tam ayarladığın saniyede çalışmasını sağlar.';

  @override
  String get grantPermission => 'İzin ver';

  @override
  String manufacturerSettingsSubtitle(String manufacturer) {
    return '$manufacturer cihazında Snoon için otomatik başlatma, arka plan ve pil kullanımını ‘Kısıtlanmamış’ yap.';
  }

  @override
  String get appSettings => 'Uygulama ayarları';

  @override
  String get notificationCheckSubtitle =>
      'Ön bildirim ve kilit ekranı alarmı için gereklidir.';

  @override
  String get fullScreenCheckSubtitle =>
      'Alarm yönetimini kilit ekranında ve diğer uygulamaların üzerinde gösterir.';

  @override
  String get alarmSoundLevel => 'Alarm ses düzeyi';

  @override
  String get alarmSoundAudible =>
      'Android alarm ses kanalı duyulabilir durumda.';

  @override
  String get alarmSoundMuted =>
      'Sistem alarm sesi kapalı. Snoon çalarken ayarlanan düzeye yükseltecek.';

  @override
  String get soundSettings => 'Ses ayarları';

  @override
  String get batteryUnrestricted =>
      'Uygulama pil kısıtlamalarından etkilenmiyor.';

  @override
  String get batteryMayDelay =>
      'Bazı telefonlar arka plandaki alarmı geciktirebilir.';

  @override
  String get openSettings => 'Ayarları aç';

  @override
  String get runTenSecondTest => '10 saniyelik test alarmı çalıştır';

  @override
  String get refreshChecks => 'Kontrolleri yenile';

  @override
  String get notificationPermission => 'Bildirim izni';

  @override
  String get batteryOptimization => 'Pil optimizasyonu';

  @override
  String get manufacturerBackgroundSettings => 'Üretici arka plan ayarları';

  @override
  String testScheduled(String task) {
    return 'Test alarmı 10 saniye sonra çalacak • $task';
  }

  @override
  String get sameStartEndError => 'Başlangıç ve bitiş saati aynı olamaz.';
}
