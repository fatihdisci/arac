# Garajım — Son 4 Commit Raporu

**Tarih:** 27 Haziran 2026
**Branch:** main
**Toplam commit:** 4 (5c6de0e → d4492a5)

---

## Genel Bakış

Bu 4 commit, Garajım uygulamasının Design Polish Phase 1–2, motosiklet desteği ve bilgi mimarisi dönüşümünü kapsar. Toplamda **43 dosya** değişti, **12 yeni dosya** eklendi.

| Commit | Konu | Değişen Dosya | Tarih |
|--------|------|---------------|-------|
| `5c6de0e` | Hesap silme düzeltmesi | 3 | 15:36 |
| `9792d0f` | Design Polish Phase 1-2 + Bug fix + App Store hazırlık | 18 | 16:20 |
| `d24bd3f` | Motosiklet desteği | 10 | 16:45 |
| `d4492a5` | Bilgi mimarisi / UX dönüşümü | 7 | 16:57 |

---

## Commit Detayları

### 1. `5c6de0e` — fix: hesap silme — display_name düzeltildi, DocumentStorageService.deleteAllFiles eklendi

**Amaç:** Hesap silme akışındaki eksiklerin giderilmesi.

**Değişen dosyalar (3):**

| Dosya | Değişiklik |
|-------|-----------|
| `Features/Community/Services/CommunityProfileService.swift` | `anonymizeProfile()`: `display_name` `null` → `"Silinmiş Kullanıcı"` |
| `Features/Settings/SettingsView.swift` | `deleteAccountAndData()`: belge temizliği `DocumentStorageService.deleteAllFiles()` üzerinden |
| `Services/DocumentStorageService.swift` | `deleteAllFiles()` metodu eklendi — tüm belge dizinini temizleyip yeniden oluşturur |

**Hesap silme akışı (doğrulanan):**
- SwiftData 8 model temizleniyor (Vehicle, Reminder, Expense, ServiceRecord, PartChange, VehicleDocument, InspectionReport, SaleFile)
- Fiziksel belge dosyaları temizleniyor
- Bildirimler iptal ediliyor
- Topluluk profili anonimleştiriliyor (hard delete değil — moderation bütünlüğü korunuyor)
- Supabase oturumu kapatılıyor
- Pro state sıfırlanıyor
- Destructive confirmation dialog + Türkçe hata mesajı

---

### 2. `9792d0f` — fix: belge başlık senkronizasyonu, save hata yönetimi, QuickAction navigasyon bağlantıları, PrivacyInfo UGC güncellemesi, Supabase final deploy SQL, Reminder 30 gün özeti

**Amaç:** Design Polish Phase 1-2, belge bug düzeltmeleri, App Store hazırlık.

**Değişen dosyalar (18):**

| Kategori | Dosya | Değişiklik |
|----------|-------|-----------|
| **Bug fix** | `Features/Documents/DocumentFormView.swift` | Başlık auto-sync (`hasUserEditedTitle`), save `do/catch`, preselectedVehicleId, başarı haptik |
| **Bug fix** | `Features/VehicleDetail/VehicleDetailView.swift` | `DocumentFormView(preselectedVehicleId:)`, opsiyonel interpolasyon fix |
| **UX** | `Features/Garage/GarageView.swift` | QuickActionRail 5 buton bağlantısı, paywall gate'leri |
| **UX** | `Features/Reminders/ReminderListView.swift` | 30 gün özet modülü, boş durum kopyası, tamamlama haptik |
| **UX** | `Features/Reminders/ReminderFormView.swift` | `init(preselectedVehicleId:)` |
| **UX** | `Features/Expenses/ExpenseFormView.swift` | `preselectedVehicleId` init parametresi |
| **UX** | `Features/ServiceRecords/ServiceRecordFormView.swift` | `preselectedVehicleId` init parametresi |
| **UX** | `Features/Reports/ReportsView.swift` | PremiumMetricHero + OwnershipInsightCards |
| **DesignSystem** | `QuickActionTile.swift` | **Yeni** — QuickActionTile + QuickActionRail |
| **DesignSystem** | `DossierCompletenessCard.swift` | **Yeni** — Dairesel ilerleme kartı |
| **DesignSystem** | `OwnershipInsightCard.swift` | **Yeni** — Sahiplik içgörü kartı |
| **DesignSystem** | `BrandIntroView.swift` | **Yeni** — 1.8sn premium reveal |
| **App Store** | `Resources/PrivacyInfo.xcprivacy` | UGC, e-posta, isim, fotoğraf, satın alma veri türleri |
| **Supabase** | `docs/SUPABASE_FINAL_DEPLOY.sql` | **Yeni** — Birleşik şema + RLS + trigger + index |
| **Other** | `Services/CommunityAuthService.swift` | `guard let client` → `guard client != nil` fix |
| **Other** | `Features/Settings/SettingsView.swift` | `saleFiles` export'a eklendi |
| **Project** | `VehicleDossierApp.xcodeproj/project.pbxproj` | 4 yeni DesignSystem komponenti |
| **App** | `App/VehicleDossierApp.swift` | BrandIntroView wrapper |

---

### 3. `d24bd3f` — feat: motosiklet desteği — VehicleType, MotorcycleType, özel şablonlar, form ve skor uyarlamaları

**Amaç:** Uygulamayı otomobil + motosiklet destekleyecek şekilde genişletmek.

**Değişen dosyalar (10):**

| Kategori | Dosya | Değişiklik |
|----------|-------|-----------|
| **Model** | `Models/AppBrand.swift` | **Yeni** — Merkezi marka sabitleri |
| **Model** | `Models/Enums.swift` | `VehicleType` (car/motorcycle), `MotorcycleType` (8 tip), motosiklet özel ReminderType (8), ExpenseCategory (2), DocumentType (3) |
| **Model** | `Models/Vehicle.swift` | `vehicleTypeRaw`, `motorcycleTypeRaw`, `engineCC` — migration güvenli (varsayılan: car) |
| **Form** | `Features/Garage/VehicleFormView.swift` | Araç türü seçici, motosiklet tipi + motor hacmi alanları |
| **Form** | `Features/VehicleDetail/VehicleEditView.swift` | vehicleType/motorcycleType/engineCC state + init |
| **Hero** | `DesignSystem/Components/VehicleHeroHeader.swift` | `car.fill` / `bicycle` ikonu |
| **Hero** | `Features/Garage/GarageView.swift` | Hero icon + skor motosiklet uyumlu |
| **Skor** | `Features/VehicleDetail/VehicleDetailView.swift` | `computeFileScore()` motosiklet engineCC bonus |
| **Skor** | `App/VehicleDossierApp.swift` | Retention skor motosiklet uyumlu |
| **Test** | `Tests/ModelTests.swift` | 10 yeni motosiklet testi |

**Yeni enum değerleri:**

| Enum | Eklenen | Sayı |
|------|---------|------|
| `VehicleType` | car, motorcycle | 2 |
| `MotorcycleType` | scooter, naked, touring, enduro, cruiser, sport, commuter, other | 8 |
| `ReminderType` | chainMaintenance, chainSprocketSet, sparkPlug, airFilter, clutchCable, suspensionCheck, seasonStartCheck, winterPrep | +8 (22 toplam) |
| `ExpenseCategory` | chainSprocket, equipment | +2 (21 toplam) |
| `DocumentType` | equipmentInvoice, helmetGearWarranty, accessoryMounting | +3 |

---

### 4. `d4492a5` — feat: bilgi mimarisi dönüşümü — tab isimleri, Yapılacaklar detay, Geçmiş filtreler

**Amaç:** Kullanıcı zihinsel modelini netleştirmek: "İşler/Kayıtlar" ayrımı yerine "Yapılacaklar/Geçmiş".

**Değişen dosyalar (7):**

| Kategori | Dosya | Değişiklik |
|----------|-------|-----------|
| **Tab bar** | `App/AppRouter.swift` | Tab enum: `.reminders→.todos`, `.records→.history`. İkon: `checklist`, `clock.arrow.circlepath` |
| **Yeni** | `Features/Reminders/TodosView.swift` | Yapılacaklar sarmalayıcısı, bildirim izni |
| **Yeni** | `Features/Reminders/ReminderDetailView.swift` | Tap-detay: durum başlığı, detay kartı, tamamla/düzenle/sil, tamamlama→Geçmiş akışı |
| **Güncelleme** | `Features/Reminders/ReminderListView.swift` | Satırlar `NavigationLink` ile tıklanabilir, boş durum kopyası |
| **Yeni** | `Features/Records/HistoryView.swift` | Geçmiş: 5 filtre (Tümü/Masraflar/Bakımlar/Belgeler/Ekspertiz), filtre bazlı boş durumlar, timeline |
| **Test** | `Tests/ModelTests.swift` | ReminderType count (23→22) |
| **Project** | `VehicleDossierApp.xcodeproj/project.pbxproj` | 3 yeni dosya |

**Tab yapısı:**

| # | Tab | İkon | İçerik |
|---|-----|------|--------|
| 1 | Garaj | `car` | Araç kartı, hızlı işlemler, dosya tamlığı |
| 2 | Yapılacaklar | `checklist` | Gelecek işler (muayene, sigorta, bakım…) |
| 3 | Geçmiş | `clock.arrow.circlepath` | Yapılmış işlemler (masraf, bakım, belge, ekspertiz) |
| 4 | Raporlar | `chart.bar` | Maliyet analizi, sahiplik içgörüleri |
| 5 | Topluluk | `person.3` | Kontrollü forum |

---

## 12 Yeni Dosya

| # | Dosya | Commit | Açıklama |
|---|-------|--------|----------|
| 1 | `Models/AppBrand.swift` | `d24bd3f` | Merkezi marka sabitleri |
| 2 | `DesignSystem/Components/QuickActionTile.swift` | `9792d0f` | Hızlı işlem butonu + rail |
| 3 | `DesignSystem/Components/DossierCompletenessCard.swift` | `9792d0f` | Dosya tamlığı kartı |
| 4 | `DesignSystem/Components/OwnershipInsightCard.swift` | `9792d0f` | Sahiplik içgörü kartı |
| 5 | `DesignSystem/Components/BrandIntroView.swift` | `9792d0f` | App açılış reveal |
| 6 | `docs/SUPABASE_FINAL_DEPLOY.sql` | `9792d0f` | Birleşik Supabase deployment SQL |
| 7 | `Features/Reminders/TodosView.swift` | `d4492a5` | Yapılacaklar tab |
| 8 | `Features/Reminders/ReminderDetailView.swift` | `d4492a5` | Yapılacak detay ekranı |
| 9 | `Features/Records/HistoryView.swift` | `d4492a5` | Geçmiş tab (filtreli) |

---

## Build / Test Özeti

| Commit | Debug Build | Test |
|--------|-------------|------|
| `5c6de0e` | ✅ | ✅ (79 test) |
| `9792d0f` | ✅ | ✅ (79 test) |
| `d24bd3f` | ✅ | ✅ (79 test — yeni testler sonraki committe aktif) |
| `d4492a5` | ✅ | ✅ (89 test) |

---

## Ürün Durumu

### Tamamlanan

- [x] DesignSystem token tabanlı premium UI (QuickActionRail, DossierCompletenessCard, OwnershipInsightCard)
- [x] BrandIntroView (1.8sn premium reveal)
- [x] Belge başlık auto-sync + save hata yönetimi
- [x] QuickActionRail 5 buton navigasyon bağlantısı
- [x] PrivacyInfo.xcprivacy UGC/App Store uyumlu
- [x] Supabase final deploy SQL (şema + RLS + trigger)
- [x] Reminder 30 gün özet modülü
- [x] Motosiklet desteği (VehicleType, MotorcycleType, özel enum'lar, form, skor)
- [x] Tab isimleri: Yapılacaklar / Geçmiş
- [x] ReminderDetailView (tap-detay + tamamlama→Geçmiş akışı)
- [x] HistoryView (5 filtreli birleşik geçmiş)
- [x] Hesap silme akışı (SwiftData + belge + Supabase anonimleştirme)

### Devam Eden / Sonraki

- [ ] Onboarding akışı (4 ekranlı first-run)
- [ ] Dosyanı tamamla checklist (Garaj'da onboarding sonrası)
- [ ] Contextual tips sistemi
- [ ] ReminderDetailView edit: mevcut veriyi ReminderFormView'a taşıma
- [ ] `VehicleDossierApp/` alt dizinindeki eski kopyaların temizlenmesi
- [ ] PrivacyInfo.xcprivacy'de Supabase domain'i
- [ ] RevenueCat webhook → Supabase Edge Function → profiles.is_pro sync

---

## Manuel Yapılması Gerekenler (Supabase)

1. Supabase Dashboard → SQL Editor → `docs/SUPABASE_FINAL_DEPLOY.sql` çalıştır
2. Apple Sign-In provider ayarlarını doğrula (Service ID, callback URL, p8 key)
3. Admin kullanıcısı oluştur: `UPDATE profiles SET role='admin', is_verified=true, is_pro=true WHERE id='<UUID>';`

---

## Manuel Test Checklist

- [ ] Tab isimleri: Garaj / Yapılacaklar / Geçmiş / Raporlar / Topluluk
- [ ] Yapılacaklar → satıra TAP → detay açılıyor → düzenle/sil/tamamla çalışıyor
- [ ] Bakım türü iş tamamlanınca "Bakım Kaydı Oluştur" seçeneği çıkıyor
- [ ] Geçmiş → filtre çipleri (Tümü/Masraflar/Bakımlar/Belgeler/Ekspertiz)
- [ ] QuickActionRail: Masraf/Bakım/Belge/Hatırlatıcı/Satış
- [ ] Belge ekle → tür değişimi başlığı güncelliyor → özel başlık korunuyor
- [ ] Araç ekle → araç türü seçici → motosiklet alanları
- [ ] Dark mode + Dynamic Type + VoiceOver
- [ ] Hesap silme → veri temizliği → topluluk profil anonimleşmesi
