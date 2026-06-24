# DESIGN.md — Araç Dijital Dosyası Tasarım Anayasası

## 1. Ürün karakteri

Bu uygulama premium, güvenilir, sakin ve profesyonel görünmelidir.

Uygulama dili:

- Araç takip defteri değil.
- Ucuz oto sanayi uygulaması değil.
- Galeri ilan uygulaması değil.
- AI wrapper gibi görünmeyecek.
- Aşırı neon, 3D, emoji, mavi-mor gradyan, generic SaaS kartları yok.
- Apple-native, düzenli, güven veren, “aracımın resmi olmayan dijital dosyası” hissi verecek.

Ana his:

> Cebindeki premium araç dosyası.

## 2. Tasarım felsefesi

Vibe-coded uygulamaların amatör görünmesinin nedeni genellikle yaratıcı kısıt eksikliğidir. Bu projede coding agent boş prompttan UI üretmeyecek. Her ekran bu dosyadaki token, hiyerarşi, spacing, motion ve native iOS kurallarına göre yapılacak.

Ana kural:

> AI varsayılanını öldür, native iOS güvenini koru, ürünün kendi imzasını ekle.

## 3. Yasaklı “AI-slop” işaretleri

Aşağıdakiler üretimde kullanılmayacak:

- Mavi-mor generic gradient.
- Her yerde aynı yuvarlak köşeli kart.
- Dekoratif ama işlevsiz dashboard card mosaic.
- Inter / Roboto / Arial gibi web/SaaS default hissi veren font dayatması.
- Rastgele emoji ikonları.
- Rastgele 3D araba illüstrasyonu.
- Gereksiz cam/glassmorphism.
- Aşırı gölge.
- Opacity çorbası.
- Her ekranın aynı kart yığını gibi görünmesi.
- Boş durum, hata durumu ve loading durumu olmayan ekranlar.
- “Something went wrong” gibi güven kıran hata mesajları.
- Renklerin anlam taşımadan kullanılması.
- Sadece güzel görünen ama gerçek veriyle dağılan layout.

## 4. Görsel hiyerarşi

Her ekranda tek bir ana görsel çapa olmalı.

Örnek:

- Garaj ekranında: seçili/ana araç kartı.
- Araç detayında: yaklaşan en kritik iş.
- İşler ekranında: geciken/kritik görevler.
- Belgeler ekranında: eksik veya süresi yaklaşan belge.
- Satış dosyasında: dosya tamlık skoru.
- Raporlar ekranında: yıllık toplam masraf veya km başı maliyet.

Her şey aynı önem seviyesinde gösterilmeyecek.

## 5. Renk sistemi

Renkler semantik olacak. Ham hex doğrudan view içinde kullanılmayacak.

### Önerilen ana palet

- Background Primary: near white / near black adaptive
- Surface Primary: sistem arka planından hafif ayrışan yüzey
- Text Primary: yüksek kontrast
- Text Secondary: sakin açıklama
- Accent Primary: güven veren petrol/mavi ton
- Success: yeşil
- Warning: amber
- Critical: kırmızı
- Document: gümüş/gri
- Vehicle: koyu lacivert/grafit

### Önerilen hex yönü

Light mode:

- `#F8FAFC` ana zemin
- `#FFFFFF` surface
- `#111827` primary text
- `#64748B` secondary text
- `#0F766E` accent
- `#2563EB` secondary accent
- `#F59E0B` warning
- `#DC2626` critical
- `#10B981` success

Dark mode:

- `#0B1220` ana zemin
- `#111827` surface
- `#F8FAFC` primary text
- `#94A3B8` secondary text
- `#2DD4BF` accent
- `#60A5FA` secondary accent
- `#FBBF24` warning
- `#F87171` critical
- `#34D399` success

### Renk kullanımı

- Accent tek ana aksiyon için kullanılacak.
- Warning yalnızca yaklaşan önemli tarihler için.
- Critical yalnızca geçmiş/gecikmiş/kritik durum için.
- Success yalnızca tamamlandı/aktif/güvenli durum için.
- Gradyan yalnızca anlamlı yerde kullanılabilir:
  - Araç fotoğrafı placeholder.
  - Satış dosyası kapak alanı.
  - Premium paywall hero.
  - Asla rutin liste arka planında dekorasyon olarak kullanılmaz.

## 6. Tipografi

Native SF Pro hissi korunacak. SwiftUI sistem text style kullanılacak.

### Tip ölçeği

- Large Hero Number: 38-44pt, light/medium weight
- Screen Title: `.largeTitle` veya 28-34pt bold
- Section Title: 20-22pt semibold
- Card Title: 17-18pt semibold
- Body: 16-17pt regular
- Secondary: 14-15pt regular
- Caption: 12-13pt medium/regular

### Kurallar

- Dynamic Type desteklenecek.
- Metinler kırpılmadan gerçek veriyle test edilecek.
- Plaka, tutar ve tarih gibi kritik bilgiler okunaklı olacak.
- Büyük tutarlar, uzun araç isimleri ve uzun usta/servis isimleri test edilecek.

## 7. Spacing sistemi

8pt grid.

Tokenlar:

- `xxs = 4`
- `xs = 8`
- `sm = 12`
- `md = 16`
- `lg = 24`
- `xl = 32`
- `xxl = 48`

Kurallar:

- İlgili öğeler: 8-12pt
- Kart içi padding: 16-20pt
- Bölümler arası: 24-32pt
- Ana CTA çevresi: 24-48pt
- Ekran yatay margin: 16-20pt
- Liste satır yüksekliği: minimum 52pt
- Tap target: minimum 44pt

## 8. Radius sistemi

Her şey aynı radius olmayacak.

Tokenlar:

- `small = 8`
- `medium = 12`
- `large = 18`
- `xlarge = 24`
- `capsule = 999`

Kullanım:

- Küçük chip: capsule
- Liste/satır: 12
- Ana kart: 18
- Hero card: 24
- Modal/sheet: native radius

## 9. Gölge sistemi

Gölge az ve anlamlı kullanılacak.

- Rutin kartlarda ağır gölge yok.
- Surface ayrımı çoğunlukla renk/border ile yapılacak.
- Hero/satış dosyası gibi premium anlarda yumuşak gölge olabilir.
- Dark mode’da gölge yerine border/surface contrast kullanılacak.

## 10. İkonografi

SF Symbols ana ikon seti olacak.

Kurallar:

- Her kategori için net SF Symbol seçilecek.
- Emoji kullanılmayacak.
- Aynı sembol stili korunacak.
- Filled/hierarchical/palette kullanımı tutarlı olacak.
- Silme için `trash`.
- Belge için `doc.text`.
- Sigorta/kasko için `shield`.
- Muayene için `checkmark.seal`.
- Bakım için `wrench.and.screwdriver`.
- Yakıt için `fuelpump`.
- Lastik için custom icon gerekebilir ama MVP’de SF Symbol yeterli değilse sade custom asset yapılır.
- Satış dosyası için `doc.richtext` / `qrcode` / `square.and.arrow.up`.

## 11. Motion ve haptik

Motion premium his vermeli, oyuncak gibi olmamalı.

Kullanılacak yerler:

- Araç ekleme tamamlandı.
- Bakım kaydı eklendi.
- Hatırlatıcı tamamlandı.
- Satış dosyası oluşturuldu.
- Paywall’dan Pro açıldı.
- Dosya tamlık skoru yükseldi.

Kurallar:

- Tap-pop küçük ve hızlı.
- Spring yalnızca anlamlı geçişte.
- `accessibilityReduceMotion` kontrol edilecek.
- Haptik başarı/uyarı/kritik ayrımına göre kullanılacak.
- Her butona haptik koyma; önemli state değişimlerine koy.

Örnek his:

- Kaydetme: hafif success haptic.
- Gecikmiş işi tamamlama: success haptic + küçük check animasyonu.
- Belge silme: destructive confirmation, gereksiz animasyon yok.

## 12. Component sistemi

Merkezi komponentler:

- `VehicleCard`
- `VehicleHeroHeader`
- `UpcomingTaskCard`
- `ReminderRow`
- `ExpenseRow`
- `ServiceTimelineItem`
- `DocumentCard`
- `DocumentCategoryPill`
- `SaleFileScoreCard`
- `MetricCard`
- `EmptyStateView`
- `ErrorStateView`
- `PrimaryButtonStyle`
- `SecondaryButtonStyle`
- `DestructiveButtonStyle`

Kart yalnızca gerçekten anlamlıysa kullanılacak. Her veri parçası kart olmak zorunda değil.

## 13. Empty state kuralları

Boş durum çıkmaz sokak olmayacak. Her boş durumda:

1. Ne olmadığı açıkça söylenecek.
2. Neden önemli olduğu anlatılacak.
3. Tek net CTA verilecek.

Örnek:

### Araç yok

Başlık: `İlk aracının dosyasını oluşturalım`  
Açıklama: `Muayene, sigorta, bakım ve belgeleri tek yerde takip etmek için aracını ekle.`  
CTA: `Araç Ekle`

### Belge yok

Başlık: `Belgelerini burada saklayabilirsin`  
Açıklama: `Poliçe, muayene, ekspertiz ve faturaları aracının dijital dosyasına ekle.`  
CTA: `Belge Ekle`

### Masraf yok

Başlık: `İlk masraf kaydını ekle`  
Açıklama: `Yakıt, bakım, parça ve sigorta giderlerini kaydederek aracının yıllık maliyetini gör.`  
CTA: `Masraf Ekle`

## 14. Hata mesajları

Hata mesajı formatı:

1. Ne oldu?
2. Kullanıcı ne yapabilir?
3. Veri kaybı var mı?

Kötü:

> Bir hata oluştu.

İyi:

> Belge kaydedilemedi. İnternet bağlantını kontrol edip tekrar deneyebilirsin. Seçtiğin dosya cihazından silinmedi.

## 15. Signature interaction

Bu uygulamanın “AI’ın kolay kolay düşünemeyeceği” imza detayı:

### Araç Yaşam Çizgisi

Araç detay ekranında aracın kronolojik timeline’ı premium bir “yaşam çizgisi” olarak gösterilir.

- Satın alma
- İlk kayıt
- Bakımlar
- Parça değişimleri
- Sigorta/kasko
- Muayene
- Ekspertiz
- Satış dosyası

Bu timeline, uygulamanın ruhunu taşır. Sıradan gider listesi değil, aracın hafızasıdır.

## 16. Erişilebilirlik

- Dynamic Type zorunlu.
- VoiceOver label zorunlu.
- Icon-only button yoksa label olacak.
- Kontrast normal metinde en az 4.5:1.
- Büyük metinde 3:1.
- Tap target minimum 44pt.
- Reduce Motion desteklenecek.
- Dark mode gerçek tasarlanacak, sadece otomatik invert değil.

## 17. Dark mode

Dark mode premium ve okunaklı olacak.

- Pure black her yerde kullanılmayacak.
- Desatüre lacivert/grafit zemin.
- Kartlar hafif ayrışacak.
- Warning/critical renkler karanlıkta aşırı bağırmayacak.
- Belge/PDF preview ekranları okunabilir kalacak.

## 18. Paywall tasarım ilkeleri

Paywall güven kırmayacak.

Zorunlu:

- Restore purchases linki.
- Cancel anytime / istediğin zaman iptal et mesajı.
- Fiyat netliği.
- Abonelik süresi netliği.
- Dark pattern yok.
- CTA gizli/aldatıcı olmayacak.
- Free limit neden var açık anlatılacak.

Paywall zamanı:

- Uygulama açılır açılmaz hard paywall yok.
- Kullanıcı değer gördükten sonra:
  - 2. araç eklemek istediğinde.
  - Satış dosyası PDF/link oluşturmak istediğinde.
  - Sınırsız belge kullanmak istediğinde.
  - Gelişmiş rapor açtığında.

## 19. Design review skoru

Her major ekran şu 5 başlıkta en az 7/10 almalı:

1. Felsefe tutarlılığı
2. Görsel hiyerarşi
3. Detay işçiliği
4. İşlevsellik
5. Özgünlük

Ek kontroller:

- Grayscale testi
- Kontrast testi
- Gerçek veri testi
- Uzun metin testi
- Boş/hata/loading testi
- Dark mode testi

