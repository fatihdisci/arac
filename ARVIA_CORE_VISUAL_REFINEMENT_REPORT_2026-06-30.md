# Arvia Core Visual Refinement Report

Date: 2026-06-30  
Latest commit hash: `c67b5b4dcbe6868f26069922e0f29db92f4a542d`

## Files Changed

- `DesignSystem/AppSpacing.swift`
- `DesignSystem/Components/ArviaGuideCard.swift`
- `DesignSystem/Components/ContextualTipBanner.swift`
- `DesignSystem/Components/DosyaniTamamlaChecklist.swift`
- `DesignSystem/Components/QuickActionTile.swift`
- `Features/Garage/GarageView.swift`
- `Features/Reminders/TodosView.swift`
- `Features/Settings/SettingsView.swift`
- `Features/VehicleDetail/VehicleDetailView.swift`
- `Services/ReminderRepeatEngine.swift`
- `Services/VehicleInsightService.swift`
- `Tests/ModelTests.swift`

## Coming-Soon / Future Copy Removed

- Removed the production Settings roadmap section entirely.
- Removed the Vehicle Detail “Arvia Rehber Pro yakında” teaser entirely.
- Removed user-facing roadmap/teaser copy for advanced guide, document reading, QR/link, comparison, Business/Filo Lite, and future Pro plans.
- Reworded remaining product copy away from “gelecek / ileride / yakında” language where it could surface in UI.
- Kept current Pro positioning limited to multi-vehicle management.

## Quick Actions Refinement

- Added a compact `QuickActionRail.Style.compact` variant.
- Vehicle Detail now uses shorter labels: `Km`, `Masraf`, `Yakıt`, `Belge`, `Hatırlatıcı`.
- Reduced Vehicle Detail quick action height, icon size, background weight, and border intensity.
- Kept 44 pt minimum tap target behavior.
- Garage quick actions remain stronger dashboard actions via the default style.

## Arvia Rehber Refinement

- Made `ArviaGuideCard` more compact with lighter padding and softer tinting.
- Removed the repetitive “Rehber notu” label.
- Reduced vertical decoration and card height.
- Kept CTA and “Daha sonra” visible, but visually lighter.
- Existing max 3 guide behavior and guidance generation logic remain intact.

## Dosya Tamlığı Refinement

- Reduced progress ring size and stroke weight.
- Reduced green/tint intensity and removed the heavier dashboard-like shadow.
- Made the percentage treatment calmer and less toy-like.
- Kept completion chips, with lighter fills and tighter vertical padding.
- Kept the surface meaning as “Dosya Tamlığı”.

## Tab Bar Safe-Area Fix

- Added `AppSpacing.floatingTabBarContentInset`.
- Replaced ad hoc bottom spacer values in Garage and Vehicle Detail with the shared inset.
- Goal: enough bottom breathing room for the floating/native tab area without creating excessive empty space.

## Hero Contrast Changes

- Strengthened Garage hero image overlay with a more protective top-to-bottom gradient.
- Added subtle text shadows to vehicle label and name.
- Kept long vehicle names line-limited and scalable.
- Placeholder gradient remains intact and premium.

## Timeline Polish

- Lightly refined “Araç Yaşam Çizgisi”.
- Replaced plain dots with subtle SF Symbol timeline markers.
- Softened the card background and border.
- Long timelines now preview the latest 8 records with a short note.

## Tests Added / Updated

- Added `testVehicleInsightCopyDoesNotExposeRoadmapLanguage`.
- Existing tests continue to cover:
  - Garage daily context filtering.
  - Vehicle detail guide card cap behavior.
  - reminder de-duplication between upcoming tasks and guide.
  - Free/Pro behavior remaining unchanged.

## Build Result

Command:

```sh
xcodebuild -project VehicleDossierApp.xcodeproj -scheme Ruhsatim -destination 'platform=iOS Simulator,name=iPhone 17 Pro' -derivedDataPath /private/tmp/ArviaVisualRefinementDerivedData -clonedSourcePackagesDirPath /private/tmp/ArviaVisualRefinementSourcePackages build
```

Result: **BUILD SUCCEEDED**

## Test Result

Command:

```sh
xcodebuild -project VehicleDossierApp.xcodeproj -scheme Ruhsatim -destination 'platform=iOS Simulator,name=iPhone 17 Pro' -derivedDataPath /private/tmp/ArviaVisualRefinementDerivedData -clonedSourcePackagesDirPath /private/tmp/ArviaVisualRefinementSourcePackages test
```

Result: **TEST SUCCEEDED**  
Executed: **134 tests**  
Failures: **0**

## Manual Visual Notes

- Installed and launched the Debug simulator build on the booted iPhone 16 simulator.
- Verified the empty Garage production screen has no “yakında / gelecek / Pro yakında” roadmap messaging.
- Verified the tab bar does not cover the empty Garage CTA/content.
- Verified the empty Garage state remains clean, Turkish-first, and App Store safe.
- Code-reviewed the touched Garage hero, Vehicle Detail quick actions, Arvia Rehber, Dosya Tamlığı, and timeline surfaces after successful build.

## Known Limitations

- Manual simulator verification opened to an empty garage after reinstall, so populated Garage and Vehicle Detail visuals were not fully navigated in the simulator during this pass.
- Dark mode and Dynamic Type were validated by code structure/build safety, not by a full simulator screenshot matrix in this pass.
- No monetization, notification routing, backend, OCR, AI, ads, or networking behavior was changed.

