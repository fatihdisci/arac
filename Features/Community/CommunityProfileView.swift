import SwiftUI

// MARK: - Community Profile View
// Profil oluşturma ve düzenleme ekranı.

struct CommunityProfileView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var communityAuth: CommunityAuthService

    @State private var username: String
    @State private var displayName: String
    @State private var vehicleBrand: String
    @State private var vehicleModel: String
    @State private var vehicleYear: String
    @State private var showVehicleOnPosts: Bool
    @State private var validationError: String?
    @State private var isSaving = false
    @State private var isCheckingUsername = false
    @State private var usernameAvailable: Bool?

    @State private var usernameCheckTask: Task<Void, Never>?
    @State private var showDeleteConfirmation = false
    @State private var isDeleting = false

    private let carCatalog = CarCatalogService.shared

    init() {
        let profile = CommunityAuthService.shared.profile
        _username = State(initialValue: profile?.username ?? "")
        _displayName = State(initialValue: profile?.displayName ?? "")
        _vehicleBrand = State(initialValue: profile?.defaultVehicleBrand ?? "")
        _vehicleModel = State(initialValue: profile?.defaultVehicleModel ?? "")
        _vehicleYear = State(initialValue: profile?.defaultVehicleYear.map { String($0) } ?? "")
        _showVehicleOnPosts = State(initialValue: profile?.showVehicleOnPosts ?? false)
    }

    var body: some View {
        NavigationStack {
            Form {
                // Validation
                if let error = validationError {
                    Section {
                        Label(error, systemImage: "exclamationmark.circle.fill")
                            .font(AppTypography.caption)
                            .foregroundColor(AppColors.critical)
                    }
                    .listRowBackground(AppColors.criticalBackground)
                }

                // Username
                Section {
                    HStack(spacing: AppSpacing.sm) {
                        Image(systemName: "at")
                            .font(.body)
                            .foregroundColor(AppColors.textTertiary)
                            .frame(width: 24)
                        TextField("kullanici_adin", text: $username)
                            .font(AppTypography.body)
                            .foregroundColor(AppColors.textPrimary)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            .onChange(of: username) { _, _ in
                                checkUsername()
                            }

                        if isCheckingUsername {
                            ProgressView()
                                .scaleEffect(0.8)
                        } else if let available = usernameAvailable {
                            Image(systemName: available ? "checkmark.circle.fill" : "xmark.circle.fill")
                                .foregroundColor(available ? AppColors.success : AppColors.critical)
                                .font(.caption)
                        }
                    }
                } header: {
                    Text("Kullanıcı Adı")
                } footer: {
                    Text("Kullanıcı adın toplulukta herkese açık görünecek. Plaka bilgini paylaşma.")
                        .foregroundColor(AppColors.textTertiary)
                }

                // Display name
                Section {
                    HStack(spacing: AppSpacing.sm) {
                        Image(systemName: "person.text.rectangle")
                            .font(.body)
                            .foregroundColor(AppColors.textTertiary)
                            .frame(width: 24)
                        TextField("Görünen ad (isteğe bağlı)", text: $displayName)
                            .font(AppTypography.body)
                            .foregroundColor(AppColors.textPrimary)
                    }
                } header: {
                    Text("Görünen Ad")
                }

                // Vehicle defaults
                Section {
                    TextField("Marka (örn: Renault)", text: $vehicleBrand)
                    TextField("Model (örn: Clio)", text: $vehicleModel)
                    TextField("Yıl (örn: 2020)", text: $vehicleYear)
                        .keyboardType(.numberPad)

                    Toggle("Aracımı gönderilerimde göster", isOn: $showVehicleOnPosts)
                } header: {
                    Text("Varsayılan Araç Bilgisi (isteğe bağlı)")
                } footer: {
                    Text("Profilinde görünen araç etiketi yalnızca marka/model/yıl içerir; plaka bilgisi asla paylaşılmaz.")
                        .foregroundColor(AppColors.textTertiary)
                }

                // Hesap işlemleri
                Section {
                    Button(role: .destructive) {
                        Task { await communityAuth.signOut() }
                        dismiss()
                    } label: {
                        HStack {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                            Text("Çıkış Yap")
                        }
                    }

                    Button(role: .destructive) {
                        showDeleteConfirmation = true
                    } label: {
                        HStack {
                            Image(systemName: "trash")
                            Text(isDeleting ? "Siliniyor..." : "Hesabı Sil")
                        }
                    }
                    .disabled(isDeleting)
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color.appBackground)
            .navigationTitle(communityAuth.profile == nil ? "Profil Oluştur" : "Profili Düzenle")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("İptal") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Kaydet") { save() }
                        .fontWeight(.semibold)
                        .disabled(isSaving)
                }
            }
            .alert("Hesabı ve verileri sil?", isPresented: $showDeleteConfirmation) {
                Button("Vazgeç", role: .cancel) {}
                Button("Sil", role: .destructive) {
                    Task { await deleteAccount() }
                }
            } message: {
                Text("Bu işlem yerel araç kayıtlarını, belgeleri ve topluluk profil bilgilerini silebilir. Bu işlem geri alınamaz.")
            }
        }
    }

    private func deleteAccount() async {
        isDeleting = true
        do {
            try await communityAuth.deleteAccount()
            dismiss()
        } catch {
            validationError = "Hesap silinemedi: \(error.localizedDescription)"
        }
        isDeleting = false
    }

    private func checkUsername() {
        usernameCheckTask?.cancel()
        let trimmed = username.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmed.count >= 3 else {
            usernameAvailable = nil
            return
        }

        // Don't re-check own username
        if trimmed == communityAuth.profile?.username {
            usernameAvailable = true
            return
        }

        usernameCheckTask = Task {
            isCheckingUsername = true
            do {
                let available = try await CommunityProfileService.shared.checkUsernameAvailability(trimmed)
                if !Task.isCancelled {
                    usernameAvailable = available
                }
            } catch {
                if !Task.isCancelled {
                    usernameAvailable = nil
                }
            }
            if !Task.isCancelled {
                isCheckingUsername = false
            }
        }
    }

    private func save() {
        let trimmedUsername = username.trimmingCharacters(in: .whitespacesAndNewlines)

        if let error = CommunityProfile.validateUsername(trimmedUsername) {
            validationError = error
            return
        }

        if let error = CommunityProfile.validateDisplayName(
            displayName.isEmpty ? nil : displayName.trimmingCharacters(in: .whitespacesAndNewlines)
        ) {
            validationError = error
            return
        }

        validationError = nil
        isSaving = true

        Task {
            do {
                guard let session = communityAuth.currentSession else {
                    validationError = "Oturum bulunamadı."
                    isSaving = false
                    return
                }

                let userId = session.user.id
                let dn = displayName.trimmingCharacters(in: .whitespacesAndNewlines)

                if communityAuth.profile == nil {
                    // Create
                    _ = try await CommunityProfileService.shared.createProfile(
                        userId: userId,
                        username: trimmedUsername,
                        displayName: dn.isEmpty ? nil : dn
                    )
                } else {
                    // Update
                    let yearInt = Int(vehicleYear.trimmingCharacters(in: .whitespacesAndNewlines))
                    _ = try await CommunityProfileService.shared.updateProfile(
                        userId: userId,
                        username: trimmedUsername,
                        displayName: dn.isEmpty ? nil : dn,
                        defaultVehicleBrand: vehicleBrand.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : vehicleBrand.trimmingCharacters(in: .whitespacesAndNewlines),
                        defaultVehicleModel: vehicleModel.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : vehicleModel.trimmingCharacters(in: .whitespacesAndNewlines),
                        defaultVehicleYear: yearInt,
                        showVehicleOnPosts: showVehicleOnPosts
                    )
                }

                await communityAuth.fetchProfile(userId: userId)
                dismiss()
            } catch {
                validationError = "Kaydedilemedi: \(error.localizedDescription)"
            }
            isSaving = false
        }
    }
}

// MARK: - Preview

#Preview("Create Profile") {
    CommunityProfileView()
        .environmentObject(CommunityAuthService.shared)
}
