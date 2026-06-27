import SwiftUI

// MARK: - Community Feed View
// Topluluk ana ekranı. Auth state'e göre farklı durumlar gösterir.
// Phase 0.5: Spike — auth zincirini test etmek için minimal UI.

struct CommunityFeedView: View {
    @EnvironmentObject private var communityAuth: CommunityAuthService

    @State private var showProfileSheet = false
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
                    authenticatedView
                }
            }
            .navigationTitle("Topluluk")
            .toolbar {
                if communityAuth.isAuthenticated && !communityAuth.needsProfileCreation {
                    ToolbarItem(placement: .primaryAction) {
                        Button {
                            showProfileSheet = true
                        } label: {
                            Image(systemName: "person.crop.circle")
                                .foregroundColor(AppColors.accentPrimary)
                        }
                        .accessibilityLabel("Profil")
                    }
                }
            }
            .sheet(isPresented: $showProfileSheet) {
                // Phase 3'te CommunityProfileView ile değişecek
                profilePreviewSheet
            }
        }
    }

    // MARK: - Config Missing

    private var configMissingView: some View {
        EmptyStateView(
            icon: "gearshape.2",
            title: "Topluluk hazırlanıyor",
            description: "Topluluk özelliği şu anda yapılandırılıyor. Lütfen daha sonra tekrar kontrol et."
        )
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

    // MARK: - Profile Creation

    private var profileCreationView: some View {
        ScrollView {
            VStack(spacing: AppSpacing.lg) {
                Spacer().frame(height: AppSpacing.xl)

                // Header
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

                // Form
                VStack(spacing: AppSpacing.md) {
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

                    // Validation error
                    if let error = profileValidationError {
                        Label(error, systemImage: "exclamationmark.circle.fill")
                            .font(AppTypography.caption)
                            .foregroundColor(AppColors.critical)
                    }
                }
                .padding(.horizontal, AppSpacing.screenMarginH)

                // CTA
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

    // MARK: - Authenticated + Has Profile

    private var authenticatedView: some View {
        VStack(spacing: AppSpacing.lg) {
            Spacer()

            VStack(spacing: AppSpacing.xs) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 48, weight: .light))
                    .foregroundColor(AppColors.success)

                Text("Auth OK")
                    .font(AppTypography.sectionTitle)
                    .foregroundColor(AppColors.textPrimary)

                if let profile = communityAuth.profile {
                    Text("Kullanıcı: @\(profile.username)")
                        .font(AppTypography.secondary)
                        .foregroundColor(AppColors.textSecondary)

                    if profile.role == .admin {
                        HStack(spacing: 4) {
                            Image(systemName: "checkmark.seal.fill")
                                .font(.caption)
                                .foregroundColor(AppColors.accentPrimary)
                            Text("Garajım Editörü")
                                .font(AppTypography.caption)
                                .foregroundColor(AppColors.accentPrimary)
                        }
                    }

                    if profile.isPro {
                        Text("Pro Üye")
                            .font(AppTypography.caption)
                            .foregroundColor(AppColors.success)
                    }
                }
            }

            // Phase 3 - Phase 4'te gerçek feed buraya gelecek
            Text("Topluluk akışı yakında burada olacak.")
                .font(AppTypography.secondary)
                .foregroundColor(AppColors.textTertiary)
                .padding(.top, AppSpacing.lg)

            Spacer()

            // Sign Out
            Button {
                Task { await communityAuth.signOut() }
            } label: {
                Text("Çıkış Yap")
                    .font(AppTypography.secondary)
                    .foregroundColor(AppColors.critical)
            }
            .padding(.bottom, AppSpacing.xl)
        }
        .background(Color.appBackground)
    }

    // MARK: - Profile Preview Sheet

    private var profilePreviewSheet: some View {
        NavigationStack {
            VStack(spacing: AppSpacing.lg) {
                if let profile = communityAuth.profile {
                    List {
                        Section {
                            HStack(spacing: AppSpacing.md) {
                                Image(systemName: "person.crop.circle.fill")
                                    .font(.system(size: 48))
                                    .foregroundColor(AppColors.textTertiary)

                                VStack(alignment: .leading, spacing: 2) {
                                    Text(profile.effectiveDisplayName)
                                        .font(AppTypography.cardTitle)
                                    Text("@\(profile.username)")
                                        .font(AppTypography.secondary)
                                        .foregroundColor(AppColors.textSecondary)
                                }
                            }
                            .padding(.vertical, AppSpacing.xs)
                        }

                        Section("Hesap") {
                            Button(role: .destructive) {
                                Task { await communityAuth.signOut() }
                            } label: {
                                Label("Çıkış Yap", systemImage: "rectangle.portrait.and.arrow.right")
                            }
                        }
                    }
                }
            }
            .navigationTitle("Profil")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Kapat") {
                        showProfileSheet = false
                    }
                }
            }
        }
    }

    // MARK: - Actions

    private func createProfile() {
        let trimmedUsername = usernameInput.trimmingCharacters(in: .whitespacesAndNewlines)

        // Client-side validation
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

                // Profili yeniden çek
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
}

#Preview("Config Missing") {
    CommunityFeedView()
        .environmentObject(CommunityAuthService.shared)
}
