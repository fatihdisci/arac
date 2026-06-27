# Xcode Proje Yapılandırma Adımları

Topluluk özelliği için Xcode'da yapılması gereken manuel adımlar.
Bu adımlar pbxproj editörü ile otomatikleştirilemediği için manuel yapılır.
Her adım 1-2 dakika sürer.

## 1. Supabase Swift Package Manager (SPM)

1. Xcode'da projeyi aç
2. File → Add Package Dependencies...
3. Arama kutusuna: `https://github.com/supabase/supabase-swift.git`
4. Dependency Rule: "Up to Next Major Version" — 2.0.0 < 3.0.0
5. Add Package
6. "Choose Package Products" → Supabase → Add Package

## 2. Sign in with Apple Capability

1. Project Navigator → "Ruhsatim" target → Signing & Capabilities
2. + Capability → "Sign in with Apple"
3. Bu, otomatik olarak entitlement oluşturacak

## 3. Supabase Config Build Settings

1. Project Navigator → "Ruhsatim" target → Build Settings
2. "Info.plist Values" bölümüne ekle:
   - Key: `SUPABASE_URL` — Value: `$(SUPABASE_URL)` (xcconfig okumak için)
   - Key: `SUPABASE_ANON_KEY` — Value: `$(SUPABASE_ANON_KEY)`

## 4. Build Configuration (xcconfig)

1. Project Navigator → Project → Info → Configurations
2. Debug için: Configuration/Config.xcconfig seç
3. Release için: Configuration/Config.xcconfig seç

## 5. Build ve Doğrula

1. Product → Clean Build Folder
2. Product → Build (⌘B)
3. Hata yoksa devam et
