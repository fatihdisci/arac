# Garajım — CarCatalog + Free/Pro Paywall QA

Tarih: 2026-06-25
Repo: `~/apps/arac`
Scheme: `VehicleDossierApp`
Bundle ID: `com.ruhsatim.app` — korunmuştur.
Product IDs — korunmuştur:

- `com.ruhsatim.pro.monthly`
- `com.ruhsatim.pro.yearly`
- `com.ruhsatim.pro.lifetime`

## Özet

Bu çalışma iki kapsamı birlikte tamamladı:

1. Türkiye pazarı marka/model kataloğu app bundle içine alındı ve araç ekleme/düzenleme formlarına seçimli, aranabilir marka/model akışı bağlandı.
2. Free/Pro ayrımı ve paywall tetikleri netleştirildi: 1 araç, 5 belge, satış PDF ve gelişmiş rapor limitleri testlerle sabitlendi.

SwiftData `Vehicle.brand` ve `Vehicle.model` alanları **String olarak kaldı**. Migration gerektiren model değişikliği yapılmadı.

---

## A) CarCatalog entegrasyonu

### JSON konumu

- Kaynak dosya app içine şu path ile eklendi:
  - `Resources/CarCatalog.tr.json`
- Xcode target membership / bundle resource:
  - `VehicleDossierApp.xcodeproj/project.pbxproj`
- Runtime erişim:
  - `Bundle.main.url(forResource: "CarCatalog.tr", withExtension: "json")`

### Veri sayısı

Validated final bundle JSON:

- Marka: **60**
- Model: **358**
- Duplicate brand id: **0**
- Same-brand duplicate model id: **0**
- Empty displayName: **0**

### Eklenen üretim kodu

- `Services/CarCatalogService.swift`
  - `CarCatalog`
  - `CarBrand`
  - `CarModel`
  - `VehicleCatalogSelection`
  - `CarCatalogService`
- `Features/Garage/VehicleCatalogPickerViews.swift`
  - `VehicleCatalogSelectionField`
  - `CarBrandPickerSheet`
  - `CarModelPickerSheet`

### Search / alias / normalize

Test edilen davranışlar:

- `Volkswagen`, `Renault`, `Fiat` bulunuyor.
- `citroen` araması `Citroën` döndürüyor.
- `tofas` araması `Tofaş` döndürüyor.
- Volkswagen modellerinde `Golf` bulunuyor.
- Renault modellerinde `Clio` bulunuyor.
- Fiat modellerinde `Egea` bulunuyor.
- Marka değişince model resetleniyor.
- Manuel marka/model validation çalışıyor.

Normalize yaklaşımı:

- Diacritic-insensitive folding
- Case-insensitive search
- Türkçe `ı/İ` normalizasyonu
- Display name + alias token araması

### Araç form entegrasyonu

Güncellenen dosyalar:

- `Features/Garage/VehicleFormView.swift`
- `Features/VehicleDetail/VehicleEditView.swift`

Davranış:

- Marka TextField yerine searchable sheet/list geldi.
- Model listesi seçilen markaya göre filtreleniyor.
- Marka değişince model resetleniyor.
- `Diğer Marka` seçilirse manuel marka/model girişi açılıyor.
- `Diğer Model` seçilirse manuel model girişi açılıyor.
- Katalogda olmayan eski kayıtlar edit ekranında custom olarak gösteriliyor.
- Kaydedilen değerler hâlâ `Vehicle.brand` / `Vehicle.model` String alanlarına yazılıyor.

---

## B) Free / Pro ve paywall

### Free plan

- 1 araç
- 5 belge
- Temel hatırlatıcılar
- Masraf ve bakım kayıtları

### Pro plan

- Sınırsız araç
- Sınırsız belge
- Satış dosyası PDF
- Gelişmiş raporlar
- Ekspertiz raporlarını satış dosyasına ekleme

Not: Production-ready olmayan iCloud sync/yedekleme vaadi paywall/App Store metadata metninden çıkarıldı.

### PaywallService limitleri

Dosya:

- `Services/PaywallService.swift`

Netleştirilen fonksiyonlar:

- `canAddVehicle(currentCount:)`
  - Free: 0 araçta true, 1 araçtan sonra false
  - Pro: true
- `canAddDocument(currentCount:)`
  - Free: 4 belgede true, 5 belgeden sonra false
  - Pro: true
- `canCreateSaleFile()`
  - Free: false
  - Pro: true
- `canAccessAdvancedReports()`
  - Free: false
  - Pro: true

### Paywall tetikleri

Bağlı/korunan tetikler:

- Garage: 2. araç ekleme denemesinde paywall
- Documents: 6. belge ekleme denemesinde paywall
- SaleFile: PDF oluşturma/paylaşma denemesinde paywall
- Reports: gelişmiş rapor alanında paywall
- Settings: `Pro'ya Geç` paywall açıyor
- Restore purchases: Settings ve Paywall içinde görünür

### Paywall UI

Dosya:

- `Features/Paywall/PaywallView.swift`

Eklenen/iyileştirilen bölüm:

- `Free ve Pro` karşılaştırması
- Kullanıcı sadece Pro listesini değil, Free sınırlarını da görüyor.

### DEBUG Pro/Free switch

Dosya:

- `Features/Settings/SettingsView.swift`

DEBUG build içinde:

- `Dev: Pro’yu Aç`
- `Dev: Free’ye Dön`

Release doğrulaması:

- Release binary `strings` taramasında şu stringler çıkmadı:
  - `Dev: Pro`
  - `Dev: Free`
  - `Demo Verileri`
  - `Geliştirici`

---

## Testler

Eklenen test kapsamı:

- CarCatalog bundle load
- Marka/model search
- Türkçe normalize search
- Veri kalitesi duplicate/empty kontrolü
- Marka değişince model reset
- Manuel marka/model validation
- Free/Pro araç limiti
- Free/Pro belge limiti
- Free/Pro satış PDF izni
- Free/Pro gelişmiş rapor izni

Test sonucu:

- **45 test çalıştı**
- **0 failure**
- Sonuç: **PASS**

---

## Build sonucu

| Kontrol | Sonuç |
|---|---|
| Debug build | PASS |
| Release build | PASS |
| Full unit tests | PASS — 45/45 |
| Bundle JSON var mı? | PASS — `Ruhsatim.app/CarCatalog.tr.json` |
| Release debug string taraması | PASS |

Build komutları:

```bash
xcodebuild -project VehicleDossierApp.xcodeproj \
  -scheme VehicleDossierApp \
  -destination 'platform=iOS Simulator,name=iPhone 16' \
  build

xcodebuild -project VehicleDossierApp.xcodeproj \
  -scheme VehicleDossierApp \
  -configuration Release \
  -destination 'platform=iOS Simulator,name=iPhone 16' \
  build

xcodebuild test -project VehicleDossierApp.xcodeproj \
  -scheme VehicleDossierApp \
  -destination 'platform=iOS Simulator,name=iPhone 16'
```

---

## Simulator smoke

Temiz erase sonrası iPhone 16 Simulator launch smoke:

| Smoke | Sonuç |
|---|---|
| Normal launch | PASS |
| Dark mode launch | PASS |
| XXXL content size launch | PASS |

Komut çıktısı PID döndürdü:

- Normal: `com.ruhsatim.app: 24213`
- Dark: `com.ruhsatim.app: 24256`
- XXXL: `com.ruhsatim.app: 24281`

Not: İlk launch denemesinde simulator `Busy` verdi; cihaz erase + boot sonrası tekrarlandı ve geçti. Bu Xcode/simulator state kaynaklıydı, build/test failure değil.

---

## App Store risk kontrolü

- Resmi kurum gibi görünmeme: Settings içinde açık disclaimer mevcut.
- MTV ödeme/sorgulama iddiası: yeni eklenmedi.
- TÜVTÜRK/GİB/e-Devlet logo/ima: logo/görsel kullanılmadı; bağlantı yoktur disclaimer korunuyor.
- Mekanik garanti/araç sağlığı iddiası: SaleFile/Inspection disclaimer uygulamanın garanti vermediğini açık söylüyor.
- iCloud sync/yedekleme Pro vaadi: paywall ve metadata’dan çıkarıldı.

---

## Değişen dosyalar

- `Resources/CarCatalog.tr.json`
- `Services/CarCatalogService.swift`
- `Features/Garage/VehicleCatalogPickerViews.swift`
- `Features/Garage/VehicleFormView.swift`
- `Features/VehicleDetail/VehicleEditView.swift`
- `Services/PaywallService.swift`
- `Features/Paywall/PaywallView.swift`
- `Features/Reports/ReportsView.swift`
- `Features/Settings/SettingsView.swift`
- `Features/Documents/DocumentListView.swift`
- `Resources/AppStoreMetadata.md`
- `Tests/ModelTests.swift`
- `VehicleDossierApp.xcodeproj/project.pbxproj`
- `VehicleDossierApp/Services/PaywallService.swift` (repo içindeki eski/kopya servis metni de App Store metin tutarlılığı için temizlendi)

---

## Kalan sorunlar

### Critical

0

### High

0

### Medium

1. Gerçek cihazda foto/PDF picker ve StoreKit sandbox satın alma/restore hâlâ manuel smoke gerektirir.
2. Simulator’da ilk launch denemesinde zaman zaman `Busy` görülebiliyor; erase sonrası normal/dark/XXXL launch geçti.

---

## TestFlight kararı

**Evet — build/test açısından TestFlight’a çıkabilir.**

Önerilen son manuel gerçek cihaz kontrolü:

1. Marka/model seçim: Volkswagen > Golf, Citroën araması, Tofaş araması.
2. Diğer Marka / Diğer Model manuel kayıt.
3. 2. araçta paywall.
4. 6. belgede paywall.
5. Satış PDF’de paywall.
6. StoreKit sandbox purchase + restore.
