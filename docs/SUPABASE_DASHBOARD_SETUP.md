# Supabase Dashboard Setup

Topluluk özelliği için Supabase projesi yapılandırma adımları.

## 1. Supabase Projesi Oluşturma

1. [supabase.com](https://supabase.com) → Dashboard → New Project
2. Organization seç, isim ver (örn: `ruhsatim`)
3. Database password belirle (güvenli bir yerde sakla)
4. Region: Frankfurt (Türkiye'ye en yakın)
5. Create project → 2-3 dk bekle

## 2. Apple Auth Provider'ı Etkinleştir

1. Supabase Dashboard → Authentication → Providers
2. Apple provider'ı seç
3. Enable Apple provider
4. Apple Developer hesabında Service ID oluştur:
   - Apple Developer → Certificates, Identifiers & Profiles → Identifiers
   - + → Services IDs → Continue
   - Description: `Garajım Supabase Auth`
   - Identifier: `com.ruhsatim.app.auth`
   - Register → Done
5. Service ID'yi seç → Sign in with Apple → Configure
   - Primary App ID: `com.ruhsatim.app`
   - Web Domain: `YOUR-PROJECT.supabase.co`
   - Return URL: `https://YOUR-PROJECT.supabase.co/auth/v1/callback`
   - Save
6. Supabase Dashboard'daki Apple provider ayarlarına dön:
   - Client ID (Service ID): `com.ruhsatim.app.auth`
   - Team ID: Apple Developer hesabından
   - Key ID: Apple Developer → Keys → + (Sign in with Apple) → Key ID
   - Private Key: İndirilen `.p8` dosyasının içeriği
   - Save

## 3. Database Şemasını Kur

1. Supabase Dashboard → SQL Editor
2. `SUPABASE_COMMUNITY_SCHEMA.sql` dosyasının içeriğini kopyala
3. Run → tüm tablolar ve RLS policy'leri oluşturulur
4. Table Editor'dan tabloları kontrol et:
   - `profiles`
   - `community_posts`
   - `community_comments`
   - `community_post_likes`
   - `community_post_saves`
   - `community_reports`
   - `community_blocks`

## 4. iOS Uygulama Yapılandırması

1. `Configuration/Config.xcconfig` dosyasını oluştur (`Config.example.xcconfig`'den kopyala)
2. `SUPABASE_URL` = projenin URL'si (örn: `https://abcdefghijklm.supabase.co`)
3. `SUPABASE_ANON_KEY` = Supabase Dashboard → Settings → API → anon/public key
4. Xcode'da Config.xcconfig'i Debug ve Release build configuration'larına ata
5. Build → çalıştır → Topluluk sekmesi "hazırlanıyor" boş durumu GÖSTERMEMELİ

## 5. Admin Kullanıcısı

Bkz. `ADMIN_SETUP.md`

## 6. Test Kullanıcıları ve Postlar

İlk test için SQL Editor'da örnek post oluştur:

```sql
-- Test postu (kendi profile ID'ni kullan)
INSERT INTO community_posts (author_id, title, body, post_type, tags, vehicle_brand, vehicle_model, vehicle_year)
VALUES (
  '<YOUR-PROFILE-ID>',
  'Hoş geldiniz! 👋',
  'Garajım topluluğuna hoş geldiniz. Burası araç sahiplerinin deneyimlerini paylaştığı, sorular sorduğu ve tavsiyeler verdiği bir alan. Kurallara uyarak kaliteli bir topluluk oluşturalım.',
  'announcement',
  ARRAY['Bakım'],
  'Renault',
  'Clio',
  2020
);
```
