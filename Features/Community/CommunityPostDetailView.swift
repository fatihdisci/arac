import SwiftUI

// MARK: - Community Post Detail View
// Gönderi detayı, yorumlar, beğeni/kaydet/şikayet.

struct CommunityPostDetailView: View {
    let postId: UUID

    @EnvironmentObject private var communityAuth: CommunityAuthService
    @EnvironmentObject private var paywallService: PaywallService

    @State private var post: CommunityPost?
    @State private var comments: [CommunityComment] = []
    @State private var isLoading = true
    @State private var error: String?
    @State private var commentText = ""
    @State private var isSubmittingComment = false
    @State private var showPaywall = false
    @State private var showReportSheet = false
    @State private var reportTarget: (type: String, id: UUID)?

    var body: some View {
        Group {
            if isLoading {
                VStack {
                    Spacer()
                    ProgressView()
                        .scaleEffect(1.2)
                    Text("Gönderi yükleniyor...")
                        .font(AppTypography.secondary)
                        .foregroundColor(AppColors.textSecondary)
                        .padding(.top, AppSpacing.md)
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let error = error {
                ErrorStateView(
                    title: "Yükleme Hatası",
                    message: "\(error)",
                    retryAction: { Task { await load() } }
                )
            } else if let post = post {
                if post.isDeleted || post.isHidden {
                    VStack {
                        Spacer()
                        CommunityEmptyStateView(state: .deletedPost)
                        Spacer()
                    }
                } else {
                    ScrollView {
                        contentView(post)
                    }
                }
            } else {
                // post nil + no error → not found
                VStack {
                    Spacer()
                    CommunityEmptyStateView(state: .deletedPost)
                    Spacer()
                }
            }
        }
        .background(Color.appBackground)
        .navigationTitle("Gönderi")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showPaywall) {
            PaywallView(feature: .communityWrite)
        }
        .sheet(isPresented: $showReportSheet) {
            if let target = reportTarget {
                ReportReasonSheet(
                    targetType: target.type,
                    targetId: target.id,
                    onDismiss: { showReportSheet = false }
                )
            }
        }
        .task { await load() }
    }

    // MARK: - Content

    private func contentView(_ post: CommunityPost) -> some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            // Author header
            authorHeader(post)

            // Post type + tags
            HStack(spacing: AppSpacing.xs) {
                Image(systemName: post.postType.sfSymbol)
                    .font(.caption)
                    .foregroundColor(AppColors.accentPrimary)
                Text(post.postType.displayName)
                    .font(AppTypography.captionMedium)
                    .foregroundColor(AppColors.accentPrimary)

                if let vehicle = post.vehicleLabel {
                    Text("·")
                        .foregroundColor(AppColors.textTertiary)
                    Text(vehicle)
                        .font(AppTypography.caption)
                        .foregroundColor(AppColors.textSecondary)
                }
            }

            // Title
            Text(post.title)
                .font(AppTypography.screenTitle)
                .foregroundColor(AppColors.textPrimary)

            // Tags
            if !post.tags.isEmpty {
                HStack(spacing: AppSpacing.xxs) {
                    ForEach(post.tags, id: \.self) { tag in
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

            // Full body
            Text(post.body)
                .font(AppTypography.body)
                .foregroundColor(AppColors.textPrimary)
                .fixedSize(horizontal: false, vertical: true)

            // Action bar
            actionBar(post)

            Divider()
                .background(AppColors.divider)

            // Comments
            commentsSection(post)
        }
        .padding(AppSpacing.md)
    }

    // MARK: - Author Header

    private func authorHeader(_ post: CommunityPost) -> some View {
        HStack(spacing: AppSpacing.sm) {
            Image(systemName: "person.crop.circle.fill")
                .font(.title2)
                .foregroundColor(AppColors.textTertiary)

            VStack(alignment: .leading, spacing: 0) {
                HStack(spacing: 4) {
                    Text(post.authorEffectiveName)
                        .font(AppTypography.bodyMedium)
                    if post.authorIsVerified == true {
                        Image(systemName: "checkmark.seal.fill")
                            .font(.caption)
                            .foregroundColor(AppColors.accentPrimary)
                    }
                    if post.authorRole == .admin {
                        Text("Editör")
                            .font(.system(size: 9, weight: .semibold))
                            .foregroundColor(AppColors.accentPrimary)
                            .padding(.horizontal, 5)
                            .padding(.vertical, 1)
                            .background(Capsule().fill(AppColors.accentPrimary.opacity(0.12)))
                    }
                }

                if let atUsername = post.authorAtUsername {
                    Text(atUsername)
                        .font(AppTypography.caption)
                        .foregroundColor(AppColors.textTertiary)
                }

                Text(post.relativeTime)
                    .font(AppTypography.caption)
                    .foregroundColor(AppColors.textTertiary)
            }

            Spacer()
        }
    }

    // MARK: - Action Bar

    private func actionBar(_ post: CommunityPost) -> some View {
        HStack(spacing: AppSpacing.lg) {
            Button {
                Task { await toggleLike() }
            } label: {
                HStack(spacing: 4) {
                    Image(systemName: post.isLikedByCurrentUser ? "heart.fill" : "heart")
                    Text("\(post.likeCount)")
                        .font(AppTypography.caption)
                }
                .foregroundColor(post.isLikedByCurrentUser ? AppColors.critical : AppColors.textSecondary)
            }
            .buttonStyle(.plain)

            Button {
                Task { await toggleSave() }
            } label: {
                HStack(spacing: 4) {
                    Image(systemName: post.isSavedByCurrentUser ? "bookmark.fill" : "bookmark")
                    Text("\(post.saveCount)")
                        .font(AppTypography.caption)
                }
                .foregroundColor(post.isSavedByCurrentUser ? AppColors.accentPrimary : AppColors.textSecondary)
            }
            .buttonStyle(.plain)

            Spacer()

            Button {
                reportTarget = ("post", post.id)
                showReportSheet = true
            } label: {
                Image(systemName: "flag")
                    .font(.caption)
                    .foregroundColor(AppColors.textTertiary)
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Bildir")
        }
    }

    // MARK: - Comments Section

    private func commentsSection(_ post: CommunityPost) -> some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            Text("Yorumlar")
                .font(AppTypography.sectionTitle)
                .foregroundColor(AppColors.textPrimary)

            // Comment composer
            if paywallService.canWriteComment() {
                HStack(spacing: AppSpacing.sm) {
                    TextField("Yorum yaz...", text: $commentText)
                        .font(AppTypography.secondary)
                        .foregroundColor(AppColors.textPrimary)
                        .padding(AppSpacing.sm)
                        .background(
                            RoundedRectangle(cornerRadius: AppRadius.medium)
                                .fill(AppColors.surfaceSecondary)
                        )
                        .disabled(isSubmittingComment)

                    Button {
                        Task { await submitComment() }
                    } label: {
                        if isSubmittingComment {
                            ProgressView()
                                .tint(AppColors.accentPrimary)
                        } else {
                            Image(systemName: "paperplane.fill")
                                .foregroundColor(
                                    commentText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                                    ? AppColors.textTertiary : AppColors.accentPrimary
                                )
                        }
                    }
                    .disabled(commentText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || isSubmittingComment)
                }
            } else {
                // Free user upsell
                VStack(spacing: AppSpacing.xs) {
                    HStack(spacing: AppSpacing.xs) {
                        Image(systemName: "crown")
                            .font(.caption)
                            .foregroundColor(AppColors.warning)
                        Text("Toplulukta paylaşım yapmak Pro üyeler içindir")
                            .font(AppTypography.caption)
                            .foregroundColor(AppColors.textSecondary)
                    }

                    Button("Pro'ya Geç") {
                        showPaywall = true
                    }
                    .buttonStyle(.secondary)
                }
                .padding(AppSpacing.md)
                .background(
                    RoundedRectangle(cornerRadius: AppRadius.medium)
                        .fill(AppColors.surfaceSecondary)
                )
            }

            // Comments list
            if comments.isEmpty {
                Text("Henüz yorum yapılmadı. İlk yorumu sen yap.")
                    .font(AppTypography.secondary)
                    .foregroundColor(AppColors.textTertiary)
                    .padding(.vertical, AppSpacing.md)
            } else {
                ForEach(comments) { comment in
                    CommentRow(
                        comment: comment,
                        onReport: {
                            reportTarget = ("comment", comment.id)
                            showReportSheet = true
                        },
                        onBlock: {
                            Task { await blockCommentAuthor(comment) }
                        },
                        onDelete: {
                            Task { await deleteComment(comment) }
                        },
                        isOwnComment: communityAuth.profile?.id == comment.authorId
                    )
                    Divider()
                }
            }
        }
    }

    // MARK: - Actions

    private func load() async {
        isLoading = true
        error = nil
        do {
            post = try await CommunityService.shared.fetchPost(id: postId)
            comments = try await CommunityService.shared.fetchComments(postId: postId)
        } catch {
            self.error = error.localizedDescription
        }
        isLoading = false
    }

    private func toggleLike() async {
        guard var p = post else { return }
        do {
            let liked = try await CommunityService.shared.toggleLike(postId: p.id)
            p.isLikedByCurrentUser = liked
            p.likeCount += liked ? 1 : -1
            post = p
        } catch {}
    }

    private func toggleSave() async {
        guard var p = post else { return }
        do {
            let saved = try await CommunityService.shared.toggleSave(postId: p.id)
            p.isSavedByCurrentUser = saved
            p.saveCount += saved ? 1 : -1
            post = p
        } catch {}
    }

    private func submitComment() async {
        let body = commentText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !body.isEmpty, body.count <= 2000 else { return }
        isSubmittingComment = true
        do {
            _ = try await CommunityService.shared.createComment(postId: postId, body: body)
            commentText = ""
            comments = try await CommunityService.shared.fetchComments(postId: postId)
        } catch {}
        isSubmittingComment = false
    }

    private func deleteComment(_ comment: CommunityComment) async {
        do {
            try await CommunityService.shared.deleteComment(id: comment.id)
            comments.removeAll { $0.id == comment.id }
        } catch {}
    }

    private func blockCommentAuthor(_ comment: CommunityComment) async {
        do {
            try await CommunityModerationService.shared.blockUser(userId: comment.authorId)
        } catch {}
    }
}
