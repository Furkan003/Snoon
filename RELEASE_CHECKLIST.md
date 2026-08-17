# Snoon 1.1.0 Yayın Kontrol Listesi

- [x] Paket adı: `com.furka.snoon`
- [x] Sürüm: `1.1.0+2`
- [x] Flutter ve yerel Android tarafında yedi dil desteği
- [x] İlk açılış dil seçimi ve Ayarlar'dan anlık dil değiştirme
- [x] Türkçe/İngilizce GitHub tanıtımı ve GitHub Actions doğrulaması
- [x] Android 16 / API 36 hedefi
- [x] Yerel upload anahtarı oluşturuldu
- [x] Release küçültme ve kaynak daraltma açık
- [x] İmzalı APK ve AAB üretildi, imzaları doğrulandı
- [x] Android 16 emülatöründe alarm, 5 dk erteleme, reboot, zamanlayıcı ve görev testleri
- [x] Android dosya seçicisiyle JSON yedek dışa aktarma/geri yükleme testi
- [x] Play Store ekran görüntüsü taslakları
- [x] Gizlilik politikası taslağı
- [x] Mağaza metni ve izin beyanları
- [x] `v*` etiketi için secret tabanlı imzalı GitHub Release iş akışı
- [ ] Destek e-posta adresini belgelere ekle
- [ ] Gizlilik politikasını herkese açık HTTPS adresinde yayınla
- [ ] Play Console geliştirici hesabı kimlik doğrulamasını tamamla
- [ ] Play App Signing’i aç ve upload sertifikasını kaydet
- [ ] İçerik derecelendirme ve hedef kitle formlarını doldur
- [ ] En az bir gerçek Android telefonda üretici/pil/titreşim testini tamamla

## İmza anahtarını koru

`android/snoon-upload-keystore.jks` ve `android/key.properties` dosyalarını parola yöneticisiyle korunan en az iki güvenli konuma yedekle. Bu dosyalar `.gitignore` kapsamındadır ve kaynak kontrolüne eklenmemelidir.

GitHub Actions için `ANDROID_KEYSTORE_BASE64`, `ANDROID_KEY_ALIAS`,
`ANDROID_KEY_PASSWORD` ve `ANDROID_STORE_PASSWORD` repository secret'larını
tanımla. Ardından `v1.1.0` gibi bir etiket pushlandığında APK, AAB ve SHA-256
dosyası GitHub Releases bölümünde otomatik yayınlanır.
