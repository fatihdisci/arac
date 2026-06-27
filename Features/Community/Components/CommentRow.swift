import SwiftUI

// MARK: - Comment Row
// Yorum satırı bileşeni.

struct CommentRow: View {
    let comment: CommunityComment
    var onReport: (() -> Void)?
    var onBlock: (() -> Void)?
    var onDelete: (() -> Void)?
    var isOwnComment: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.xxs) {
            if comment.isDeleted || comment.isHidden {
                // Silinmiş/gizli yorum
                HStack(spacing: AppSpacing.xs) {
                    Image(systemName: "eye.slash")
                        .font(.caption)
                        .foregroundColor(AppColors.textTertiary)
                    Text("Bu yorum kaldırıldı")
                        .font(AppTypography.caption)
                        .foregroundColor(AppColors.textTertiary)
                }
                .padding(.vertical, AppSpacing.xs)
            } else {
                // Author + time
                HStack(spacing: AppSpacing.xs) {
                    Image(systemName: "person.crop.circle.fill")
                        .font(.caption)
                        .foregroundColor(AppColors.textTertiary)

                    Text(comment.authorEffectiveName)
                        .font(AppTypography.captionMedium)
                        .foregroundColor(AppColors.textPrimary)
                        .lineLimit(1)

                    if comment.authorIsVerified == true {
                        Image(systemName: "checkmark.seal.fill")
                            .font(.caption2)
                            .foregroundColor(AppColors.accentPrimary)
                            .accessibilityLabel("Doğrulanmış")
                    }

                    if comment.authorRole == .admin {
                        Text("Editör")
                            .font(.system(size: 8, weight: .semibold))
                            .foregroundColor(AppColors.accentPrimary)
                            .padding(.horizontal, 4)
                            .padding(.vertical, 1)
                            .background(
                                Capsule()
                                    .fill(AppColors.accentPrimary.opacity(0.12))
                            )
                    }

                    Text("·")
                        .foregroundColor(AppColors.textTertiary)

                    Text(comment.relativeTime)
                        .font(AppTypography.caption)
                        .foregroundColor(AppColors.textTertiary)
                }

                // Body
                Text(comment.body)
                    .font(AppTypography.secondary)
                    .foregroundColor(AppColors.textPrimary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(.vertical, AppSpacing.xs)
        .contextMenu {
            if !comment.isDeleted && !comment.isHidden {
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

                if isOwnComment {
                    Divider()
                    Button(role: .destructive) {
                        onDelete?()
                    } label: {
                        Label("Sil", systemImage: "trash")
                    }
                }
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(comment.authorEffectiveName): \(comment.isDeleted ? "Bu yorum kaldırıldı" : comment.body)")
    }
}
