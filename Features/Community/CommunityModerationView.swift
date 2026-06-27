import SwiftUI

// MARK: - Community Moderation View
// Admin ve moderatör için şikayet yönetim ekranı.

struct CommunityModerationView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var communityAuth: CommunityAuthService

    @State private var selectedTab: ReportStatus = .pending
    @State private var reports: [CommunityReport] = []
    @State private var isLoading = true
    @State private var error: String?

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Access guard
                if !(communityAuth.profile?.isModerator ?? false) {
                    EmptyStateView(
                        icon: "lock.shield",
                        title: "Erişim Yok",
                        description: "Bu bölüm yalnızca yönetici ve moderatörler içindir."
                    )
                } else {
                    // Segmented control
                    Picker("", selection: $selectedTab) {
                        Text("Bekleyen").tag(ReportStatus.pending)
                        Text("İncelendi").tag(ReportStatus.reviewed)
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal, AppSpacing.screenMarginH)
                    .padding(.vertical, AppSpacing.sm)

                    // Info banner
                    HStack(spacing: AppSpacing.xs) {
                        Image(systemName: "info.circle.fill")
                            .font(.caption)
                            .foregroundColor(AppColors.accentPrimary)
                        Text("Moderasyon araçları yalnızca yönetici ve moderatörler içindir.")
                            .font(AppTypography.caption)
                            .foregroundColor(AppColors.textSecondary)
                    }
                    .padding(.horizontal, AppSpacing.screenMarginH)
                    .padding(.bottom, AppSpacing.sm)

                    // Content
                    if isLoading {
                        ProgressView()
                            .frame(maxHeight: .infinity)
                    } else if let error = error {
                        ErrorStateView(
                            title: "Yükleme Hatası",
                            message: "\(error)",
                            retryAction: { Task { await load() } }
                        )
                    } else if reports.isEmpty {
                        EmptyStateView(
                            icon: "checkmark.shield",
                            title: selectedTab == .pending ? "Bekleyen bildirim yok" : "İncelenmiş bildirim yok",
                            description: ""
                        )
                    } else {
                        List {
                            ForEach(reports) { report in
                                VStack(alignment: .leading, spacing: AppSpacing.xs) {
                                    HStack {
                                        Image(systemName: report.reason.sfSymbol)
                                            .foregroundColor(reportColor(report.reason))
                                        Text(report.reason.displayName)
                                            .font(AppTypography.captionMedium)
                                        Spacer()
                                        Text(report.createdAt.formatted(date: .abbreviated, time: .omitted))
                                            .font(AppTypography.caption)
                                            .foregroundColor(AppColors.textTertiary)
                                    }

                                    Text(report.targetLabel)
                                        .font(AppTypography.secondaryMedium)

                                    if let desc = report.description, !desc.isEmpty {
                                        Text(desc)
                                            .font(AppTypography.caption)
                                            .foregroundColor(AppColors.textSecondary)
                                    }

                                    if selectedTab == .pending {
                                        HStack(spacing: AppSpacing.sm) {
                                            Button("İncelendi") {
                                                Task { await markReviewed(report) }
                                            }
                                            .buttonStyle(.secondary)
                                            .controlSize(.small)

                                            Button("Gönderiyi Gizle") {
                                                Task { await hidePost(report) }
                                            }
                                            .buttonStyle(.secondary)
                                            .controlSize(.small)

                                            Button(role: .destructive) {
                                                Task { await hardDelete(report) }
                                            } label: {
                                                Text("Sil")
                                                    .font(AppTypography.caption)
                                                    .foregroundColor(AppColors.critical)
                                            }
                                            .controlSize(.small)
                                        }
                                    }
                                }
                                .padding(.vertical, AppSpacing.xxs)
                            }
                        }
                        .listStyle(.plain)
                    }
                }
            }
            .background(Color.appBackground)
            .navigationTitle("Moderasyon")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Kapat") { dismiss() }
                }
            }
            .onChange(of: selectedTab) { _, _ in
                Task { await load() }
            }
            .task { await load() }
        }
    }

    private func load() async {
        isLoading = true
        error = nil
        do {
            reports = try await CommunityModerationService.shared.fetchReports(status: selectedTab)
        } catch {
            self.error = error.localizedDescription
        }
        isLoading = false
    }

    private func markReviewed(_ report: CommunityReport) async {
        do {
            try await CommunityModerationService.shared.markReportReviewed(report.id)
            await load()
        } catch {}
    }

    private func hidePost(_ report: CommunityReport) async {
        do {
            try await CommunityModerationService.shared.hidePost(report.targetId)
            try await CommunityModerationService.shared.markReportReviewed(report.id)
            await load()
        } catch {}
    }

    private func hardDelete(_ report: CommunityReport) async {
        do {
            try await CommunityModerationService.shared.deletePostHard(report.targetId)
            try await CommunityModerationService.shared.markReportReviewed(report.id)
            await load()
        } catch {}
    }

    private func reportColor(_ reason: ReportReason) -> Color {
        switch reason {
        case .harassment, .inappropriate: return AppColors.critical
        case .misleading, .spam: return AppColors.warning
        case .personalInfo: return AppColors.critical
        case .other: return AppColors.textTertiary
        }
    }
}
