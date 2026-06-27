import Foundation

// MARK: - Supabase Configuration
// Supabase bağlantı ayarlarını xcconfig üzerinden okur.
// xcconfig eksik veya placeholder ise isConfigured = false döner;
// topluluk özelliği crash yerine "hazırlanıyor" boş durumu gösterir.

enum SupabaseConfig {
    /// Supabase proje URL'si. Config.xcconfig içindeki SUPABASE_URL değerinden okunur.
    static var supabaseURL: URL? {
        guard let urlString = Self.value(for: "SUPABASE_URL"),
              !urlString.isEmpty,
              !urlString.contains("YOUR-PROJECT"),
              let url = URL(string: urlString) else {
            return nil
        }
        return url
    }

    /// Supabase anon key. Config.xcconfig içindeki SUPABASE_ANON_KEY değerinden okunur.
    static var supabaseAnonKey: String? {
        guard let key = Self.value(for: "SUPABASE_ANON_KEY"),
              !key.isEmpty,
              !key.contains("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."),
              key != "YOUR_ANON_KEY" else {
            return nil
        }
        return key
    }

    /// Config eksiksiz doldurulmuşsa true.
    /// Eksikse topluluk özelliği güvenli boş durum gösterir.
    static var isConfigured: Bool {
        supabaseURL != nil && supabaseAnonKey != nil
    }

    // MARK: - Private

    /// xcconfig değerlerini Bundle üzerinden okur.
    /// xcconfig değişkenleri Info.plist'e User-Defined Settings olarak eklenmeli.
    private static func value(for key: String) -> String? {
        Bundle.main.object(forInfoDictionaryKey: key) as? String
    }
}
