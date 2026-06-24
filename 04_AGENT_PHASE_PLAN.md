# Coding Agent Phase Plan

Bu dosya Claude Code / Hermes / Codex gibi coding agentlara faz faz uygulama yaptırmak için hazırlanmıştır.

## Global agent kuralları

Her faz başlamadan önce agent şunları okumalı:

1. `01_DESIGN.md`
2. `02_PRODUCT_SCOPE.md`
3. `03_SWIFTUI_ARCHITECTURE.md`

Kodlama kuralları:

- SwiftUI native API kullanılacak.
- UI ham renk/spacing/radius kullanmayacak; DesignSystem tokenlarından beslenecek.
- Her major ekranda empty/loading/error durumu olacak.
- Dynamic Type ve dark mode bozulmayacak.
- Business logic ile UI birbirine karıştırılmayacak.
- Her faz sonunda build alınacak.
- Her faz sonunda kısa rapor yazılacak:
  - Ne yapıldı?
  - Hangi dosyalar değişti?
  - Test/build sonucu ne?
  - Bilinen eksik var mı?
  - Bir sonraki faza engel var mı?

## Faz 0 — Proje iskeleti ve tasarım sistemi

### Amaç

Temiz SwiftUI proje temeli, DesignSystem ve veri model altyapısı kurmak.

### Yapılacaklar

- Xcode SwiftUI app oluştur.
- Minimum iOS 17 belirle.
- SwiftData aktif et.
- `DesignSystem` klasörü oluştur.
- Renk, spacing, radius, typography tokenlarını ekle.
- ButtonStyle’ları ekle.
- EmptyStateView, ErrorStateView, SectionHeader, MetricCard komponentlerini ekle.
- AppRouter veya basit tab yapısı oluştur.
- 5 tab placeholder:
  - Garaj
  - İşler
  - Kayıtlar
  - Belgeler
  - Raporlar
- Dark mode kontrol et.

### Kabul kriterleri

- Build pass.
- Tab navigation çalışıyor.
- Ham renk/spacing minimum.
- Preview’lar çalışıyor.
- EmptyStateView kullanılabiliyor.

## Faz 1 — SwiftData modelleri

### Amaç

Uygulamanın veri omurgasını kurmak.

### Yapılacaklar

- Vehicle
- Reminder
- Expense
- ServiceRecord
- PartChange
- VehicleDocument
- InspectionReport
- SaleFile
- Vendor opsiyonel
- Enumlar
- Mock data
- Preview fixtures

### Kabul kriterleri

- Model container çalışıyor.
- Mock data ile preview alınıyor.
- Basit create/read/delete testleri geçiyor.
- Migration riski düşük, model isimleri net.

## Faz 2 — Onboarding ve araç ekleme

### Amaç

Kullanıcı ilk aracını kolayca ekleyebilsin.

### Yapılacaklar

- İlk açılış empty state.
- Araç ekleme formu.
- Marka/model/yıl/plaka/km/yakıt tipi.
- Opsiyonel araç fotoğrafı.
- İlk kritik tarihleri girme:
  - Muayene
  - Trafik sigortası
  - Kasko
  - Son bakım
- Form validation.
- Başarı haptik.
- Araç kartı oluşturma.

### Kabul kriterleri

- Kullanıcı araç ekleyebiliyor.
- Araç Garaj ekranında görünüyor.
- Eksik zorunlu alanlarda net hata var.
- Dynamic Type bozulmuyor.
- Empty state tek CTA içeriyor.

## Faz 3 — Garaj ve araç detay dashboard

### Amaç

Araç ana panelini ürünün merkezine yerleştirmek.

### Yapılacaklar

- VehicleCard
- VehicleHeroHeader
- UpcomingTaskCard
- Dosya Tamlığı kartı
- Son kayıtlar alanı
- Araç düzenleme
- Araç arşivleme/silme
- Araç Yaşam Çizgisi başlangıcı

### Kabul kriterleri

- Araç detayında tek ana görsel çapa var.
- Yaklaşan en önemli iş net görünüyor.
- Gecikmiş/kritik durumlar renk tokenları ile ayrışıyor.
- Araç arşivleme yanlışlıkla yapılamıyor; confirmation var.

## Faz 4 — Hatırlatıcı sistemi

### Amaç

Muayene, sigorta, bakım gibi işleri takip ettirmek.

### Yapılacaklar

- Reminder listesi.
- Reminder oluşturma.
- Reminder şablonları.
- Tarih bazlı reminder.
- Km bazlı reminder.
- Tamamlandı işareti.
- Overdue hesaplama.
- NotificationService.
- Bildirim izni açıklama ekranı.
- Local notification schedule.

### Kabul kriterleri

- Reminder ekleniyor.
- Gecikmiş/bugün/yaklaşan ayrımı doğru.
- Bildirim izni istenebiliyor.
- Local notification schedule ediliyor.
- Tamamlanan reminder bildirimleri iptal ediliyor.
- Unit testler geçiyor.

## Faz 5 — Masraf kayıtları

### Amaç

Araç masraflarını kayıt altına almak.

### Yapılacaklar

- Expense listesi.
- Expense ekleme formu.
- Kategori seçimi.
- Tutar, tarih, km, vendor, not.
- Fatura/belge ilişkilendirme placeholder.
- Toplam masraf hesaplama.
- Kategori filtreleri.
- Masraf empty state.

### Kabul kriterleri

- Masraf ekleniyor.
- Araç detayında son masraflar görünüyor.
- Raporlar için toplamlar hesaplanıyor.
- Hatalı tutar girişinde açıklayıcı validation var.

## Faz 6 — Bakım kayıtları ve değişen parçalar

### Amaç

Bakım geçmişini sıradan masraf kaydından daha zengin hale getirmek.

### Yapılacaklar

- ServiceRecord listesi.
- Bakım ekleme formu.
- Service type.
- Usta/servis.
- İşçilik/parça/toplam.
- Değişen parçalar.
- Sonraki bakım hatırlatıcısı oluşturma seçeneği.
- Timeline görünümü.

### Kabul kriterleri

- Bakım kaydı ekleniyor.
- Parça listesi ekleniyor.
- Bakımdan reminder oluşturulabiliyor.
- Araç Yaşam Çizgisi bakım kayıtlarını gösteriyor.

## Faz 7 — Belge kasası

### Amaç

Poliçe, muayene, ekspertiz, fatura gibi belgeleri saklamak.

### Yapılacaklar

- Document listesi.
- Belge tipi seçimi.
- PhotosUI import.
- PDF import.
- VisionKit document scan.
- Belge önizleme.
- Expiry date.
- Satış dosyasına dahil et toggle.
- DocumentStorageService.

### Kabul kriterleri

- Fotoğraf/PDF ekleniyor.
- Belge araçla ilişkilendiriliyor.
- Belge silinince dosya da temizleniyor.
- Belge preview çalışıyor.
- Büyük dosyada hata mesajı net.

## Faz 8 — Ekspertiz raporu

### Amaç

Ekspertiz raporunu özel bir birinci sınıf varlık olarak ele almak.

### Yapılacaklar

- InspectionReport modeli UI.
- Firma adı, şube, rapor tarihi, km.
- PDF/fotoğraf belge ilişkisi.
- Manuel/doğrulanmamış statü.
- Satış dosyasına dahil etme.
- Uyarı metni:
  - Rapor içeriği kullanıcı/firma beyanıdır.
  - Uygulama doğruluk garantisi vermez.

### Kabul kriterleri

- Ekspertiz raporu ekleniyor.
- Araç detayında özel kart olarak görünüyor.
- Satış dosyasına dahil edilebiliyor.
- Hukuki uyarı açık.

## Faz 9 — Raporlar

### Amaç

Kullanıcıya aracının maliyetini göstermek.

### Yapılacaklar

- Yıllık toplam.
- Aylık masraf grafiği.
- Kategori dağılımı.
- Km başı maliyet.
- En pahalı kayıtlar.
- Boş veri durumları.
- Charts framework.

### Kabul kriterleri

- Raporlar gerçek veriyle çalışıyor.
- Veri yoksa empty state var.
- Grafikler dark mode’da okunuyor.
- Büyük tutarlar taşmıyor.

## Faz 10 — Satış dosyası PDF

### Amaç

Ürünün ayırt edici değerini oluşturmak.

### Yapılacaklar

- SaleFile oluşturma akışı.
- Hangi bölümler dahil edilecek seçimi.
- Belge seçimi.
- Ekspertiz seçimi.
- PDFExportService.
- PDF preview.
- Share sheet.
- Hukuki disclaimer.
- Dosya tamlık skoru.

### Kabul kriterleri

- PDF oluşturuluyor.
- PDF okunabilir ve premium görünüyor.
- Disclaimer var.
- Share çalışıyor.
- Büyük veri setinde crash yok.

## Faz 11 — Paywall ve abonelik

### Amaç

Freemium/Pro modelini kurmak.

### Yapılacaklar

- Free limitler:
  - 1 araç
  - sınırlı belge
  - sınırlı PDF/export
- Pro özellikler:
  - sınırsız araç
  - sınırsız belge
  - satış dosyası PDF/link
  - gelişmiş raporlar
- RevenueCat veya StoreKit 2 entegrasyonu.
- Restore purchases.
- Paywall UI.
- Cancel anytime mesajı.
- Subscription state.

### Kabul kriterleri

- Paywall dark pattern içermiyor.
- Restore linki var.
- Abonelik durumu doğru okunuyor.
- Free limit doğru çalışıyor.
- Pro açılınca kilitler kalkıyor.

## Faz 12 — Settings, legal, privacy

### Amaç

App Store review ve kullanıcı güveni için gerekli ekranları tamamlamak.

### Yapılacaklar

- Ayarlar ekranı.
- Bildirim ayarları.
- Veri export.
- Veri silme.
- Gizlilik politikası linki.
- Kullanım koşulları linki.
- Uygulama resmi kurum değildir uyarısı.
- App version/build gösterimi.
- Support email.

### Kabul kriterleri

- Privacy/terms linkleri aktif.
- Veri silme çalışıyor.
- Resmi kurum gibi görünme riski yok.
- App Store review notes hazırlanabilir.

## Faz 13 — Cila ve review hardening

### Amaç

Uygulamayı profesyonel ve review-ready hale getirmek.

### Yapılacaklar

- Tüm empty/loading/error state kontrolü.
- Dark mode.
- Dynamic Type.
- VoiceOver.
- Reduce Motion.
- Haptik.
- Gerçek veri testleri.
- Büyük dosya testleri.
- Bildirim testleri.
- Abonelik sandbox testleri.
- App icon.
- Launch screen.
- App Store screenshot metinleri.

### Kabul kriterleri

- Build pass.
- Unit tests pass.
- UI smoke tests pass.
- Review checklist pass.
- Known issues listesi temiz veya kabul edilebilir.

