# SwiftUI Teknik Mimari

## 1. Teknik yön

Platform:

- iOS only
- SwiftUI
- SwiftData
- Local-first
- CloudKit sync opsiyonlu
- RevenueCat veya StoreKit 2
- VisionKit belge tarama
- PDFKit / custom PDF rendering
- UserNotifications
- Charts
- PhotosUI
- ShareLink

## 2. Mimari ilke

Uygulama local-first tasarlanacak. Kullanıcı temel özellikleri internetsiz kullanabilmeli.

Veriler:

- Araçlar
- Hatırlatıcılar
- Bakımlar
- Masraflar
- Belgeler
- Ekspertiz raporları
- Satış dosyası metadata

cihazda saklanır.

Paylaşılabilir satış linki veya partner entegrasyonu gelirse backend eklenir.

## 3. Backend kararı

### MVP önerisi

- SwiftData + local file storage
- iCloud/CloudKit sync opsiyonel
- PDF local oluşturma
- RevenueCat/StoreKit 2
- Server yok

### V1.5 önerisi

Satış dosyası linki için:

- Supabase Auth
- Supabase Storage
- Supabase Edge Functions
- Signed public share links
- RLS
- Share token

## 4. Modül yapısı

Önerilen klasör yapısı:

```text
VehicleDossierApp/
  App/
    VehicleDossierApp.swift
    AppRouter.swift
    AppEnvironment.swift

  DesignSystem/
    DesignTokens.swift
    AppColors.swift
    AppTypography.swift
    AppSpacing.swift
    AppRadius.swift
    AppShadows.swift
    ButtonStyles.swift
    Components/
      EmptyStateView.swift
      ErrorStateView.swift
      MetricCard.swift
      SectionHeader.swift

  Models/
    Vehicle.swift
    Reminder.swift
    Expense.swift
    ServiceRecord.swift
    PartChange.swift
    VehicleDocument.swift
    InspectionReport.swift
    SaleFile.swift
    Vendor.swift

  Services/
    NotificationService.swift
    PDFExportService.swift
    DocumentStorageService.swift
    ReminderScheduler.swift
    PaywallService.swift
    AnalyticsService.swift
    VehicleScoreService.swift

  Features/
    Onboarding/
    Garage/
    VehicleDetail/
    Reminders/
    Expenses/
    ServiceRecords/
    Documents/
    SaleFile/
    Reports/
    Settings/
    Paywall/

  Resources/
    Assets.xcassets
    Localizable.xcstrings
    PrivacyInfo.xcprivacy

  Tests/
    ModelTests/
    ServiceTests/
    UITests/
```

## 5. SwiftData modelleri

### Vehicle

```swift
@Model
final class Vehicle {
    var id: UUID
    var nickname: String
    var plate: String
    var brand: String
    var model: String
    var year: Int?
    var fuelType: FuelType
    var transmissionType: TransmissionType?
    var currentOdometer: Int
    var purchaseDate: Date?
    var purchasePrice: Decimal?
    var usageType: VehicleUsageType
    var notes: String
    var createdAt: Date
    var archivedAt: Date?
}
```

### Reminder

```swift
@Model
final class Reminder {
    var id: UUID
    var vehicleId: UUID
    var type: ReminderType
    var title: String
    var dueDate: Date?
    var dueOdometer: Int?
    var repeatRule: ReminderRepeatRule?
    var priority: ReminderPriority
    var status: ReminderStatus
    var completedAt: Date?
    var createdAt: Date
}
```

### Expense

```swift
@Model
final class Expense {
    var id: UUID
    var vehicleId: UUID
    var category: ExpenseCategory
    var amount: Decimal
    var currencyCode: String
    var date: Date
    var odometer: Int?
    var vendorName: String?
    var note: String
    var documentIds: [UUID]
    var createdAt: Date
}
```

### ServiceRecord

```swift
@Model
final class ServiceRecord {
    var id: UUID
    var vehicleId: UUID
    var date: Date
    var odometer: Int?
    var serviceType: ServiceType
    var vendorName: String?
    var laborCost: Decimal?
    var partsCost: Decimal?
    var totalCost: Decimal?
    var notes: String
    var createdAt: Date
}
```

### VehicleDocument

```swift
@Model
final class VehicleDocument {
    var id: UUID
    var vehicleId: UUID
    var type: DocumentType
    var title: String
    var localFileName: String
    var issueDate: Date?
    var expiryDate: Date?
    var vendorName: String?
    var linkedRecordId: UUID?
    var includeInSaleFile: Bool
    var createdAt: Date
}
```

### InspectionReport

```swift
@Model
final class InspectionReport {
    var id: UUID
    var vehicleId: UUID
    var providerName: String
    var branchName: String?
    var reportDate: Date
    var odometer: Int?
    var summary: String
    var documentId: UUID?
    var verificationStatus: VerificationStatus
    var createdAt: Date
}
```

### SaleFile

```swift
@Model
final class SaleFile {
    var id: UUID
    var vehicleId: UUID
    var title: String
    var includedSections: [SaleFileSection]
    var generatedPDFFileName: String?
    var createdAt: Date
}
```

## 6. Enumlar

- `FuelType`: gasoline, diesel, lpg, hybrid, electric
- `TransmissionType`: manual, automatic, semiAutomatic
- `VehicleUsageType`: personal, company, commercial
- `ReminderType`: inspection, insurance, casco, mtv, service, oil, tire, battery, timingBelt, brakes, warranty, hgs, custom
- `ReminderPriority`: info, warning, critical
- `ReminderStatus`: active, completed, overdue, archived
- `ExpenseCategory`: fuel, service, repair, part, tire, battery, insurance, casco, tax, inspection, emission, parking, toll, fine, wash, accessory, other
- `DocumentType`: registration, insurancePolicy, cascoPolicy, inspectionReport, emissionReport, expertReport, invoice, warranty, repairDocument, vehiclePhoto, other
- `ServiceType`: periodic, oil, tire, battery, brake, engine, transmission, body, electric, airConditioning, custom
- `VerificationStatus`: manual, pending, verified, rejected
- `SaleFileSection`: summary, serviceHistory, expenses, documents, inspectionReports, photos, notes, disclaimer

## 7. NotificationService

Sorumluluklar:

- Bildirim izni isteme.
- Reminder için local notification schedule etme.
- Tamamlanan/geçmiş reminder bildirimlerini iptal etme.
- Ön bildirim offsetleri:
  - 30 gün
  - 7 gün
  - 1 gün
  - aynı gün
- Km bazlı reminder için app açılışında currentOdometer kontrolü.

## 8. PDFExportService

MVP’de local PDF oluşturur.

PDF bölümleri:

1. Kapak
2. Araç özeti
3. Bakım geçmişi
4. Masraf özeti
5. Ekspertiz raporu özeti
6. Belgeler listesi
7. Hukuki uyarı

PDF dili sade ve güvenli olmalı:

> Bu dosya kullanıcı tarafından uygulamaya eklenen kayıt ve belgelerden oluşturulmuştur. Araç hakkında teknik, hukuki veya mekanik garanti anlamına gelmez.

## 9. DocumentStorageService

Belge yönetimi:

- Fotoğraf/PDF import.
- App sandbox içine güvenli kopyalama.
- Dosya isimlerini UUID ile saklama.
- Orijinal dosya adını metadata olarak tutma.
- Silinen kayıtta ilgili dosya temizleme.
- Büyük dosya boyutu uyarısı.

## 10. VehicleScoreService

Mekanik sağlık skoru değil, dosya tamlık skoru hesaplanacak.

Örnek kriterler:

- Araç temel bilgileri tamamlandı mı?
- Muayene tarihi var mı?
- Sigorta tarihi var mı?
- Son bakım kaydı var mı?
- En az bir belge var mı?
- Ekspertiz raporu var mı?
- Son km güncel mi?
- Gecikmiş hatırlatıcı var mı?

Adı:

- Dosya Tamlığı
- Bakım Takip Durumu
- Satış Dosyası Hazırlığı

Yasak:

- “Araç sağlığı %90”
- “Mekanik olarak iyi”
- “Sorunsuz araç”

## 11. Test stratejisi

Unit test:

- Reminder due date hesaplama.
- Overdue status.
- Dosya tamlık skoru.
- Expense toplamları.
- Km başı maliyet.
- PDF section inclusion.
- Enum mapping.
- Document cleanup.

UI test:

- İlk araç ekleme.
- İlk hatırlatıcı ekleme.
- Masraf ekleme.
- Belge ekleme.
- Satış PDF oluşturma.
- Pro limit/premium lock.
- Boş durumlar.

Manual test:

- Dark mode.
- Dynamic Type.
- VoiceOver.
- Bildirimler.
- PDF paylaşım.
- Abonelik restore.
- Offline kullanım.
- Uzun plaka/uzun model/uzun usta adı.

## 12. App Review risklerini azaltma

- Resmi kurum gibi görünme.
- TÜVTÜRK, Gelir İdaresi, sigorta şirketi logolarını izinsiz kullanma.
- “MTV öde” gibi işlem yapıyormuş hissi verme; sadece hatırlatma/yönlendirme varsa açık belirt.
- Ekspertiz raporu doğruluğunu garanti etme.
- Abonelik şartlarını net göster.
- Restore purchases linkini koy.
- Privacy policy aktif URL.
- Hesap/veri silme mekanizması.
- Belge yükleme için izin açıklamaları.

