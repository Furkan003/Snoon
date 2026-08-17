# Snoon Yapılacaklar Planı

Bu belge Snoon'un çoklu dil desteği, GitHub sunumu ve sonraki yayın hazırlıkları için uygulanacak yol haritasıdır. Maddeler tamamlandıkça `[x]` olarak işaretlenecektir.

## Öncelik 1 — Çoklu dil entegrasyonu

### Altyapı

- [x] Flutter yerelleştirme altyapısını kur (`flutter_localizations`, `intl`, `gen-l10n`).
- [x] Her dil için ayrı ARB çeviri dosyaları oluştur.
- [x] Kaynak kodda kullanıcıya gösterilen sabit metinleri çeviri anahtarlarına taşı.
- [x] Flutter ekranlarının yanında Kotlin tarafındaki alarm bildirimi, tam ekran alarm, erteleme, kapatma ve yeniden başlatma metinlerini de yerelleştir.
- [x] Seçilen dili cihazda kalıcı olarak sakla ve uygulama yeniden açıldığında koru.
- [x] Eksik bir çeviride İngilizce metne güvenli geri dönüş uygula.
- [x] Tarih, saat, gün adları ve sayı biçimlerini seçilen dile göre göster.

### İlk açılış dil seçimi

- [x] Uygulama ilk kez açıldığında izin ekranlarından önce sade bir dil seçim ekranı göster.
- [x] Cihaz dilini önerilen seçenek olarak en üstte göster; kullanıcı seçimini kendisi onaylasın.
- [x] Dil seçildikten sonra karşılama ve Android izin akışına geç.
- [x] Mevcut Snoon kullanıcılarına güncellemeden sonraki ilk açılışta bir defalık dil seçimi göster; alarm verilerini değiştirme.
- [x] Ayarlar ekranına daha sonra dili değiştirebilecekleri **Uygulama dili** seçeneği ekle.
- [x] Dil değişimini mümkünse uygulamayı kapatmaya gerek kalmadan bütün açık ekranlara uygula.

### İlk sürümde desteklenecek diller

- [x] Türkçe (`tr`) — ana dil ve referans metinler.
- [x] İngilizce (`en`) — varsayılan geri dönüş dili.
- [x] Almanca (`de`).
- [x] İspanyolca (`es`).
- [x] Fransızca (`fr`).
- [x] İtalyanca (`it`).
- [x] Portekizce (`pt`).

İlk aşamada soldan sağa yazılan ve Flutter/Android desteği güçlü diller seçilecektir. Arapça gibi sağdan sola diller, arayüz yönü ve görsel yerleşim ayrıca test edilerek sonraki sürüme bırakılacaktır.

### Çeviri kalite kontrolü

- [x] Alarm, erteleme, kapatma ve izin terimleri için bütün dillerde ortak bir terim sözlüğü oluştur.
- [x] Parametreli metinleri doğru çoğul kurallarıyla çevir: `1 dakika`, `5 dakika`, alarm sayısı ve kalan süre gibi.
- [ ] Uzun Almanca ve Fransızca metinlerde taşma/alt navigasyon çakışması testi yap.
- [ ] Büyük yazı boyutunda, açık/koyu temada ve 3 tuşlu Android navigasyonunda bütün dilleri test et.
- [ ] Her dil için ilk açılış, alarm oluşturma, alarm çalma, 5 dakika erteleme, zamanlayıcı ve yeniden başlatma senaryolarını çalıştır.
- [x] Çeviri anahtarlarının eksik veya kullanılmıyor olmasını otomatik testte hata say.

## Öncelik 2 — GitHub deposu ve tanıtım

### İki dilli README

- [x] Ana `README.md` dosyasını profesyonel İngilizce tanıtım olarak düzenle.
- [x] Ayrı `README_TR.md` dosyasında aynı içeriğin Türkçe sürümünü hazırla.
- [x] İki belgenin başına **English | Türkçe** geçiş bağlantıları ekle.
- [x] Snoon logosunu ve kısa ürün sloganını üst bölümde göster.
- [x] Uygulamanın hangi sorunu çözdüğünü kısa bir girişle anlat.
- [x] Standart saat özellikleri ve Snoon'a özel özellikleri ayrı başlıklarda sun.
- [x] Alarm grupları, aralıklı alarm, tatil/istisna takvimi, bugünlük kaydırma, kapatma görevleri ve güvenilirlik merkezini özellikle vurgula.
- [x] Android sürüm gereksinimleri, Flutter/JDK kurulumu, projeyi çalıştırma ve test komutlarını ekle.
- [x] Android izinlerinin neden gerektiğini sade biçimde açıkla.
- [x] Mimariyi Flutter arayüzü, yerel veri saklama ve Kotlin alarm katmanı olarak özetle.
- [x] Gizlilik, katkı sağlama, hata bildirme, yol haritası ve lisans bağlantılarını ekle.

### Görseller

- [x] Mevcut uygulama içi ekran görüntülerini README içinde düzenli bir galeri olarak kullan.
- [x] Alarm listesi, dünya saati, ayarlar/yedekleme, yönetilebilir alarm bildirimi ve matematik görevini göster.
- [ ] Çoklu dil tamamlanınca Türkçe ve İngilizce güncel ekran görüntülerini yeniden çek.
- [x] Görselleri GitHub'da hızlı açılacak boyuta sıkıştır; okunabilirliği koru.
- [ ] İsteğe bağlı olarak alarm oluşturma → çalma → erteleme akışını gösteren kısa GIF veya video hazırla.
- [ ] Play Store ekran görüntüleriyle GitHub görsellerini ayrı klasörlerde düzenle.

### Depo düzeni ve güvenlik

- [x] Kaynak kodu göndermeden önce paket adı, klasör adları ve eski `saat2` kalıntılarını temizle. (Yalnızca eski kullanıcı verisini koruyan belgelenmiş depolama anahtarları tutuldu.)
- [x] `.gitignore` dosyasını doğrula; `key.properties`, JKS/keystore, yerel ayarlar ve derleme çıktıları kesinlikle GitHub'a gönderilmesin.
- [x] APK/AAB dosyalarını kaynak depoya eklemek yerine GitHub Releases bölümünde yayınla.
- [x] Uygun açık kaynak lisansını seçip `LICENSE` dosyası ekle.
- [x] `CONTRIBUTING.md`, `CODE_OF_CONDUCT.md` ve güvenlik bildirimleri için `SECURITY.md` ekle.
- [x] Hata ve özellik isteği için GitHub Issue şablonları oluştur.
- [x] Pull Request şablonu oluştur.
- [x] Sürüm değişiklikleri için `CHANGELOG.md` hazırla.

### Otomasyon

- [x] GitHub Actions ile her push ve pull request'te `flutter analyze` ve `flutter test` çalıştır.
- [x] Android debug derlemesini CI üzerinde doğrula.
- [x] Sürüm etiketi oluşturulduğunda imzalı dosya üretme sürecini güvenli secret kullanımıyla tasarla; upload anahtarını repoya koyma.
- [ ] README içine yalnızca gerçekten çalışan analiz/test/Android rozetlerini ekle.

## Öncelik 3 — Yayın ve mağaza hazırlığı

- [x] Çoklu dil için Play Store başlığı, kısa açıklama ve tam açıklama çevirilerini hazırla.
- [x] Gizlilik politikasını Türkçe ve İngilizce hazırla.
- [ ] Geliştirici destek e-posta adresini gizlilik politikası ve mağaza kaydına ekle.
- [ ] Gizlilik politikasını herkese açık HTTPS adresinde yayınla.
- [ ] Play Console'da Play App Signing, içerik derecelendirme, hedef kitle ve alarm izin beyanlarını tamamla.
- [ ] En az bir gerçek Android telefonda ses, titreşim, kilit ekranı, 5 dakika erteleme, yeniden başlatma ve pil optimizasyonu testlerini yap.
- [x] Çoklu dil sürümü için sürüm numarasını yükselt ve sürüm notlarını Türkçe/İngilizce hazırla.

## Ek geliştirme fikirleri

- [ ] Erişilebilirlik: TalkBack etiketleri, minimum dokunma alanları, yüksek kontrast ve büyük yazı desteği.
- [x] Alarm verileri için geriye uyumlu veri taşıma yaklaşımı; yeni alanlarda varsayılanlar ve eski Android depolama anahtarları korunuyor.
- [x] Yedek dosyasına uygulama sürümü ve dil bilgisini ekle; eski yedeklerle geriye dönük uyumluluğu test et.
- [ ] Uygulama içinden kişisel veri toplamadan hata raporu dışa aktarma seçeneği ekle.
- [x] Pil kısıtlaması veya kritik izin kapatıldığında sessizce başarısız olmak yerine kullanıcıya anlaşılır uyarı göster.
- [ ] Alarm planlama ve yeniden başlatma testlerini farklı Android API seviyelerinde çalıştır.
- [x] Yayından önce bağımlılık, Android manifest ve gizli bilgi taraması yap.

## Tamamlanma ölçütü

Bu çalışma aşağıdaki koşullar birlikte sağlandığında tamamlanmış sayılacaktır:

- [x] Kullanıcı ilk açılışta dilini seçebiliyor ve Ayarlar'dan değiştirebiliyor.
- [x] Flutter ve Android yerel alarm metinlerinin tamamı desteklenen dillerde gösteriliyor.
- [ ] Bütün dillerde alarm sesi, bildirim eylemleri, erteleme ve yeniden başlatma testleri geçiyor.
- [x] GitHub deposunda gizli imza bilgisi bulunmuyor.
- [x] Türkçe ve İngilizce README, güncel ekran görüntüleri ve kurulum belgeleri hazır.
- [x] CI kontrollerinin yerel eşdeğeri başarılı ve yayımlanabilir APK/AAB doğrulanmış.
