import SwiftUI

// MARK: - Community Feed View
// Topluluk ana ekranı. Auth state'e göre farklı durumlar gösterir.

struct CommunityFeedView: View {
    @EnvironmentObject private var communityAuth: CommunityAuthService
    @EnvironmentObject private var paywallService: PaywallService

    @State private var posts: [CommunityPost] = []
    @State private var isLoading = true
    @State private var error: String?
    @State private var selectedType: PostType?
    @State private var selectedTags: Set<String> = []
    @State private var showProfile = false
    @State private var showCreatePost = false
    @State private var selectedPostId: UUID?
    @State private var showModeration = false
    @State private var showPaywall = false

    // Profile creation (first-time)
    @State private var usernameInput = ""
    @State private var displayNameInput = ""
    @State private var profileValidationError: String?
    @State private var isCreatingProfile = false

    var body: some View {
        NavigationStack {
            Group {
                if !communityAuth.isCommunityAvailable {
                    configMissingView
                } else if communityAuth.isSigningIn {
                    signingInView
                } else if !communityAuth.isAuthenticated {
                    signedOutView
                } else if communityAuth.needsProfileCreation {
                    profileCreationView
                } else {
                    feedView
                }
            }
            .navigationTitle("Topluluk")
            .toolbar {
                if communityAuth.isAuthenticated && !communityAuth.needsProfileCreation {
                    ToolbarItem(placement: .primaryAction) {
                        HStack(spacing: AppSpacing.sm) {
                            // Moderation (admin/moderator only)
                            if communityAuth.profile?.isModerator == true {
                                Button {
                                    showModeration = true
                                } label: {
                                    Image(systemName: "shield")
                                        .foregroundColor(AppColors.accentPrimary)
                                }
                                .accessibilityLabel("Moderasyon")
                            }

                            // Create post
                            Button {
                                handleCreatePostTap()
                            } label: {
                                Image(systemName: "square.and.pencil")
                                    .foregroundColor(AppColors.accentPrimary)
                            }
                            .accessibilityLabel("Yeni Gönderi")

                            // Profile
                            Button {
                                showProfile = true
                            } label: {
                                Image(systemName: "person.crop.circle")
                                    .foregroundColor(AppColors.accentPrimary)
                            }
                            .accessibilityLabel("Profil")
                        }
                    }
                }
            }
            .sheet(isPresented: $showProfile) {
                CommunityProfileView()
            }
            .sheet(isPresented: $showCreatePost, onDismiss: {
                Task { await refreshPosts() }
            }) {
                CommunityCreatePostView()
            }
            .sheet(item: $selectedPostId) { postId in
                CommunityPostDetailView(postId: postId)
            }
            .sheet(isPresented: $showModeration) {
                CommunityModerationView()
            }
            .sheet(isPresented: $showPaywall) {
                PaywallView(feature: .communityWrite)
            }
        }
        .environmentObject(communityAuth)
    }

    // MARK: - Config Missing

    private var configMissingView: some View {
        CommunityEmptyStateView(state: .configMissing)
    }

    // MARK: - Signing In

    private var signingInView: some View {
        VStack(spacing: AppSpacing.lg) {
            ProgressView()
                .scaleEffect(1.2)
            Text("Giriş yapılıyor...")
                .font(AppTypography.secondary)
                .foregroundColor(AppColors.textSecondary)
        }
        .frame(maxHeight: .infinity)
    }

    // MARK: - Signed Out

    private var signedOutView: some View {
        VStack(spacing: AppSpacing.xxl) {
            Spacer()

            EmptyStateView(
                icon: "person.crop.circle.badge.questionmark",
                title: "Topluluğa katıl",
                description: "Araç haberlerini, bakım tavsiyelerini ve kullanıcı deneyimlerini okumak için Apple ile giriş yap.",
                actionTitle: "Apple ile Giriş Yap",
                action: {
                    Task { try? await communityAuth.signInWithApple() }
                }
            )

            Spacer()

            if let error = communityAuth.authError {
                Text(error)
                    .font(AppTypography.caption)
                    .foregroundColor(AppColors.critical)
                    .padding(.horizontal, AppSpacing.screenMarginH)
            }
        }
    }

    // MARK: - Profile Creation (inline)

    private var profileCreationView: some View {
        ScrollView {
            VStack(spacing: AppSpacing.lg) {
                Spacer().frame(height: AppSpacing.xl)

                VStack(spacing: AppSpacing.xs) {
                    Image(systemName: "person.crop.circle.badge.plus")
                        .font(.system(size: 48, weight: .light))
                        .foregroundColor(AppColors.accentPrimary)

                    Text("Profilini oluşturalım")
                        .font(AppTypography.sectionTitle)
                        .foregroundColor(AppColors.textPrimary)

                    Text("Toplulukta güvenli bir deneyim için kullanıcı adını belirle.")
                        .font(AppTypography.secondary)
                        .foregroundColor(AppColors.textSecondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, AppSpacing.screenMarginH)

                VStack(spacing: AppSpacing.md) {
                    // Username field
                    VStack(alignment: .leading, spacing: AppSpacing.xxs) {
                        HStack(spacing: AppSpacing.sm) {
                            Image(systemName: "at")
                                .font(.body)
                                .foregroundColor(AppColors.textTertiary)
                                .frame(width: 24)
                            TextField("kullanici_adin", text: $usernameInput)
                                .font(AppTypography.body)
                                .foregroundColor(AppColors.textPrimary)
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                        }
                        .padding(AppSpacing.md)
                        .background(
                            RoundedRectangle(cornerRadius: AppRadius.medium)
                                .fill(Color.appSurface)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: AppRadius.medium)
                                .stroke(AppColors.border, lineWidth: 1)
                        )

                        Text("Kullanıcı adın toplulukta herkese açık görünecek. Plaka bilgini paylaşma.")
                            .font(AppTypography.caption)
                            .foregroundColor(AppColors.textTertiary)
                            .padding(.horizontal, 4)
                    }

                    // Display name field
                    VStack(alignment: .leading, spacing: AppSpacing.xxs) {
                        HStack(spacing: AppSpacing.sm) {
                            Image(systemName: "person.text.rectangle")
                                .font(.body)
                                .foregroundColor(AppColors.textTertiary)
                                .frame(width: 24)
                            TextField("Görünen ad (isteğe bağlı)", text: $displayNameInput)
                                .font(AppTypography.body)
                                .foregroundColor(AppColors.textPrimary)
                        }
                        .padding(AppSpacing.md)
                        .background(
                            RoundedRectangle(cornerRadius: AppRadius.medium)
                                .fill(Color.appSurface)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: AppRadius.medium)
                                .stroke(AppColors.border, lineWidth: 1)
                        )
                    }

                    if let error = profileValidationError {
                        Label(error, systemImage: "exclamationmark.circle.fill")
                            .font(AppTypography.caption)
                            .foregroundColor(AppColors.critical)
                    }
                }
                .padding(.horizontal, AppSpacing.screenMarginH)

                Button {
                    createProfile()
                } label: {
                    HStack {
                        if isCreatingProfile {
                            ProgressView()
                                .tint(.white)
                        }
                        Text("Profili Oluştur")
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, AppSpacing.md)
                }
                .buttonStyle(.primary)
                .padding(.horizontal, AppSpacing.screenMarginH)
                .disabled(isCreatingProfile || usernameInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)

                Spacer()
            }
        }
        .background(Color.appBackground)
    }

    // MARK: - Feed View

    private var feedView: some View {
        VStack(spacing: 0) {
            // Filter chips
            CommunityFilterChips(selectedType: $selectedType, selectedTags: $selectedTags)
                .padding(.vertical, AppSpacing.xs)
                .onChange(of: selectedType) { _, _ in
                    Task { await loadPosts() }
                }

            // Content
            if isLoading {
                Spacer()
                ProgressView()
                    .scaleEffect(1.2)
                Text("Gönderiler yükleniyor...")
                    .font(AppTypography.secondary)
                    .foregroundColor(AppColors.textSecondary)
                    .padding(.top, AppSpacing.md)
                Spacer()
            } else if let error = error {
                Spacer()
                ErrorStateView(
                    title: "Yükleme Hatası",
                    message: "\(error)",
                    retryAction: { Task { await loadPosts() } }
                )
                Spacer()
            } else if posts.isEmpty {
                Spacer()
                CommunityEmptyStateView(state: .noPosts)
                Spacer()
            } else {
                List {
                    ForEach(posts) { post in
                        PostCard(
                            post: post,
                            onLike: { Task { await handleLike(post) } },
                            onSave: { Task { await handleSave(post) } },
                            onReport: { handleReport(post) },
                            onBlock: { Task { await handleBlock(post) } }
                        )
                        .listRowInsets(EdgeInsets(
                            top: AppSpacing.xs,
                            leading: AppSpacing.screenMarginH,
                            bottom: AppSpacing.xs,
                            trailing: AppSpacing.screenMarginH
                        ))
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            selectedPostId = post.id
                        }
                    }
                }
                .listStyle(.plain)
                .refreshable {
                    await refreshPosts()
                }
                .scrollContentBackground(.hidden)
            }
        }
        .background(Color.appBackground)
        .task {
            await loadPosts()
        }
    }

    // MARK: - Actions

    private func loadPosts() async {
        isLoading = true
        error = nil
        do {
            posts = try await CommunityService.shared.fetchPosts(type: selectedType)
        } catch {
            self.error = error.localizedDescription
        }
        isLoading = false
    }

    private func refreshPosts() async {
        do {
            posts = try await CommunityService.shared.fetchPosts(type: selectedType)
            error = nil
        } catch {
            // Keep existing posts on refresh error
        }
    }

    private func handleLike(_ post: CommunityPost) async {
        do {
            let isLiked = try await CommunityService.shared.toggleLike(postId: post.id)
            if let index = posts.firstIndex(where: { $0.id == post.id }) {
                posts[index].isLikedByCurrentUser = isLiked
                posts[index].likeCount += isLiked ? 1 : -1
            }
        } catch {
            // Silently fail — user can retry
        }
    }

    private func handleSave(_ post: CommunityPost) async {
        do {
            let isSaved = try await CommunityService.shared.toggleSave(postId: post.id)
            if let index = posts.firstIndex(where: { $0.id == post.id }) {
                posts[index].isSavedByCurrentUser = isSaved
                posts[index].saveCount += isSaved ? 1 : -1
            }
        } catch {
            // Silently fail
        }
    }

    private func handleReport(_ post: CommunityPost) {
        // Open report sheet — handled by PostCard context menu
    }

    private func handleBlock(_ post: CommunityPost) async {
        do {
            try await CommunityModerationService.shared.blockUser(userId: post.authorId)
        } catch {
            // Silently fail
        }
    }

    private func handleCreatePostTap() {
        if paywallService.isPro || communityAuth.profile?.isPro == true {
            showCreatePost = true
        } else {
            showPaywall = true
        }
    }

    private func createProfile() {
        let trimmedUsername = usernameInput.trimmingCharacters(in: .whitespacesAndNewlines)

        if let error = CommunityProfile.validateUsername(trimmedUsername) {
            profileValidationError = error
            return
        }

        if let error = CommunityProfile.validateDisplayName(
            displayNameInput.isEmpty ? nil : displayNameInput.trimmingCharacters(in: .whitespacesAndNewlines)
        ) {
            profileValidationError = error
            return
        }

        profileValidationError = nil
        isCreatingProfile = true

        Task {
            do {
                guard let session = communityAuth.currentSession else {
                    profileValidationError = "Oturum bulunamadı. Lütfen tekrar giriş yap."
                    isCreatingProfile = false
                    return
                }

                let userId = session.user.id
                let displayName = displayNameInput.trimmingCharacters(in: .whitespacesAndNewlines)

                _ = try await CommunityProfileService.shared.createProfile(
                    userId: userId,
                    username: trimmedUsername,
                    displayName: displayName.isEmpty ? nil : displayName
                )

                await communityAuth.fetchProfile(userId: userId)
                isCreatingProfile = false
            } catch {
                profileValidationError = "Profil oluşturulamadı: \(error.localizedDescription)"
                isCreatingProfile = false
            }
        }
    }
}

// MARK: - Preview

#Preview("Signed Out") {
    CommunityFeedView()
        .environmentObject(CommunityAuthService.shared)
        .environmentObject(PaywallService.shared)
}

#Preview("Config Missing") {
    CommunityFeedView()
        .environmentObject(CommunityAuthService.shared)
        .environmentObject(PaywallService.shared)
}
