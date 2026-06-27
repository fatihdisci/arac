import SwiftUI

// MARK: - Post Card
// Topluluk akışındaki gönderi kartı bileşeni.

struct PostCard: View {
    let post: CommunityPost
    var onLike: (() -> Void)?
    var onSave: (() -> Void)?
    var onReport: (() -> Void)?
    var onBlock: (() -> Void)?
    var onUnblock: (() -> Void)?

    @State private var showContextMenu = false

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            // Author Row
            authorRow

            // Title
            Text(post.title)
                .font(AppTypography.cardTitle)
                .foregroundColor(AppColors.textPrimary)
                .lineLimit(2)

            // Vehicle label (no plate)
            if let vehicle = post.vehicleLabel {
                Text(vehicle)
                    .font(AppTypography.caption)
                    .foregroundColor(AppColors.textSecondary)
                    .padding(.horizontal, AppSpacing.xs)
                    .padding(.vertical, 2)
                    .background(
                        RoundedRectangle(cornerRadius: AppRadius.small)
                            .fill(AppColors.surfaceSecondary)
                    )
            }

            // Body preview
            Text(post.body)
                .font(AppTypography.secondary)
                .foregroundColor(AppColors.textSecondary)
                .lineLimit(3)

            // Tags
            if !post.tags.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: AppSpacing.xxs) {
                        ForEach(post.tags.prefix(5), id: \.self) { tag in
                            Text(tag)
                                .font(.system(size: 10, weight: .medium))
                                .foregroundColor(AppColors.textTertiary)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(
                                    Capsule()
                                        .fill(AppColors.surfaceSecondary)
                                )
                        }
                    }
                }
            }

            // Stats footer
            statsRow
        }
        .padding(AppSpacing.md)
        .background(
            RoundedRectangle(cornerRadius: AppRadius.card)
                .fill(Color.appSurface)
        )
        .overlay(
            // Pinned/official indicator
            post.isPinned ?
            RoundedRectangle(cornerRadius: AppRadius.card)
                .stroke(AppColors.accentPrimary.opacity(0.4), lineWidth: 1)
            : nil
        )
        .shadow(color: .black.opacity(0.04), radius: 4, y: 2)
        .contentShape(Rectangle())
        .contextMenu {
            Button {
                onReport?()
            } label: {
                Label("Bildir", systemImage: "flag")
            }

            Button {
                onBlock?()
            } label: {
                Label("Kullanıcıyı Engelle", systemImage: "nosign")
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(accessibilityLabel)
        .accessibilityHint("Detayları görmek için iki kere dokun. Basılı tutarak bildir veya engelle.")
    }

    // MARK: - Author Row

    private var authorRow: some View {
        HStack(spacing: AppSpacing.xs) {
            // Avatar placeholder
            Image(systemName: "person.crop.circle.fill")
                .font(.title3)
                .foregroundColor(AppColors.textTertiary)

            VStack(alignment: .leading, spacing: 0) {
                HStack(spacing: 4) {
                    Text(post.authorEffectiveName)
                        .font(AppTypography.secondaryMedium)
                        .foregroundColor(AppColors.textPrimary)
                        .lineLimit(1)

                    // Verified badge
                    if post.authorIsVerified == true {
                        Image(systemName: "checkmark.seal.fill")
                            .font(.caption2)
                            .foregroundColor(AppColors.accentPrimary)
                            .accessibilityLabel("Doğrulanmış hesap")
                    }

                    // Admin badge
                    if post.authorRole == .admin {
                        Text("Editör")
                            .font(.system(size: 9, weight: .semibold))
                            .foregroundColor(AppColors.accentPrimary)
                            .padding(.horizontal, 5)
                            .padding(.vertical, 1)
                            .background(
                                Capsule()
                                    .fill(AppColors.accentPrimary.opacity(0.12))
                            )
                    }
                }

                HStack(spacing: 4) {
                    if let atUsername = post.authorAtUsername {
                        Text(atUsername)
                            .font(AppTypography.caption)
                            .foregroundColor(AppColors.textTertiary)
                    }

                    Text("·")
                        .foregroundColor(AppColors.textTertiary)

                    Text(post.relativeTime)
                        .font(AppTypography.caption)
                        .foregroundColor(AppColors.textTertiary)
                }
            }

            Spacer()

            // Post type chip
            Text(post.postType.displayName)
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(AppColors.textSecondary)
                .padding(.horizontal, AppSpacing.xs)
                .padding(.vertical, 2)
                .background(
                    Capsule()
                        .fill(AppColors.surfaceSecondary)
                )
        }
    }

    // MARK: - Stats Row

    private var statsRow: some View {
        HStack(spacing: AppSpacing.md) {
            // Likes
            Button {
                onLike?()
            } label: {
                HStack(spacing: 4) {
                    Image(systemName: post.isLikedByCurrentUser ? "heart.fill" : "heart")
                        .font(.caption)
                    Text("\(post.likeCount)")
                        .font(AppTypography.caption)
                }
                .foregroundColor(post.isLikedByCurrentUser ? AppColors.critical : AppColors.textTertiary)
            }
            .buttonStyle(.plain)
            .accessibilityLabel("\(post.likeCount) beğeni")
            .accessibilityHint(post.isLikedByCurrentUser ? "Beğeniyi kaldırmak için iki kere dokun" : "Beğenmek için iki kere dokun")

            // Comments
            HStack(spacing: 4) {
                Image(systemName: "bubble.right")
                    .font(.caption)
                Text("\(post.commentCount)")
                    .font(AppTypography.caption)
            }
            .foregroundColor(AppColors.textTertiary)
            .accessibilityLabel("\(post.commentCount) yorum")

            // Saves
            Button {
                onSave?()
            } label: {
                HStack(spacing: 4) {
                    Image(systemName: post.isSavedByCurrentUser ? "bookmark.fill" : "bookmark")
                        .font(.caption)
                    Text("\(post.saveCount)")
                        .font(AppTypography.caption)
                }
                .foregroundColor(post.isSavedByCurrentUser ? AppColors.accentPrimary : AppColors.textTertiary)
            }
            .buttonStyle(.plain)
            .accessibilityLabel("\(post.saveCount) kaydeden")
            .accessibilityHint(post.isSavedByCurrentUser ? "Kaydı kaldırmak için iki kere dokun" : "Kaydetmek için iki kere dokun")
        }
    }

    // MARK: - Accessibility

    private var accessibilityLabel: String {
        var label = "\(post.authorEffectiveName). \(post.title). \(post.postType.displayName). "
        if let vehicle = post.vehicleLabel {
            label += "Araç: \(vehicle). "
        }
        label += "\(post.likeCount) beğeni, \(post.commentCount) yorum. \(post.relativeTime)."
        return label
    }
}
