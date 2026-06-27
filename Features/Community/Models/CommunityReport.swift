import Foundation

// MARK: - Community Report
// Supabase community_reports tablosuna karşılık gelen Codable model.

struct CommunityReport: Codable, Identifiable, Equatable {
    let id: UUID
    let reporterId: UUID
    let targetType: String
    let targetId: UUID
    let reason: ReportReason
    var description: String?
    var status: ReportStatus
    var createdAt: Date
    var reviewedAt: Date?
    var reviewerId: UUID?

    // MARK: - Computed

    var isPending: Bool { status == .pending }
    var isReviewed: Bool { status == .reviewed }
    var isDismissed: Bool { status == .dismissed }

    var targetLabel: String {
        switch targetType {
        case "post": return "Gönderi"
        case "comment": return "Yorum"
        default: return targetType
        }
    }

    // MARK: - Coding Keys

    enum CodingKeys: String, CodingKey {
        case id
        case reporterId = "reporter_id"
        case targetType = "target_type"
        case targetId = "target_id"
        case reason, description, status
        case createdAt = "created_at"
        case reviewedAt = "reviewed_at"
        case reviewerId = "reviewer_id"
    }
}
