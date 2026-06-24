# Ürün Kapsamı ve Feature Map

## 1. Ürün tanımı

Uygulama, araç sahiplerinin araçlarına ait bakım, masraf, belge, ekspertiz ve satış güven dosyasını tek yerde yönetmesini sağlayan iOS uygulamasıdır.

Ana konumlandırma:

> Aracının dijital yaşam dosyası.

## 2. Hedef kullanıcılar

### Bireysel kullanıcı

- Kendi aracının muayene, sigorta, bakım ve masrafını takip etmek ister.
- Belgeleri dağınıktır.
- Aracını satarken bakım geçmişini göstermek ister.

### Titiz araç sahibi

- Hangi parçanın ne zaman değiştiğini saklamak ister.
- Usta/servis geçmişini önemser.
- Km bazlı bakım takibi ister.

### Küçük işletme

- 2-20 araçlık küçük filosunu takip etmek ister.
- Hangi araç ne kadar masraf çıkarıyor görmek ister.
- Bakım/muayene/sigorta tarihlerini kaçırmak istemez.

### Araç alıcı/satıcı

- Alırken kontrol listesi ister.
- Satarken ekspertiz ve bakım dosyasını paylaşmak ister.

## 3. MVP kapsamı

MVP hedefi:

> Kullanıcı aracını eklesin, önemli tarihleri takip etsin, bakım/masraf/belge kaydı tutsun ve satarken PDF satış dosyası oluşturabilsin.

### MVP modülleri

1. Araç ekleme ve garaj
2. Hatırlatıcılar
3. Bakım kayıtları
4. Masraf kayıtları
5. Belge kasası
6. Ekspertiz raporu manuel ekleme
7. Satış dosyası PDF
8. Basit raporlar
9. Pro paywall
10. Gizlilik/kullanım koşulları

## 4. V1 feature listesi

### Garaj

- Bir veya birden fazla araç kartı.
- Araç fotoğrafı.
- Plaka, marka, model, yıl, km.
- Yaklaşan en önemli iş.
- Dosya tamlık göstergesi.
- Arşivlenen araçlar.

### Araç profili

Alanlar:

- Plaka
- Marka
- Model
- Yıl
- Kasa tipi
- Yakıt tipi
- Vites tipi
- Güncel km
- Satın alma tarihi
- Satın alma km
- Satın alma fiyatı
- Kullanım tipi
- Notlar

### Hatırlatıcılar

Şablonlar:

- Muayene
- Trafik sigortası
- Kasko
- MTV 1. taksit
- MTV 2. taksit
- Periyodik bakım
- Yağ değişimi
- Lastik değişimi
- Akü
- Triger
- Fren
- Klima
- Garanti bitişi
- HGS kontrolü
- Diğer

Hatırlatıcı türleri:

- Tarih bazlı
- Km bazlı
- Tarih + km bazlı
- Tekrarlı
- Manuel

### Masraf kayıtları

Kategoriler:

- Yakıt
- Bakım
- Tamir
- Parça
- Lastik
- Akü
- Sigorta
- Kasko
- MTV
- Muayene
- Egzoz emisyon
- Otopark
- HGS/OGS
- Ceza
- Yıkama
- Aksesuar
- Diğer

Alanlar:

- Tarih
- Tutar
- Para birimi
- Km
- Kategori
- Açıklama
- Usta/firma
- Fiş/fatura
- İlgili belge
- İlgili bakım kaydı

### Bakım kayıtları

Alanlar:

- Bakım türü
- Tarih
- Km
- Usta/servis
- İşçilik
- Parça maliyeti
- Toplam
- Değişen parçalar
- Kullanılan yağ
- Notlar
- Fatura/belge
- Sonraki bakım hatırlatıcısı

### Belgeler

Belge tipleri:

- Ruhsat
- Trafik sigortası
- Kasko
- Muayene raporu
- Egzoz emisyon
- Ekspertiz raporu
- Servis faturası
- Parça faturası
- Garanti belgesi
- Lastik faturası
- Akü garanti belgesi
- Hasar/onarım belgesi
- Araç fotoğrafları
- Diğer

Özellikler:

- Fotoğraf/PDF ekleme
- Belge tarama
- Belge önizleme
- Son kullanma tarihi
- Satış dosyasına dahil etme
- Paylaşma

### Ekspertiz raporu

MVP:

- Manuel PDF/fotoğraf ekleme.
- Firma adı.
- Şube.
- Rapor tarihi.
- Km.
- Sonuç özeti.
- Satış dosyasına dahil etme.

İleride:

- Partner doğrulama.
- İndirim kodu.
- Otomatik rapor içe aktarma.

### Satış dosyası

MVP:

- PDF oluşturma.
- Araç özeti.
- Bakım geçmişi özeti.
- Masraf özeti.
- Ekspertiz raporu.
- Seçili belgeler.
- Hukuki uyarı.
- WhatsApp/share sheet ile paylaşım.

V1.5:

- Link ile paylaşım.
- QR kod.
- Görüntülenme sayısı.
- Süreli paylaşım linki.
- Doğrulanmış ekspertiz rozeti.

### Raporlar

MVP:

- Yıllık toplam masraf.
- Aylık masraf grafiği.
- Kategori dağılımı.
- Araç bazlı toplam.
- Km başı maliyet.

V2:

- Araç karşılaştırma.
- Trend analizi.
- En pahalı kalemler.
- İşletme raporu.
- PDF/CSV export.

## 5. MVP dışı bırakılacaklar

İlk sürümde yapılmayacak:

- OBD entegrasyonu.
- GPS/fleet tracking.
- Gerçek sigorta teklif sistemi.
- Gerçek ekspertiz API.
- Usta pazaryeri.
- Her model için otomatik kronik sorun veritabanı.
- Araç ilan platformu.
- Açık kullanıcı yorumları.
- Android.
- Web panel.
- AI sohbet botu.

## 6. Feature önceliklendirme

### Must-have

- Araç ekleme
- Hatırlatıcı
- Masraf
- Bakım
- Belge
- Satış PDF
- Paywall
- App privacy/hukuk

### Should-have

- Ekspertiz özel alanı
- Belge tarama
- Raporlar
- Dosya tamlık skoru
- iCloud sync

### Could-have

- QR paylaşım
- Partner indirim kodu
- Küçük işletme modu
- CSV export
- Araç alma checklisti

### Won’t-have initially

- OBD
- Marketplace
- Sigorta API
- Büyük filo GPS
- AI wrapper özellikleri

