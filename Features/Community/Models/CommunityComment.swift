import Foundation

// MARK: - Community Comment
// Supabase community_comments tablosuna karşılık gelen Codable model.

struct CommunityComment: Codable, Identifiable, Equatable {
    let id: UUID
    let postId: UUID
    let authorId: UUID
    var body: String
    var isHidden: Bool
    var deletedAt: Date?
    var deletedBy: UUID?
    var createdAt: Date
    var updatedAt: Date

    // MARK: - Joined (profiles tablosundan)

    var authorUsername: String?
    var authorDisplayName: String?
    var authorAvatarURL: String?
    var authorIsVerified: Bool?
    var authorRole: CommunityRole?

    // MARK: - Computed

    var authorEffectiveName: String {
        if let displayName = authorDisplayName, !displayName.isEmpty {
            return displayName
        }
        return authorUsername ?? "Bilinmeyen"
    }

    var authorAtUsername: String? {
        guard let username = authorUsername else { return nil }
        return "@\(username)"
    }

    var isDeleted: Bool { deletedAt != nil }

    var relativeTime: String {
        let interval = Date().timeIntervalSince(createdAt)
        if interval < 60 { return "Az önce" }
        if interval < 3600 { return "\(Int(interval / 60)) dk önce" }
        if interval < 86400 { return "\(Int(interval / 3600)) saat önce" }
        if interval < 604800 { return "\(Int(interval / 86400)) gün önce" }
        return createdAt.formatted(date: .abbreviated, time: .omitted)
    }

    // MARK: - Coding Keys

    enum CodingKeys: String, CodingKey {
        case id
        case postId = "post_id"
        case authorId = "author_id"
        case body
        case isHidden = "is_hidden"
        case deletedAt = "deleted_at"
        case deletedBy = "deleted_by"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        // Joined
        case authorUsername = "author_username"
        case authorDisplayName = "author_display_name"
        case authorAvatarURL = "author_avatar_url"
        case authorIsVerified = "author_is_verified"
        case authorRole = "author_role"
    }
}
