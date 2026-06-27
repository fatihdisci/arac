import Foundation

// MARK: - Community Profile
// Supabase profiles tablosuna karşılık gelen Codable model.
// SwiftData @Model DEĞİLDİR — veri Supabase'de yaşar.

struct CommunityProfile: Codable, Identifiable, Equatable {
    let id: UUID
    var username: String
    var displayName: String?
    var avatarURL: String?
    var role: CommunityRole
    var isVerified: Bool
    var isBanned: Bool
    var isPro: Bool
    var defaultVehicleBrand: String?
    var defaultVehicleModel: String?
    var defaultVehicleYear: Int?
    var showVehicleOnPosts: Bool
    var createdAt: Date
    var updatedAt: Date

    // MARK: - Computed

    /// Görünen ad; yoksa kullanıcı adı.
    var effectiveDisplayName: String {
        if let displayName, !displayName.isEmpty {
            return displayName
        }
        return username
    }

    /// @ kullanıcı adı formatı.
    var atUsername: String {
        "@\(username)"
    }

    /// Admin veya moderatör mü?
    var isModerator: Bool {
        role == .admin || role == .moderator
    }

    /// Yasaklı değilse içerik oluşturabilir.
    var canCreateContent: Bool {
        !isBanned
    }

    /// Varsayılan araç etiketi (plaka içermez).
    var vehicleLabel: String? {
        guard showVehicleOnPosts,
              let brand = defaultVehicleBrand, !brand.isEmpty else {
            return nil
        }

        var parts: [String] = [brand]
        if let model = defaultVehicleModel, !model.isEmpty {
            parts.append(model)
        }
        if let year = defaultVehicleYear {
            parts.append(String(year))
        }
        return parts.joined(separator: " ")
    }

    // MARK: - Coding Keys

    enum CodingKeys: String, CodingKey {
        case id, username
        case displayName = "display_name"
        case avatarURL = "avatar_url"
        case role
        case isVerified = "is_verified"
        case isBanned = "is_banned"
        case isPro = "is_pro"
        case defaultVehicleBrand = "default_vehicle_brand"
        case defaultVehicleModel = "default_vehicle_model"
        case defaultVehicleYear = "default_vehicle_year"
        case showVehicleOnPosts = "show_vehicle_on_posts"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }

    // MARK: - Validate

    /// Kullanıcı adı doğrulama. Hata mesajı döndürür; nil = geçerli.
    static func validateUsername(_ username: String) -> String? {
        let trimmed = username.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.count < 3 {
            return "Kullanıcı adı en az 3 karakter olmalı."
        }
        if trimmed.count > 20 {
            return "Kullanıcı adı en fazla 20 karakter olabilir."
        }
        let allowed = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_")
        if trimmed.rangeOfCharacter(from: allowed.inverted) != nil {
            return "Kullanıcı adı yalnızca harf, rakam ve alt çizgi içerebilir."
        }
        return nil
    }

    /// Görünen ad doğrulama.
    static func validateDisplayName(_ name: String?) -> String? {
        guard let name, !name.isEmpty else { return nil }
        if name.count > 50 {
            return "Görünen ad en fazla 50 karakter olabilir."
        }
        return nil
    }
}
