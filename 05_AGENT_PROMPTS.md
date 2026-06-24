# Agent Prompts

Bu dosya coding agentına doğrudan verilecek promptları içerir.

## 1. Master one-shot prompt

```text
You are building an iOS-only SwiftUI app for a premium car ownership management product.

Product concept:
This is not a simple car expense tracker. It is a digital life dossier for a vehicle: maintenance history, expenses, documents, inspection reports, reminders, and a shareable sale trust file.

Language:
The app UI will be Turkish-first.

Tech:
- SwiftUI
- SwiftData
- iOS 17+
- Local-first
- Optional CloudKit later
- UserNotifications
- PhotosUI
- VisionKit for document scanning
- PDFKit/custom PDF generation
- Charts
- RevenueCat or StoreKit 2 later

Before writing code, read and obey:
- 01_DESIGN.md
- 02_PRODUCT_SCOPE.md
- 03_SWIFTUI_ARCHITECTURE.md
- 04_AGENT_PHASE_PLAN.md

Critical design rules:
- No generic AI SaaS look.
- No blue-purple decorative gradients.
- No random card mosaics.
- No emoji UI.
- No raw colors, spacing, radius values in feature views.
- Use DesignSystem tokens.
- Use native SwiftUI conventions.
- Support dark mode and Dynamic Type.
- Every major screen must have empty/loading/error states.
- Haptics and motion only where they add meaning.
- The app must feel premium, calm, trustworthy, and Apple-native.

Critical product rules:
- Do not claim mechanical diagnosis.
- Use “Dosya Tamlığı” or “Bakım Takip Durumu”, not “Araç sağlığı”.
- Do not imply official government affiliation.
- Do not use official institution logos without permission.
- Inspection reports are user-uploaded/manual unless partner verification exists.
- Sale file must include a disclaimer.

Development style:
- Work phase by phase.
- After each phase, run build/tests if possible.
- Report changed files, build status, tests, known issues, and next recommended phase.
- Do not modify business logic unrelated to the current phase.
- Keep code modular and testable.

Start with Phase 0 from 04_AGENT_PHASE_PLAN.md.
```

## 2. Phase 0 prompt — DesignSystem

```text
Implement Phase 0: project skeleton and DesignSystem.

Read 01_DESIGN.md carefully and create a SwiftUI-native design system.

Tasks:
1. Create DesignSystem folder.
2. Add tokens:
   - AppColors
   - AppTypography
   - AppSpacing
   - AppRadius
   - AppShadows if needed
3. Add reusable styles:
   - PrimaryButtonStyle
   - SecondaryButtonStyle
   - DestructiveButtonStyle
4. Add reusable components:
   - EmptyStateView
   - ErrorStateView
   - SectionHeader
   - MetricCard
5. Create placeholder 5-tab navigation:
   - Garaj
   - İşler
   - Kayıtlar
   - Belgeler
   - Raporlar
6. Ensure dark mode and Dynamic Type friendliness.
7. Do not use raw colors/spacing/radius in feature views.
8. Add previews with realistic Turkish text.

Acceptance:
- Build passes.
- App opens to tab navigation.
- DesignSystem components compile.
- No generic AI gradient/card mosaic.
- Output a concise report with changed files and test/build status.
```

## 3. Phase 1 prompt — Models

```text
Implement Phase 1: SwiftData models.

Create the app's data foundation using SwiftData.

Models:
- Vehicle
- Reminder
- Expense
- ServiceRecord
- PartChange
- VehicleDocument
- InspectionReport
- SaleFile
- Vendor if useful

Enums:
- FuelType
- TransmissionType
- VehicleUsageType
- ReminderType
- ReminderPriority
- ReminderStatus
- ExpenseCategory
- DocumentType
- ServiceType
- VerificationStatus
- SaleFileSection

Requirements:
- Use stable UUID ids.
- Add createdAt dates.
- Keep fields MVP-focused but extensible.
- Add mock fixtures for previews.
- Add basic unit tests for model creation and simple computed helpers if applicable.

Acceptance:
- Build passes.
- SwiftData container works.
- Preview mock data works.
- No UI redesign beyond what is necessary.
- Report changed files, tests, and known issues.
```

## 4. Phase 2 prompt — Onboarding and vehicle creation

```text
Implement Phase 2: onboarding and first vehicle creation.

Goal:
A first-time user can create their first vehicle dossier quickly.

Requirements:
- If no vehicle exists, show a premium EmptyStateView:
  Title: "İlk aracının dosyasını oluşturalım"
  Body: "Muayene, sigorta, bakım ve belgeleri tek yerde takip etmek için aracını ekle."
  CTA: "Araç Ekle"
- Vehicle creation form:
  - Plaka
  - Marka
  - Model
  - Yıl
  - Güncel km
  - Yakıt tipi
  - Kullanım tipi
  - Optional nickname
  - Optional photo placeholder; real photo can be later if needed
- Optional first important dates:
  - Muayene
  - Trafik sigortası
  - Kasko
  - Son bakım tarihi/km
- Validate required fields.
- Use Turkish copy.
- On success, save with SwiftData and show success haptic if available.
- Return user to Garage screen showing VehicleCard.

Design:
- Follow 01_DESIGN.md.
- No raw tokens.
- Native form/sheet conventions.
- Dynamic Type and dark mode.

Acceptance:
- User can add vehicle.
- Vehicle persists.
- Empty state disappears.
- Form errors are clear.
- Build passes.
```

## 5. Phase 3 prompt — Garage and Vehicle Detail

```text
Implement Phase 3: Garage and Vehicle Detail dashboard.

Goal:
Make the vehicle the emotional and functional center of the app.

Requirements:
- VehicleCard in Garage.
- Vehicle detail screen with:
  - VehicleHeroHeader
  - Plate, brand, model, year, current km
  - Upcoming most important task placeholder
  - File completeness score card
  - Recent records placeholder
  - Vehicle Life Timeline placeholder
- Add edit vehicle flow.
- Add archive/delete with confirmation.

Design:
- One clear visual anchor per screen.
- Premium, calm, Apple-native.
- No generic dashboard card mosaic.
- Use cards only when meaningful.
- Dark mode and Dynamic Type.

Acceptance:
- Vehicle card navigates to detail.
- Detail shows real vehicle data.
- Edit works.
- Delete/archive protected by confirmation.
- Build passes.
```

## 6. Phase 4 prompt — Reminders

```text
Implement Phase 4: reminder system.

Goal:
Users can track muayene, trafik sigortası, kasko, MTV and maintenance dates.

Requirements:
- Reminder list screen grouped by:
  - Gecikenler
  - Bugün
  - Yaklaşanlar
  - Daha Sonra
- Add reminder flow:
  - Template selection
  - Due date
  - Due odometer optional
  - Repeat rule optional
  - Priority
- Templates:
  - Muayene
  - Trafik Sigortası
  - Kasko
  - MTV 1. Taksit
  - MTV 2. Taksit
  - Periyodik Bakım
  - Yağ Değişimi
  - Lastik
  - Akü
  - Triger
  - Fren
  - Garanti
  - HGS
  - Diğer
- Reminder status calculation.
- Complete reminder action.
- Local notification scheduling via NotificationService.
- Permission pre-prompt explaining this is for important vehicle dates, not ads.

Design:
- Warning/critical colors only through tokens.
- Clear copy.
- No fearmongering.

Acceptance:
- Reminder can be created.
- Reminder appears in correct group.
- Complete action works.
- Notification scheduling does not crash.
- Unit tests for status calculation.
```

## 7. Phase 5 prompt — Expenses

```text
Implement Phase 5: expense tracking.

Goal:
Users can record vehicle expenses and see basic totals.

Requirements:
- Expense list by vehicle and global Records tab.
- Add expense form:
  - Category
  - Amount
  - Currency TRY default
  - Date
  - Odometer optional
  - Vendor optional
  - Note optional
- Categories:
  Yakıt, Bakım, Tamir, Parça, Lastik, Akü, Sigorta, Kasko, MTV, Muayene, Egzoz Emisyon, Otopark, HGS/OGS, Ceza, Yıkama, Aksesuar, Diğer
- Show totals:
  - This year total
  - This month total
  - By category placeholder or simple list
- Empty state with CTA.

Design:
- Money values must feel trustworthy and readable.
- Use locale-aware TRY formatting.
- No vague errors.

Acceptance:
- Add/edit/delete expense.
- Totals update.
- Vehicle detail shows recent expenses.
- Build/tests pass.
```

## 8. Phase 6 prompt — Service Records

```text
Implement Phase 6: service records and changed parts.

Goal:
Maintenance history should feel like a vehicle life record, not just an expense list.

Requirements:
- ServiceRecord list.
- Add service record:
  - Service type
  - Date
  - Odometer
  - Vendor/service name
  - Labor cost
  - Parts cost
  - Total cost
  - Notes
  - Changed parts list
- PartChange editor:
  - Part type
  - Brand/model optional
  - Warranty optional
- Option to create next reminder after saving service.
- Vehicle Life Timeline should include service records.

Design:
- Timeline is the product's signature interaction.
- Premium and calm, not noisy.

Acceptance:
- Service record saved.
- Changed parts saved.
- Timeline displays service events.
- Optional next reminder flow works or is clearly marked as coming soon.
```

## 9. Phase 7 prompt — Documents

```text
Implement Phase 7: document vault.

Goal:
Users can store vehicle-related documents and include them in the sale file.

Requirements:
- Document list grouped by type.
- Add document:
  - Type
  - Title
  - File/photo import
  - Issue date optional
  - Expiry date optional
  - Vendor optional
  - Include in sale file toggle
- Support PhotosUI.
- Support PDF import.
- Add VisionKit scanner if available and simple.
- DocumentStorageService copies files into app storage with UUID names.
- Preview document.
- Delete document and clean file.

Document types:
Ruhsat, Trafik Sigortası, Kasko, Muayene Raporu, Egzoz Emisyon, Ekspertiz Raporu, Servis Faturası, Parça Faturası, Garanti Belgesi, Hasar/Onarım, Araç Fotoğrafı, Diğer.

Acceptance:
- User can add and preview document.
- Document is linked to vehicle.
- Include in sale file toggle persists.
- Errors are clear.
- Build passes.
```

## 10. Phase 8 prompt — Inspection Reports

```text
Implement Phase 8: inspection reports.

Goal:
Expertise reports become a first-class feature and a future partner integration point.

Requirements:
- Add InspectionReport screen.
- Fields:
  - Provider name
  - Branch name
  - Report date
  - Odometer
  - Summary
  - Linked document
  - Verification status: Manual by default
  - Include in sale file
- Add legal copy:
  "Bu rapor kullanıcı tarafından eklenmiştir. Uygulama rapor içeriğinin doğruluğunu garanti etmez."
- Vehicle detail should show latest inspection report card.
- Sale file can include inspection report summary.

Acceptance:
- Manual inspection report can be added.
- Linked document works.
- Legal warning visible.
- No claim of verification unless status verified exists.
```

## 11. Phase 9 prompt — Reports

```text
Implement Phase 9: reports.

Goal:
Show users the cost of owning each vehicle.

Requirements:
- Reports tab:
  - Yearly total
  - Monthly spending chart
  - Category breakdown
  - Cost per km if odometer data exists
  - Top expenses
- Vehicle-level reports.
- Empty state if no data.
- Use Charts.
- Currency formatting for Turkish locale.

Design:
- Calm, readable, not dashboard chaos.
- Avoid too many competing cards.
- One primary metric at top.

Acceptance:
- Reports calculate correctly.
- Charts readable in dark mode.
- Empty state works.
- Unit tests for calculations.
```

## 12. Phase 10 prompt — Sale File PDF

```text
Implement Phase 10: sale file PDF export.

Goal:
Create the app's main differentiation: a shareable vehicle sale trust file.

Requirements:
- Sale file creation flow:
  - Select sections
  - Select documents
  - Include latest inspection report
  - Include maintenance summary
  - Include expense summary optional
  - Include vehicle photos optional
- Generate PDF:
  - Cover
  - Vehicle summary
  - Maintenance history
  - Inspection reports
  - Included documents list
  - Disclaimer
- Preview PDF.
- Share PDF.
- Add disclaimer:
  "Bu dosya kullanıcı tarafından uygulamaya eklenen kayıt ve belgelerden oluşturulmuştur. Araç hakkında teknik, hukuki veya mekanik garanti anlamına gelmez."
- Paywall gate if required by plan.

Design:
- PDF must look premium and trustworthy.
- Avoid decorative clutter.
- Use clear hierarchy.

Acceptance:
- PDF generated.
- PDF preview works.
- Share sheet works.
- Disclaimer included.
- Build passes.
```

## 13. Phase 11 prompt — Paywall

```text
Implement Phase 11: Pro monetization.

Goal:
Add ethical freemium paywall.

Free limits:
- 1 vehicle
- Limited documents
- Basic reminders
- Basic expense tracking
- Limited sale file generation if desired

Pro:
- Unlimited vehicles
- Unlimited documents
- Sale file PDF/export
- Advanced reports
- Inspection report archive
- CSV/PDF export future

Requirements:
- RevenueCat or StoreKit 2 integration.
- Product loading.
- Purchase.
- Restore purchases.
- Subscription state.
- Paywall copy in Turkish.
- "İstediğin zaman iptal edebilirsin."
- No dark patterns.
- Paywall appears at value moments, not first launch.

Acceptance:
- Free limits work.
- Pro unlock works in sandbox.
- Restore purchases visible.
- App Review-safe copy.
```

## 14. Final QA prompt

```text
Run final QA and review hardening.

Check:
- Build pass.
- Unit tests pass.
- No raw design tokens in feature views.
- Dark mode.
- Dynamic Type.
- VoiceOver labels.
- Reduce Motion.
- Empty/loading/error states.
- Local notifications.
- Document import/delete.
- PDF generation/share.
- Paywall restore.
- Privacy/terms links.
- No official institution implication.
- No mechanical diagnosis claims.
- No AI-slop visual patterns.

Output:
1. Pass/fail checklist.
2. Critical issues.
3. High issues.
4. Medium issues.
5. Recommended App Store review notes.
```

