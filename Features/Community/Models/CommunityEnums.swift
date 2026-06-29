import Foundation

// MARK: - Community Enums
// Topluluk özelliği için tüm enum tanımları.
// Hiçbir yerde ham string kullanılmaz.

// MARK: - Community Role

enum CommunityRole: String, Codable, CaseIterable, Equatable {
    case user
    case moderator
    case admin

    var displayName: String {
        switch self {
        case .user: return "Kullanıcı"
        case .moderator: return "Moderatör"
        case .admin: return "Editör"
        }
    }
}

// MARK: - Post Type

enum PostType: String, Codable, CaseIterable, Equatable {
    case news
    case announcement
    case advice
    case problem
    case experience
    case question

    var displayName: String {
        switch self {
        case .news: return "Haber"
        case .announcement: return "Duyuru"
        case .advice: return "Tavsiye"
        case .problem: return "Sorun"
        case .experience: return "Deneyim"
        case .question: return "Soru"
        }
    }

    var sfSymbol: String {
        switch self {
        case .news: return "newspaper"
        case .announcement: return "megaphone"
        case .advice: return "lightbulb"
        case .problem: return "exclamationmark.triangle"
        case .experience: return "star"
        case .question: return "questionmark.circle"
        }
    }
}

// MARK: - Report Reason

enum ReportReason: String, Codable, CaseIterable, Equatable {
    case spam
    case harassment
    case misleading
    case personalInfo = "personal_info"
    case inappropriate
    case other

    var displayName: String {
        switch self {
        case .spam: return "Spam"
        case .harassment: return "Hakaret / taciz"
        case .misleading: return "Yanıltıcı bilgi"
        case .personalInfo: return "Kişisel bilgi paylaşımı"
        case .inappropriate: return "Uygunsuz içerik"
        case .other: return "Diğer"
        }
    }

    var sfSymbol: String {
        switch self {
        case .spam: return "megaphone.slash"
        case .harassment: return "hand.raised.slash"
        case .misleading: return "exclamationmark.triangle"
        case .personalInfo: return "person.text.rectangle"
        case .inappropriate: return "eye.slash"
        case .other: return "ellipsis.circle"
        }
    }
}

// MARK: - Report Status

enum ReportStatus: String, Codable, Equatable {
    case pending
    case reviewed
    case dismissed

    var displayName: String {
        switch self {
        case .pending: return "Bekliyor"
        case .reviewed: return "İncelendi"
        case .dismissed: return "Reddedildi"
        }
    }
}

// MARK: - Predefined Tags

enum CommunityTag {
    static let all: [String] = [
        "Bakım", "Masraf", "Muayene", "Sigorta",
        "Kasko", "MTV", "Lastik", "Akü",
        "Ekspertiz", "İkinci El", "Elektrikli", "LPG",
        "Servis/Usta"
    ]
}
