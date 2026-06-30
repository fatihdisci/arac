# ARVIA DAILY CONTEXTUAL UTILITY REPORT - 2026-06-30

## Latest Commit Hash

`e397f94d935c24beaa9ce12ee648ef601a459ed6`

Not: Bu rapor hazırlanırken değişiklikler çalışma ağacında, henüz commit edilmemiş durumdadır.

## Files Changed

- `DesignSystem/Components/ArviaGuideCard.swift`
- `Features/Expenses/ExpenseFormView.swift`
- `Features/Garage/GarageView.swift`
- `Features/Reminders/ReminderFormView.swift`
- `Features/VehicleDetail/VehicleDetailView.swift`
- `Features/VehicleDetail/VehicleEditView.swift`
- `Models/VehicleInsight.swift`
- `Services/RetentionNotificationService.swift`
- `Services/VehicleInsightService.swift`
- `Tests/ModelTests.swift`

## What Was Implemented

- Local, rule-based daily/weekly contextual utility layer for Arvia.
- Garage dashboard section: `Bugün Garajında`.
- Garage and Vehicle Detail quick actions for frequent use.
- Lightweight `Kilometreyi Güncelle` sheet.
- Vehicle Detail mini cards: `Bu Ay` and `Sıradaki İşler`.
- Extended Arvia Rehber rule types and CTA routing.
- Safe fuel, transmission, odometer, season, and MTV period guidance.
- Explicit odometer update refresh path via `VehicleContextRefreshService`.

No AI, backend, OCR, networking, API key, remote push, ad, or monetization change was added.

## Km Update Recalculation Behavior

- `QuickOdometerUpdateSheet` validates and saves `vehicle.currentOdometer`.
- Save path calls `VehicleContextRefreshService.updateCurrentOdometer`.
- The refresh path saves SwiftData changes and calls notification refresh logic.
- Km-based reminders remain computed from current local odometer through existing `Reminder.isKmOverdue` and `isKmUpcoming`.
- Todos/Reminders visibility updates because reminder rows and insight generation read the updated `vehicle.currentOdometer`.
- Arvia Rehber, `Bugün Garajında`, `Sıradaki İşler`, file score, and monthly/context cards refresh through SwiftData query invalidation.
- Vehicle edit now uses `VehicleContextRefreshService.refreshAfterVehicleContextChange`.

## New UI Sections

- Garage: `Bugün Garajında`
- Garage: updated `Hızlı İşlemler`
- Vehicle Detail: `Hızlı İşlemler`
- Vehicle Detail: `Bu Ay`
- Vehicle Detail: `Sıradaki İşler`
- Shared compact contextual card for calm daily recommendations.

## Bugün Garajında Behavior

Shows up to 3 cards from local data, ordered by:

1. Overdue date/km reminders
2. Today/tomorrow/upcoming reminders
3. MTV calendar period
4. Odometer update
5. Season suggestion
6. Missing records/documents/profile suggestions
7. Monthly expense prompt
8. Quiet good state

Quiet state copy:

`Her şey yolunda görünüyor. Yeni masraf, belge veya km bilgisi eklemek istersen hızlı işlemleri kullanabilirsin.`

## Quick Actions Behavior

Garage and Vehicle Detail now expose:

- `Km Güncelle`
- `Masraf Ekle`
- `Yakıt Ekle`
- `Belge Ekle`
- `Hatırlatıcı Ekle`

Existing sheets/forms are reused. `Yakıt Ekle` safely preselects `.fuel`.

## Quick Km Update Behavior

- Title: `Kilometreyi Güncelle`
- Shows current km and new km input.
- Helper copy: `Güncel kilometre, bakım ve masraf takibini daha doğru hale getirir.`
- Empty, invalid, and negative values show Turkish errors.
- Equal/higher km saves directly.
- Lower km requires explicit confirmation.
- Save triggers success haptic and refresh path.
- Km notification vehicle detail CTA now opens the quick km sheet.

## Bu Ay Monthly Summary Behavior

- Shows total current-month expenses in TRY.
- Shows number of current-month expense records.
- Shows top category when available.
- CTA: `Masraf Ekle`.
- Empty state: `Bu ay henüz masraf kaydı yok.`

## Sıradaki İşler Behavior

- Shows up to 3 active reminders.
- Priority order: overdue date/km, today/tomorrow, upcoming.
- Relative texts include `Bugün`, `Yarın`, `7 gün kaldı`, `Km sınırı geçti`, `Gecikti`.
- CTA: `Tümünü Gör`, routed to Todos tab.

## New Rule Categories

- `fuelTypeRules`
- `transmissionRules`
- `odometerRules`
- `seasonRules`
- `calendarRules`
- `recordCompletenessRules`

Implemented through extended `VehicleInsightService` insight generation.

## Fuel / Transmission / Odometer / Season / Calendar Rules

- Diesel: safe oil/filter/fuel-filter record tracking suggestion.
- Gasoline: safe oil/filter/spark-plug record tracking suggestion.
- LPG: safe LPG system/filter expert-service record tracking suggestion.
- Hybrid/Electric: safe system/battery-related record keeping suggestion.
- Automatic: safe transmission maintenance history suggestion.
- Manual: safe clutch-related maintenance/expense record suggestion.
- Semi-automatic: safe transmission/clutch system record suggestion.
- Odometer milestones: local thresholds at 10k, 15k, 20k, 30k, 60k, 90k, 120k with cautious copy.
- Season guidance: Turkey-oriented winter, spring, summer, autumn suggestions.
- MTV: January/July period awareness only, no official deadline or payment claim.

## CTA Routing Behavior

- `Km Güncelle` -> `QuickOdometerUpdateSheet`
- `Hatırlatıcı Ekle` -> existing `ReminderFormView`
- `MTV Hatırlatıcısı Ekle` -> existing `ReminderFormView` with MTV template
- `Bakım Kaydı Ekle` -> existing `ServiceRecordFormView`
- `Masraf Ekle` -> existing `ExpenseFormView`
- `Yakıt Ekle` -> existing `ExpenseFormView` with fuel category
- `Belge Ekle` -> existing `DocumentFormView`
- `Yapılacaklara Git` / `Tümünü Gör` -> Todos tab

## Safety Copy

Existing Rehber disclaimer remains:

`Arvia Rehber, araç kayıtlarına göre genel öneriler sunar. Teknik teşhis, ekspertiz veya servis görüşü yerine geçmez.`

MTV copy avoids `resmi`, `öde`, and `garanti`.

## Free / Pro Impact

- No monetization change.
- Free first vehicle remains unlocked.
- Free users still cannot add a second active vehicle.
- Pro users can add additional vehicles.
- Existing MVP features were not moved behind Pro.

## Tests Added / Updated

Added/updated tests for:

- Empty daily summary safety.
- Overdue before upcoming priority.
- Km update refresh path.
- Km-based reminder overdue behavior via existing reminder tests.
- Upcoming reminder within 14 days.
- Monthly expense prompt.
- Monthly summary total.
- Quick km validation.
- Fuel type diesel safe guidance.
- Transmission automatic safe guidance.
- Current season guidance.
- MTV January/July guidance.
- MTV forbidden copy words.
- Insight cap at 3.
- Overdue before seasonal/calendar priority.
- Existing Free/Pro policy remains unchanged.

## Build Result

Passed.

Command:

`xcodebuild -project VehicleDossierApp.xcodeproj -scheme Ruhsatim -destination 'platform=iOS Simulator,name=iPhone 16' -derivedDataPath /private/tmp/ArviaDerivedData build`

Result: `BUILD SUCCEEDED`

## Test Result

Passed.

Command:

`xcodebuild -project VehicleDossierApp.xcodeproj -scheme Ruhsatim -destination 'platform=iOS Simulator,name=iPhone 16' -derivedDataPath /private/tmp/ArviaDerivedData test`

Result: `TEST SUCCEEDED`

Executed 129 tests, 0 failures.

## Manual iPhone Checklist

- Garage shows `Bugün Garajında`: implemented, needs physical-device visual pass.
- Cards feel useful but not noisy: max 3 enforced, needs physical-device visual pass.
- Quick actions open existing flows: implemented; simulator launch smoke passed.
- Km Güncelle sheet updates vehicle km: implemented and unit-tested.
- Invalid km input shows Turkish error: implemented and unit-tested.
- Odometer update changes km-based reminder visibility: rule path tested; full UI pass needed.
- Vehicle detail shows `Bu Ay`: implemented.
- Vehicle detail shows `Sıradaki İşler`: implemented.
- Arvia Rehber maxes at 3 cards: tested.
- MTV card appears only in January/July: tested.
- Seasonal card appears by current season: tested.
- Fuel/transmission guidance uses safe wording: tested.
- Dark mode looks clean: needs physical-device visual pass.
- Dynamic Type does not break quick actions/cards: needs physical-device visual pass.
- VoiceOver labels are meaningful: labels added/reused, needs physical-device accessibility pass.
- No official institution, diagnosis, or chronic failure language: copy reviewed and tested for MTV forbidden words.
- Free/Pro behavior unchanged: tested.

Simulator smoke:

- Installed `/private/tmp/ArviaDerivedData/Build/Products/Debug-iphonesimulator/Ruhsatim.app`
- Launched bundle `com.ruhsatim.app`
- Launch succeeded with process id `72077`

## Known Limitations

- No real background odometer update exists; Arvia only knows km after user entry.
- MTV guidance is month-period awareness only, not an official deadline or payment flow.
- No brand/model chronic issue data was added.
- No physical iPhone, Dark Mode, Dynamic Type, or VoiceOver manual pass was performed in this environment.
- Rare sale/service flows were intentionally left untouched.

## Recommended Next Phase

- Add a small local editable rules table UI only if rule maintenance becomes necessary.
- Add screenshot/UI tests for Garage and Vehicle Detail daily utility surfaces.
- Add physical-device QA pass for Dark Mode, Dynamic Type, and VoiceOver before App Store submission.
- Later, consider richer document-specific reminders from user-entered expiry dates only.
