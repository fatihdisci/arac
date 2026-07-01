# Arvia Xcode Preview Workflow Report — 2026-07-01

## Files Changed
- `Models/MockDataProvider.swift`
- `DesignSystem/Components/VehicleCard.swift`
- `Features/Garage/GarageView.swift`
- `Features/VehicleDetail/VehicleDetailView.swift`
- `Features/Reminders/TodosView.swift`
- `Features/Records/HistoryView.swift`
- `Features/Reports/ReportsView.swift`
- `Features/Community/CommunityFeedView.swift`
- `Features/Settings/SettingsView.swift`
- `Features/Paywall/PaywallView.swift`

## Preview Seed Data
- Centralized preview-only seed data in `MockDataProvider`.
- Added 3 deterministic vehicles.
- Aligned `previewVehicle()` IDs with the populated SwiftData preview container.
- Added reminder coverage for upcoming date, km-based, later, overdue, and another vehicle.
- Kept realistic expenses, service records, part changes, document metadata, inspection report, and sale file sample.
- Added mock community posts for feed previews without Supabase/network access.
- Fixed invalid mock UUID strings that could crash previews.

## Previews Added or Fixed
- Garage: empty, populated, dark mode, Dynamic Type.
- Vehicle Detail: populated, dark mode, Dynamic Type.
- Todos: empty, populated, dark mode, Dynamic Type.
- History: populated, dark mode.
- Reports: populated, dark mode, Dynamic Type.
- Community Feed: signed out, config missing, populated mock feed, populated dark mode.
- Settings: light and dark.
- Paywall: light and dark.

## How To Open In Xcode
1. Open `VehicleDossierApp.xcodeproj`.
2. Open the target screen file, for example `Features/Garage/GarageView.swift`.
3. Open Canvas with Editor > Canvas.
4. Select the named preview from the Canvas preview picker.
5. Use an iPhone simulator/device size in Canvas, such as iPhone 16, for page-by-page visual iteration.

## Build Result
- Passed:
  `xcodebuild -quiet -project VehicleDossierApp.xcodeproj -scheme VehicleDossierApp -destination 'generic/platform=iOS Simulator' -derivedDataPath /private/tmp/ArviaPreviewWorkflowDerivedData build`

## Test Result
- Passed:
  `xcodebuild -quiet -project VehicleDossierApp.xcodeproj -scheme VehicleDossierApp -destination 'platform=iOS Simulator,name=iPhone 16' -derivedDataPath /private/tmp/ArviaPreviewWorkflowDerivedData test`

## Known Limitations
- Preview seed vehicle photos intentionally fall back to the existing placeholder UI; no production photo files are injected.
- Community populated preview uses explicit mock posts and does not validate live auth, Supabase config, moderation, or network behavior.
- This task did not redesign UI. It only prepared safer Canvas-driven iteration points.
