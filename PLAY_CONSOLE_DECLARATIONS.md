# Snoon Play Console Beyanları

## Kesin alarm

Snoon’un temel ve kullanıcıya dönük ana işlevi alarm ve zamanlayıcı kurmaktır. `SCHEDULE_EXACT_ALARM` yalnızca kullanıcının açıkça oluşturduğu alarm, uyku programı ve zamanlayıcıların seçilen zamanda çalışması için kullanılır.

## Tam ekran bildirim

`USE_FULL_SCREEN_INTENT`, yalnızca kullanıcı tarafından kurulan alarm veya zamanlayıcı çaldığında kilit ekranında erteleme ve kapatma kontrollerini göstermek için kullanılır. Snoon bu izni reklam, mesaj veya promosyon için kullanmaz.

## Foreground service

`mediaPlayback` türündeki foreground service yalnızca alarm/zamanlayıcı sesini çalarken çalışır. Kullanıcı bildirimin veya alarm ekranının Kapat düğmesiyle servisi durdurabilir; otomatik susturma süresi dolduğunda servis kendiliğinden kapanır.

## Veri güvenliği formu

- Toplanan veri: Yok
- Paylaşılan veri: Yok
- Hesap: Yok
- Reklam: Yok
- Analiz/izleme: Yok
- Veriler: Cihazda yerel olarak saklanır
- İsteğe bağlı dışa aktarma: Kullanıcının seçtiği konuma JSON dosyası

## Yayından önce elle doldurulacak alanlar

- Geliştirici destek e-postası
- Herkese açık gizlilik politikası URL’si
- İçerik derecelendirme anketi
- Ülke/fiyatlandırma seçimi
- Play App Signing kaydı ve upload sertifikası
