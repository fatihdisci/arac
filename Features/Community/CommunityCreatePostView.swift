import SwiftUI

// MARK: - Community Create/Edit Post View
// Gönderi oluşturma ve düzenleme formu. Pro gate ile korunur.

struct CommunityCreatePostView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var communityAuth: CommunityAuthService

    var editingPost: CommunityPost? = nil

    @State private var title = ""
    @State private var body = ""
    @State private var postType: PostType?
    @State private var selectedTags: Set<String> = []
    @State private var vehicleBrand: String?
    @State private var vehicleModel: String?
    @State private var vehicleYear: Int?
    @State private var showVehicle = false
    @State private var validationErrors: [String] = []
    @State private var isSubmitting = false
    @State private var submitError: String?

    private let allTags = CommunityTag.all

    var body: some View {
        NavigationStack {
            Form {
                // Validation errors
                if !validationErrors.isEmpty {
                    Section("Düzeltilmesi Gerekenler") {
                        ForEach(validationErrors, id: \.self) { error in
                            Label(error, systemImage: "exclamationmark.circle.fill")
                                .font(AppTypography.caption)
                                .foregroundColor(AppColors.critical)
                        }
                    }
                    .listRowBackground(AppColors.criticalBackground)
                }

                // Title
                Section {
                    TextField("Başlık (5-120 karakter)", text: $title)
                        .font(AppTypography.body)
                        .foregroundColor(AppColors.textPrimary)
                    Text("\(title.count)/120")
                        .font(AppTypography.caption)
                        .foregroundColor(title.count > 120 ? AppColors.critical : AppColors.textTertiary)
                } header: {
                    Text("Başlık")
                }

                // Body
                Section {
                    TextEditor(text: $body)
                        .font(AppTypography.body)
                        .foregroundColor(AppColors.textPrimary)
                        .frame(minHeight: 140)
                        .overlay(alignment: .topLeading) {
                            if body.isEmpty {
                                Text("İçerik (20-5000 karakter)")
                                    .font(AppTypography.body)
                                    .foregroundColor(AppColors.textTertiary)
                                    .padding(.top, 8)
                                    .padding(.leading, 4)
                                    .allowsHitTesting(false)
                            }
                        }
                    Text("\(body.count)/5000")
                        .font(AppTypography.caption)
                        .foregroundColor(body.count > 5000 ? AppColors.critical : AppColors.textTertiary)
                } header: {
                    Text("İçerik")
                }

                // Post type
                Section {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: AppSpacing.xs) {
                        ForEach(PostType.allCases, id: \.self) { type in
                            Button {
                                postType = type
                            } label: {
                                HStack(spacing: 4) {
                                    Image(systemName: type.sfSymbol)
                                        .font(.caption)
                                    Text(type.displayName)
                                        .font(AppTypography.caption)
                                }
                                .padding(.horizontal, AppSpacing.sm)
                                .padding(.vertical, AppSpacing.xs)
                                .frame(maxWidth: .infinity)
                                .background(
                                    RoundedRectangle(cornerRadius: AppRadius.medium)
                                        .fill(postType == type ? AppColors.accentPrimary : AppColors.surfaceSecondary)
                                )
                                .foregroundColor(postType == type ? .white : AppColors.textSecondary)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                } header: {
                    Text("Gönderi Türü")
                }

                // Tags
                Section {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 90))], spacing: AppSpacing.xxs) {
                        ForEach(allTags, id: \.self) { tag in
                            Button {
                                if selectedTags.contains(tag) {
                                    selectedTags.remove(tag)
                                } else {
                                    selectedTags.insert(tag)
                                }
                            } label: {
                                Text(tag)
                                    .font(AppTypography.caption)
                                    .padding(.horizontal, AppSpacing.sm)
                                    .padding(.vertical, 6)
                                    .frame(maxWidth: .infinity)
                                    .background(
                                        Capsule()
                                            .fill(selectedTags.contains(tag) ? AppColors.accentPrimary : AppColors.surfaceSecondary)
                                    )
                                    .foregroundColor(selectedTags.contains(tag) ? .white : AppColors.textSecondary)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                } header: {
                    Text("Etiketler (en az 1)")
                }

                // Vehicle info
                Section {
                    Toggle("Aracımı gönderide göster", isOn: $showVehicle)
                    if showVehicle {
                        TextField("Marka", text: Binding(
                            get: { vehicleBrand ?? "" },
                            set: { vehicleBrand = $0.isEmpty ? nil : $0 }
                        ))
                        TextField("Model", text: Binding(
                            get: { vehicleModel ?? "" },
                            set: { vehicleModel = $0.isEmpty ? nil : $0 }
                        ))
                        TextField("Yıl", value: $vehicleYear, format: .number.grouping(.never))
                            .keyboardType(.numberPad)
                    }
                } header: {
                    Text("Araç Bilgisi (isteğe bağlı)")
                } footer: {
                    Text("Plaka bilgisini paylaşma. Yalnızca marka/model/yıl gösterilir.")
                        .font(AppTypography.caption)
                        .foregroundColor(AppColors.textTertiary)
                }

                // Submit error
                if let submitError = submitError {
                    Section {
                        Text(submitError)
                            .font(AppTypography.caption)
                            .foregroundColor(AppColors.critical)
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color.appBackground)
            .navigationTitle(editingPost != nil ? "Gönderiyi Düzenle" : "Yeni Gönderi")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("İptal") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(editingPost != nil ? "Güncelle" : "Paylaş") {
                        submit()
                    }
                    .fontWeight(.semibold)
                    .disabled(isSubmitting)
                }
            }
            .onAppear {
                if let post = editingPost {
                    title = post.title
                    body = post.body
                    postType = post.postType
                    selectedTags = Set(post.tags)
                    vehicleBrand = post.vehicleBrand
                    vehicleModel = post.vehicleModel
                    vehicleYear = post.vehicleYear
                    showVehicle = post.vehicleBrand != nil
                } else if let profile = communityAuth.profile, profile.showVehicleOnPosts {
                    vehicleBrand = profile.defaultVehicleBrand
                    vehicleModel = profile.defaultVehicleModel
                    vehicleYear = profile.defaultVehicleYear
                    showVehicle = profile.showVehicleOnPosts
                }
            }
        }
    }

    private func submit() {
        let errors = CommunityPost.validate(
            title: title,
            body: body,
            postType: postType,
            tags: Array(selectedTags)
        )

        guard errors.isValid else {
            validationErrors = errors.allErrors
            return
        }

        validationErrors = []
        isSubmitting = true
        submitError = nil

        Task {
            do {
                if let existing = editingPost {
                    try await CommunityService.shared.updatePost(
                        id: existing.id,
                        title: title.trimmingCharacters(in: .whitespacesAndNewlines),
                        body: body.trimmingCharacters(in: .whitespacesAndNewlines),
                        postType: postType!,
                        tags: Array(selectedTags),
                        vehicleBrand: showVehicle ? vehicleBrand : nil,
                        vehicleModel: showVehicle ? vehicleModel : nil,
                        vehicleYear: showVehicle ? vehicleYear : nil
                    )
                } else {
                    _ = try await CommunityService.shared.createPost(
                        title: title.trimmingCharacters(in: .whitespacesAndNewlines),
                        body: body.trimmingCharacters(in: .whitespacesAndNewlines),
                        postType: postType!,
                        tags: Array(selectedTags),
                        vehicleBrand: showVehicle ? vehicleBrand : nil,
                        vehicleModel: showVehicle ? vehicleModel : nil,
                        vehicleYear: showVehicle ? vehicleYear : nil
                    )
                }
                dismiss()
            } catch {
                submitError = "Paylaşılamadı: \(error.localizedDescription)"
            }
            isSubmitting = false
        }
    }
}
