# Snoon — Ürün Gereksinimleri

Son güncelleme: 16 Ağustos 2026

## Ürün amacı

Klasik Android saat uygulamalarının tanıdık görünümünü korurken, çok sayıda tekrarlanan alarmı tek tek yönetme zorunluluğunu ortadan kaldıran, Android odaklı bir Flutter uygulaması.

## Ana bölümler

1. Alarm
2. Dünya Saati
3. Kronometre
4. Zamanlayıcı
5. Uyku programı
6. Ayarlar

## Temel alarm gereksinimleri

- Alarm oluşturma, düzenleme, etkinleştirme ve silme
- Etiket
- Haftanın günlerine göre tekrar
- Alarm zil sesi seçimi
- Titreşim
- Alarm çaldıktan sonra silme
- Artan alarm sesi
- Otomatik susturma
- Erteleme süresi ve azami erteleme sayısı
- Ses tuşlarının davranışı
- Alarmdan önce bildirim
- Alarmı kilit ekranında gösterme

## Ayarlar

- Android sistem tarih-saat ayarlarını açma
- Varsayılan alarm zil sesi
- Varsayılan zamanlayıcı zil sesi
- Uygulama alarm ses düzeyi
- Otomatik susturma süresi
- Varsayılan titreşim
- Artan alarm sesi
- Erteleme ayarları
- Ses tuşu davranışı
- Ön bildirim süresi
- Kilit ekranı görünümü

## Ayırt edici özellikler

### Aralık alarmı

Kullanıcı başlangıç ve bitiş saati ile 1/2/5/10/15 dakikalık aralık seçer. Örnek: 07.00–07.30 arasında her 5 dakikada bir. Bu düzen tek kayıt olarak gösterilir ve yönetilir.

### Alarm grupları

Alarmlar İş, Kişisel, Okul veya kullanıcı tarafından oluşturulan başka bir grup altında toplanabilir. Grup ayarları tüm üye alarmları etkiler.

### Tatil ve istisna takvimi

- Seçilen alarmlar veya bir grup belirli tarihe kadar silinmeden duraklatılabilir.
- Bir gruba alarm çalmayacak özel tarihler eklenebilir.
- Süre dolduğunda alarmlar otomatik olarak normal tekrar düzenine döner.

### Bugünlük toplu saat kaydırma

Seçilen alarmlar veya bir grubun bugünkü alarmları -60/-30/-15/+15/+30/+60 dakika kaydırılabilir. Kalıcı saat ve tekrar düzeni değişmez.

### Sabah rutini

- Alarm başına isteğe bağlıdır.
- Varsayılan olarak kapalıdır.
- Yumuşak ön uyarı süresi ayarlanabilir.
- Ana alarm kapatılmazsa yedek alarm çalışır.

### Alarmı kapatma görevleri

- Alarm oluşturma/düzenleme ekranında seçilir.
- Varsayılan olarak kapalıdır.
- Seçenekler: görev yok, matematik işlemi, telefonu 5 kez sallama.
- Görev tamamlanmadan alarm kapatılamaz.

### Güvenilirlik merkezi

- Kesin alarm iznini kontrol eder ve ilgili ayarı açar.
- Bildirim iznini kontrol eder ve ister.
- Pil optimizasyonu durumunu gösterir.
- 10 saniyelik gerçek test alarmı sağlar.

### Alarm geçmişi

Çaldı, ertelendi, kapatıldı ve otomatik susturuldu olaylarını tarih/saat ile cihazda yerel olarak saklar.

## Android davranışı

- Kesin alarm için `AlarmManager.setAlarmClock()` kullanılır.
- Alarmlar uygulama kapalıyken ve cihaz uykudayken tetiklenebilir.
- Telefon yeniden başlatıldığında veya saat/saat dilimi değiştiğinde kayıtlar yeniden planlanır.
- Alarm sesi alarm ses akışında döngüsel çalar.
- Alarm ekranı kilit ekranının üzerinde gösterilir ve ekranı uyandırır.
- Kullanıcı seçimine göre ses tuşları sesi değiştirir, erteler veya alarmı kapatır.

## Varsayılanlar

- Sabah rutini: Kapalı
- Alarmı kapatma görevi: Yok
- Titreşim: Açık
- Artan ses: Açık
- Erteleme: 5 dakika, en fazla 3 kez
- Otomatik susturma: 10 dakika
- Ön bildirim: 10 dakika
- Kilit ekranında göster: Açık

## Veri ve gizlilik

- Alarm, grup, ayar, şehir ve geçmiş verileri cihazda yerel tutulur.
- Hesap, sunucu veya internet bağlantısı gerekmez.
