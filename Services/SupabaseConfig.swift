import Foundation

// MARK: - Supabase Configuration
// Configuration/Config.xcconfig üzerinden Supabase bağlantı ayarlarını okur.
// xcconfig eksik veya placeholder ise isConfigured = false döner;
// topluluk özelliği crash yerine "hazırlanıyor" boş durumu gösterir.
//
// Config.xcconfig formatı (4 satır):
//   SUPABASE_URL = https:/$()/PROJECT.supabase.co
//   SUPABASE_ANON_KEY = ANON_PUBLIC_KEY
//   INFOPLIST_KEY_SUPABASE_URL = $(SUPABASE_URL)
//   INFOPLIST_KEY_SUPABASE_ANON_KEY = $(SUPABASE_ANON_KEY)
//
// INFOPLIST_KEY_ prefix'i sayesinde GENERATE_INFOPLIST_FILE = YES
// ile oluşturulan Info.plist'e SUPABASE_URL / SUPABASE_ANON_KEY olarak düşer.

enum SupabaseConfig {
    /// Supabase proje URL'si.
    static var supabaseURL: URL? {
        guard let urlString = Self.value(for: "SUPABASE_URL"),
              !urlString.isEmpty else {
            return nil
        }
        guard !urlString.contains("YOUR-PROJECT") else {
            #if DEBUG
            print("[SupabaseConfig] ⚠️ SUPABASE_URL placeholder içeriyor (YOUR-PROJECT)")
            #endif
            return nil
        }
        guard let url = URL(string: urlString) else {
            #if DEBUG
            print("[SupabaseConfig] ⚠️ SUPABASE_URL geçerli bir URL değil: \"\(urlString.prefix(40))...\"")
            if urlString.hasPrefix("https:") && !urlString.hasPrefix("https://") {
                print("[SupabaseConfig]    → xcconfig escaping sorunu olabilir. https:/$()/PROJECT.supabase.co formatını kullanın")
            }
            #endif
            return nil
        }
        return url
    }

    /// Supabase anon key.
    static var supabaseAnonKey: String? {
        guard let key = Self.value(for: "SUPABASE_ANON_KEY"),
              !key.isEmpty else {
            return nil
        }
        guard !key.contains("YOUR_SUPABASE_ANON_PUBLIC_KEY") else {
            #if DEBUG
            print("[SupabaseConfig] ⚠️ SUPABASE_ANON_KEY placeholder içeriyor")
            #endif
            return nil
        }
        return key
    }

    /// Config eksiksiz doldurulmuşsa true.
    static var isConfigured: Bool {
        let urlOk = supabaseURL != nil
        let keyOk = supabaseAnonKey != nil
        let configured = urlOk && keyOk

        #if DEBUG
        if !configured {
            print("[SupabaseConfig] ── isConfigured = false ──")
            if !urlOk {
                let raw = Bundle.main.object(forInfoDictionaryKey: "SUPABASE_URL")
                print("[SupabaseConfig] ❌ SUPABASE_URL: \(raw == nil ? "Info.plist'te yok" : "geçersiz (\"\(raw!)\")")")
                if raw == nil {
                    print("[SupabaseConfig]    → Config.xcconfig build configuration'a bağlı değil veya INFOPLIST_KEY_SUPABASE_URL set edilmemiş")
                    print("[SupabaseConfig]    → Beklenen format: INFOPLIST_KEY_SUPABASE_URL = $(SUPABASE_URL)")
                }
            }
            if !keyOk {
                let raw = Bundle.main.object(forInfoDictionaryKey: "SUPABASE_ANON_KEY")
                print("[SupabaseConfig] ❌ SUPABASE_ANON_KEY: \(raw == nil ? "Info.plist'te yok" : "placeholder/geçersiz")")
                if raw == nil {
                    print("[SupabaseConfig]    → Config.xcconfig build configuration'a bağlı değil veya INFOPLIST_KEY_SUPABASE_ANON_KEY set edilmemiş")
                    print("[SupabaseConfig]    → Beklenen format: INFOPLIST_KEY_SUPABASE_ANON_KEY = $(SUPABASE_ANON_KEY)")
                }
            }
            // Tüm Info.plist Supabase anahtarlarını logla
            let allKeys = Bundle.main.infoDictionary?.keys.filter { $0.lowercased().contains("supabase") } ?? []
            if allKeys.isEmpty {
                print("[SupabaseConfig] ⚠️ Info.plist'te Supabase ile ilgili hiçbir key yok")
            } else {
                print("[SupabaseConfig] Info.plist Supabase key'leri: \(allKeys.sorted())")
            }
        }
        #endif

        return configured
    }

    /// Debug build'lerde config durumunu gösterir (maskeli).
    static func debugState() -> String {
        var lines: [String] = []
        let urlRaw = Bundle.main.object(forInfoDictionaryKey: "SUPABASE_URL") as? String
        let keyRaw = Bundle.main.object(forInfoDictionaryKey: "SUPABASE_ANON_KEY") as? String

        lines.append("Bundle SUPABASE_URL present: \(urlRaw != nil)")
        lines.append("Bundle SUPABASE_ANON_KEY present: \(keyRaw != nil)")

        if let url = urlRaw {
            let masked = url.prefix(12) + "..." + (url.contains("supabase.co") ? ".supabase.co" : "")
            lines.append("URL value: \(masked)")
            if url.hasPrefix("https:") && !url.hasPrefix("https://") {
                lines.append("⚠️ URL malformed — xcconfig'te https:/$()/ kullanın")
            }
        }
        if keyRaw != nil {
            lines.append("Anon key: (present, masked)")
        }

        lines.append("Checked keys: SUPABASE_URL, SUPABASE_ANON_KEY")
        lines.append("")
        lines.append("Beklenen Config.xcconfig formatı:")
        lines.append("SUPABASE_URL = https:/$()/PROJECT.supabase.co")
        lines.append("SUPABASE_ANON_KEY = anon_public_key")
        lines.append("INFOPLIST_KEY_SUPABASE_URL = $(SUPABASE_URL)")
        lines.append("INFOPLIST_KEY_SUPABASE_ANON_KEY = $(SUPABASE_ANON_KEY)")

        return lines.joined(separator: "\n")
    }

    // MARK: - Private

    private static func value(for key: String) -> String? {
        Bundle.main.object(forInfoDictionaryKey: key) as? String
    }
}
