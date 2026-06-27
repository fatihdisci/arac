import Foundation
import Supabase

// MARK: - Community Moderation Service
// Şikayet, engelleme ve admin moderasyon işlemleri.

@MainActor
final class CommunityModerationService {
    static let shared = CommunityModerationService()

    private var client: SupabaseClient? {
        SupabaseClientProvider.shared.client
    }

    /// Engellenen kullanıcı ID'leri (yerel cache).
    private(set) var blockedUserIds: [UUID] = []

    // MARK: - Reports

    func submitReport(
        targetType: String,
        targetId: UUID,
        reason: ReportReason,
        description: String? = nil
    ) async throws {
        guard let client = client else {
            throw CommunityServiceError.configMissing
        }

        guard let session = try? await client.auth.session else {
            throw CommunityServiceError.notAuthenticated
        }

        let payload: [String: any JSONValue] = [
            "reporter_id": .string(session.user.id.uuidString),
            "target_type": .string(targetType),
            "target_id": .string(targetId.uuidString),
            "reason": .string(reason.rawValue),
            "description": description.map { .string($0) } ?? .null,
        ]

        try await client
            .from("community_reports")
            .insert(payload)
            .execute()
    }

    // MARK: - Blocking

    func blockUser(userId: UUID) async throws {
        guard let client = client else {
            throw CommunityServiceError.configMissing
        }

        guard let session = try? await client.auth.session else {
            throw CommunityServiceError.notAuthenticated
        }

        try await client
            .from("community_blocks")
            .insert([
                "blocker_id": .string(session.user.id.uuidString),
                "blocked_id": .string(userId.uuidString),
            ])
            .execute()

        if !blockedUserIds.contains(userId) {
            blockedUserIds.append(userId)
        }
    }

    func unblockUser(userId: UUID) async throws {
        guard let client = client else {
            throw CommunityServiceError.configMissing
        }

        guard let session = try? await client.auth.session else {
            throw CommunityServiceError.notAuthenticated
        }

        try await client
            .from("community_blocks")
            .delete()
            .eq("blocker_id", value: session.user.id.uuidString)
            .eq("blocked_id", value: userId.uuidString)
            .execute()

        blockedUserIds.removeAll { $0 == userId }
    }

    func fetchBlockedUserIds() async throws -> [UUID] {
        guard let client = client else {
            throw CommunityServiceError.configMissing
        }

        guard let session = try? await client.auth.session else { return [] }

        struct BlockRow: Codable {
            let blockedId: UUID
            enum CodingKeys: String, CodingKey {
                case blockedId = "blocked_id"
            }
        }

        let rows: [BlockRow] = try await client
            .from("community_blocks")
            .select("blocked_id")
            .eq("blocker_id", value: session.user.id.uuidString)
            .execute()
            .value

        blockedUserIds = rows.map { $0.blockedId }
        return blockedUserIds
    }

    // MARK: - Admin

    func fetchReports(status: ReportStatus? = nil) async throws -> [CommunityReport] {
        guard let client = client else {
            throw CommunityServiceError.configMissing
        }

        var query = client
            .from("community_reports")
            .select()
            .order("created_at", ascending: false)

        if let status = status {
            query = query.eq("status", value: status.rawValue)
        }

        return try await query.execute().value
    }

    func markReportReviewed(_ reportId: UUID) async throws {
        guard let client = client else {
            throw CommunityServiceError.configMissing
        }

        guard let session = try? await client.auth.session else {
            throw CommunityServiceError.notAuthenticated
        }

        try await client
            .from("community_reports")
            .update([
                "status": .string("reviewed"),
                "reviewed_at": .string(Date().ISO8601Format()),
                "reviewer_id": .string(session.user.id.uuidString),
            ])
            .eq("id", value: reportId.uuidString)
            .execute()
    }

    func hidePost(_ postId: UUID) async throws {
        guard let client = client else {
            throw CommunityServiceError.configMissing
        }

        try await client
            .from("community_posts")
            .update(["is_hidden": .bool(true)])
            .eq("id", value: postId.uuidString)
            .execute()
    }

    func deletePostHard(_ postId: UUID) async throws {
        guard let client = client else {
            throw CommunityServiceError.configMissing
        }

        try await client
            .from("community_posts")
            .delete()
            .eq("id", value: postId.uuidString)
            .execute()
    }

    func banUser(_ userId: UUID) async throws {
        guard let client = client else {
            throw CommunityServiceError.configMissing
        }

        try await client
            .from("profiles")
            .update(["is_banned": .bool(true)])
            .eq("id", value: userId.uuidString)
            .execute()
    }

    func unbanUser(_ userId: UUID) async throws {
        guard let client = client else {
            throw CommunityServiceError.configMissing
        }

        try await client
            .from("profiles")
            .update(["is_banned": .bool(false)])
            .eq("id", value: userId.uuidString)
            .execute()
    }
}
