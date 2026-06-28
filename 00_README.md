# Arvia — Araç Dijital Dosyası

**Aracının dijital yaşam dosyası.**

SwiftUI iOS uygulaması. Otomobil ve motosiklet için bakım, masraf, belge, ekspertiz ve satış güven dosyasını tek yerde tutar.

**Son güncelleme:** 27 Haziran 2026
**Durum:** TestFlight öncesi final düzeltmeler tamamlandı. Supabase SQL manuel çalıştırma gerekiyor.
**Kapsam:** Otomobil + Motosiklet desteği, Topluluk (Supabase), StoreKit 2 Paywall, 89 unit test

## Hızlı Başlangıç

1. `Config.xcconfig` oluştur (bkz. `Configuration/Config.example.xcconfig`)
2. Xcode'da Sign in with Apple capability'yi aktif et
3. Supabase'te `docs/SUPABASE_FINAL_DEPLOY.sql` çalıştır
4. Debug build al → çalıştır

## Tab Yapısı

| Tab | İkon | İçerik |
|-----|------|--------|
| Garaj | `car` | Ana ekran: araç kartı, hızlı işlemler, dosya tamlığı |
| Yapılacaklar | `checklist` | Gelecek işler: muayene, sigorta, bakım, MTV |
| Geçmiş | `clock.arrow.circlepath` | Yapılmış işlemler: masraf, bakım, belge, ekspertiz |
| Raporlar | `chart.bar` | Maliyet analizi, sahiplik içgörüleri |
| Topluluk | `person.3` | Kontrollü forum (Supabase + Apple Sign-In) |

## Son Commit'ler

| Commit | Konu |
|--------|------|
| `7fb51f4` | Final düzeltme: ReminderFormView edit, HistoryView tap/swipe, onboarding, tips, motosiklet ikon |
| `d4492a5` | Bilgi mimarisi: Yapılacaklar/Geçmiş, ReminderDetailView, HistoryView |
| `d24bd3f` | Motosiklet desteği: VehicleType, MotorcycleType, özel enum'lar |
| `9792d0f` | Design Polish + Bug fix + App Store hazırlık + Supabase SQL |

Detaylı rapor: `docs/LAST_4_COMMIT_REPORT.md`
Son durum: `docs/lastchecks.md`

## Tasarım Dosyaları

1. `01_DESIGN.md`  
   Uygulamanın tasarım anayasası. AI-slop/generic görünümü engelleyen tasarım kuralları.

2. `02_PRODUCT_SCOPE.md`  
   Ürün kapsamı, MVP, V1, V2, V3 feature haritası.

3. `03_SWIFTUI_ARCHITECTURE.md`  
   SwiftUI + SwiftData + CloudKit/Supabase opsiyonlu teknik mimari.

4. `04_AGENT_PHASE_PLAN.md`  
   Coding agent için fazlara bölünmüş uygulama geliştirme planı.

5. `05_AGENT_PROMPTS.md`  
   Agentlara verilecek hazır promptlar.

6. `06_APPSTORE_LEGAL_PRIVACY.md`  
   App Store, gizlilik politikası, kullanım koşulları, KVKK, abonelik ve review checklisti.

7. `07_MONETIZATION_AND_GROWTH.md`  
   Gelir modeli, paywall, B2C/B2B/partner stratejisi.

## Ana ürün prensibi

Bu uygulama bir “araç masraf defteri” değildir.

Doğru konumlandırma:

> Aracının dijital yaşam dosyası.

Kullanıcı uygulamaya yalnızca masraf girmek için değil; aracının geçmişini düzenlemek, önemli tarihleri unutmamak, belgelerini saklamak ve satarken güven dosyası paylaşmak için gelir.

## Coding agent için en kritik kural

Kod yazmadan önce `01_DESIGN.md` okunacak.  
UI tarafında ham renk, ham spacing, rastgele radius, generic gradient, gereksiz kart grid, emoji/icon karmaşası yasaktır.

