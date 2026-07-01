# Arvia Raporlar — Visual Iteration Report

**Date:** 2026-07-01  
**Project:** Arvia — VehicleDossierApp (Ruhsatim)  
**Focus:** Raporlar (Reports) screen visual iteration — ownership cost dashboard, not generic finance  
**Base commit:** `da74577`  
**Latest commit:** `63cc5fb`

---

## Latest Commit

```
63cc5fb
refactor: reports screen visual iteration (filters, hero metric, 
         cards, charts, empty state)
```

## Files Changed

| File | Change |
|------|--------|
| `Features/Reports/ReportsView.swift` | **270 lines** — supporting copy, filter chips, empty state, section headers, card borders, layout rhythm |
| `DesignSystem/Components/OwnershipInsightCard.swift` | **40 lines** — PremiumMetricHero (sparkles removal, border instead of shadow, padding) + OwnershipInsightCard (height de-fixed, typography) |

No other files modified. Components only used by ReportsView (verified via grep).

---

## 1. Header / Screen Identity

**Before:** `.navigationTitle("Raporlar")` with no context.

**After:** Same native title + compact supporting copy:
> "Aracının yıllık masrafını, kategori dağılımını ve maliyet ritmini gör."

Placed above filters as a calm intro row. Uses `AppTypography.secondary` + `AppColors.textSecondary`.

---

## 2. Root Background Fix

**Before:** `.background(Color.appBackground)` — top nav area fell to system white/black.

**After:** `.background(Color.appBackground.ignoresSafeArea())` — consistent app background from nav bar to bottom, both light and dark modes.

---

## 3. Filter Selectors

**Before:** Plain `Picker(.menu)` with `.tint(AppColors.accentPrimary)` — looked like random text buttons.

**After:** Menu-based filter chips wrapped in capsule backgrounds:
- **Vehicle filter:** `[car.icon] Tüm Araçlar [chevron]` in `backgroundSecondary` capsule; turns `accentPrimary.opacity(0.1)` when a specific vehicle is selected
- **Year filter:** `2026 [chevron]` in `accentPrimary.opacity(0.1)` capsule
- Both use `AppTypography.captionMedium` + 4pt icon-cheat gap
- Active menu item shows checkmark indicator

Both filters maintain full `.menu` picker accessibility. No clipped labels.

---

## 4. Premium Metric Hero (`PremiumMetricHero`)

**Label copy refined:**
- Before: "Bu yıl aracın sana" (implied "...maliyet çıkardı" which was never shown)
- After: "Bu yılki toplam masraf" (calm, declarative, complete sentence)

| Change | Before | After |
|--------|--------|-------|
| Insight icon | `sparkles` emoji icon | Removed — clean text only |
| Shadow | `.elevatedShadow()` | Border overlay (`.stroke(AppColors.border.opacity(0.45))`) |
| Vertical padding | `AppSpacing.xl` (32pt) | `AppSpacing.lg` (24pt) |
| Hero value font | `.heroNumberStyle()` (40pt light) | Unchanged — already correct |
| Vehicle context | Unchanged | Unchanged |

The sparkles emoji was an AI/flashy decoration ("✨ Geçen yıla göre %12 daha az") that contradicted the calm/premium/trustworthy design goal.

---

## 5. Ownership Insight Cards (`OwnershipInsightCard`)

| Change | Before | After |
|--------|--------|-------|
| Card height | Fixed 110pt (`frame(height: 110, minHeight: 110)`) | Natural height — `frame(maxWidth: .infinity, alignment: .leading)` |
| Value font | 17pt bold rounded (`design: .rounded`) | **18pt semibold** (no rounded design) |
| Placeholder text | `" "` when subtitle nil | No placeholder — VStack compresses naturally |
| Subtitle font | `system(size: 10)` | **`AppTypography.caption`** (12pt) |

The `.rounded` font design gave a finance-template feel ("₺12.750" in rounded digits). Replaced with clean 18pt semibold — more appropriate for automotive ownership context. Removing the fixed height lets cards size to content and avoids the cramped look when Dynamic Type is active.

---

## 6. Section Card Containers

**Before:** Section cards (monthly chart, category, top expenses, sale file CTA) used `.subtleShadow()`.

**After:** Replaced with consistent border overlay pattern:
```swift
.overlay(
    RoundedRectangle(cornerRadius: AppRadius.card, style: .continuous)
        .stroke(AppColors.border.opacity(0.45), lineWidth: 0.5)
)
```

This matches the approach used in Garage, History, and VehicleDetail hero cards — no mismatched shadow conventions across the app.

---

## 7. Section Headers with Context

**Before:** Plain `SectionHeader(title:)` — functional but no narrative.

**After:** Inline `HStack` headers with calm context lines:

| Section | Title | Context |
|---------|-------|---------|
| Monthly chart | "Aylık Dağılım" | "Aylara göre harcama akışı" |
| Category | "Kategori Dağılımı" | "Kategori bazında dağılım" |
| Top expenses | "En Yüksek Masraflar" | "Bu yılın en büyük 5 gideri" |

Context lines use `AppTypography.caption` + `AppColors.textTertiary` — informational without dominating.

---

## 8. Category Section Refinements

- Progress bar height: 4pt → **5pt** (slightly more visible)
- Progress bar opacity: 0.6 → **0.55** (subtle)
- Category icon frame: 20pt → **22pt** (better alignment with 12pt text)
- Row spacing: `.xs` → **`.sm`** (12pt between category rows)
- Empty state: "Bu yıl için veri yok." → icon + text HStack for more visual presence

---

## 9. Top Expenses Refinements

- Row vertical padding: `.xs` → **`.sm`** for better rhythm
- Vendor name: added `.lineLimit(1)` safety
- Empty state: added icon + text HStack (was plain text)

---

## 10. Empty State

**Before:**
- Title: "İlk masraf kaydını ekle"
- CTA: `nil` (no action button)
- Description: "Masraf ve bakım kayıtları ekledikçe yıllık toplam, kategori dağılımı ve km başı maliyet burada görünür."

**After:**
- Title: **"Henüz rapor oluşmadı"**
- CTA: **"Masraf Ekle"** → opens `ExpenseFormView`
- Description: "Masraf ve bakım kayıtları ekledikçe aracının maliyet özeti burada oluşur."

Added `showAddExpense` state variable and `.sheet(isPresented:)` to support the CTA.

---

## 11. Layout / Vertical Rhythm

- Filter-to-hero spacing: unchanged (`AppSpacing.lg`)
- Hero-to-cards: unchanged
- Card grid spacing: unchanged (`AppSpacing.sm`)
- Chart/category/top section gaps: unchanged (`AppSpacing.lg`)
- Bottom tab bar safe area: unchanged (`floatingTabBarContentInset`)
- ScrollView bottom padding: unchanged

No new spacing regressions.

---

## 12. Preview States

| File | Preview | Status |
|------|---------|--------|
| `ReportsView.swift` | "Raporlar — Dolu" | ✅ Compiles |
| `ReportsView.swift` | "Raporlar — Dark Mode" | ✅ Compiles |
| `ReportsView.swift` | "Raporlar — Dynamic Type" | ✅ Compiles |
| `OwnershipInsightCard.swift` | "Insight Cards" | ✅ Compiles |
| `OwnershipInsightCard.swift` | "Insight Cards — Dark" | ✅ Compiles |

---

## 13. Build Result

```
** BUILD SUCCEEDED **
```

- Scheme: `Ruhsatim`
- SDK: `iphonesimulator` (iOS 17.0)
- No warnings introduced

---

## 14. Test Result

```
Test Suite 'All tests' passed
     Executed 149 tests, with 0 failures (0 unexpected) in 0.193 (0.274) seconds
```

All 149 tests passed. No regressions.

---

## 15. What Was NOT Changed

- **Report calculations** — yearly total, monthly data, category percentage, km cost, year trend, all computed properties untouched
- **Data models** — Expense, Vehicle, ExpenseCategory unchanged
- **Charts framework** — same Swift Charts BarMark approach
- **Other screens** — Garage, VehicleDetail, Todos, History, Community, Settings, Paywall untouched
- **Business logic** — no new features, no AI, no backend changes
- **English labels** — none added

---

## Known Limitations

- **SourceKit diagnostics** show "Cannot find type" errors for `Expense`, `Vehicle`, `AppSpacing`, `AppTypography`, `AppColors`, etc. These are background indexing false positives — actual `xcodebuild` compilation and test execution both succeed.
- **SectionHeader** component uses `LocalizedStringKey` — not modified in this pass as it's a cross-component concern.
- **OwnerInsight cards** no longer have equal heights across the grid row. Since the LazyVGrid uses `.flexible()` columns, cards size to their content. The subtitle-less "Km Başı Maliyet" card is slightly shorter than cards with subtitles. This is intentional — fixed 110pt height caused compression issues with Dynamic Type.
- **PremiumMetricHero** removed the `sparkles` insight icon. The year-trend comparison text still renders cleanly as caption text.
