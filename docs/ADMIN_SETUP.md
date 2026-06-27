# Admin Setup

Garajım topluluk admin kullanıcısı (Garajım Editörü) yapılandırma adımları.

## Adım Adım

### 1. Apple ile Giriş Yap

Uygulamayı build et ve Topluluk sekmesinden "Apple ile Giriş Yap" butonuna tıkla.
Normal Apple Sign-In akışını tamamla. Supabase'de bir auth user oluşacak.

### 2. Auth User ID'ni Bul

İki yöntem var:

**Yöntem A — Supabase Dashboard:**
- Authentication → Users → son eklenen kullanıcıyı bul
- UUID'yi kopyala (xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx formatında)

**Yöntem B — SQL:**
```sql
SELECT id, email, created_at
FROM auth.users
ORDER BY created_at DESC
LIMIT 5;
```

### 3. Admin Profilini Oluştur / Güncelle

Supabase SQL Editor'da aşağıdaki sorguyu çalıştır.
`<YOUR-AUTH-USER-ID>` yerine 2. adımda bulduğun UUID'yi yaz:

```sql
INSERT INTO profiles (id, username, display_name, role, is_verified, is_pro)
VALUES (
  '<YOUR-AUTH-USER-ID>',
  'garajim',
  'Garajım Editörü',
  'admin',
  true,
  true
)
ON CONFLICT (id) DO UPDATE
SET username = 'garajim',
    display_name = 'Garajım Editörü',
    role = 'admin',
    is_verified = true,
    is_pro = true;
```

### 4. Doğrula

1. Uygulamadan çıkış yap (Sign Out)
2. Tekrar Apple ile giriş yap
3. Topluluk profilinde şunları görmelisin:
   - Kullanıcı adı: `@garajim`
   - Görünen ad: `Garajım Editörü`
   - Doğrulanmış rozeti (checkmark.seal.fill)
   - Profil ayarlarında moderasyon araçları erişimi

## Manuel Pro Ataması

Bir kullanıcıya manuel Pro yetkisi vermek için:

```sql
UPDATE profiles
SET is_pro = true
WHERE id = '<KULLANICI-AUTH-USER-ID>';
```

## Notlar

- Admin yetkisi Supabase'deki `role` alanından gelir. Kodda hardcoded bypass yoktur.
- RevenueCat webhook entegrasyonu yapıldığında `is_pro` alanı otomatik güncellenecek.
- Şimdilik tüm Pro atamaları manuel olarak bu SQL ile yapılır.
