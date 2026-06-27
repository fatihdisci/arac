import SwiftUI

// MARK: - Community Rules View
// Topluluk kuralları ekranı.

struct CommunityRulesView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: AppSpacing.lg) {
                    // Intro
                    VStack(alignment: .leading, spacing: AppSpacing.xs) {
                        Text("Toplulukta paylaşılan içerikler kullanıcı deneyimi ve kişisel görüş niteliğindedir. \(AppBrand.appName), kullanıcı paylaşımlarındaki teknik, hukuki veya ticari iddiaların doğruluğunu garanti etmez.")
                            .font(AppTypography.secondary)
                            .foregroundColor(AppColors.textSecondary)
                    }

                    Divider()

                    // Rules
                    ruleSection(
                        icon: "person.text.rectangle",
                        title: "Kişisel Bilgi Paylaşımı",
                        body: "Plaka, şasi numarası, ruhsat, kimlik, telefon numarası gibi kişisel bilgileri paylaşma."
                    )

                    ruleSection(
                        icon: "building.2",
                        title: "Yetkisiz Temsil",
                        body: "Resmi kurum, sigorta şirketi, ekspertiz firması veya servis adına yetkisiz paylaşım yapma."
                    )

                    ruleSection(
                        icon: "wrench.and.screwdriver",
                        title: "Teknik Garanti",
                        body: "Kesin mekanik teşhis, hukuki garanti veya satış taahhüdü anlamına gelebilecek ifadelerden kaçın."
                    )

                    ruleSection(
                        icon: "hand.raised",
                        title: "Saygılı İletişim",
                        body: "Diğer kullanıcılara karşı saygılı ol. Hakaret, tehdit, taciz içeren paylaşımlar yapma."
                    )

                    ruleSection(
                        icon: "exclamationmark.triangle",
                        title: "Yanıltıcı Bilgi",
                        body: "Araç değeri, yakıt tüketimi, teknik özellikler gibi konularda yanıltıcı bilgi paylaşma."
                    )

                    ruleSection(
                        icon: "megaphone.slash",
                        title: "Spam ve Reklam",
                        body: "Spam gönderiler, ticari reklamlar veya tekrarlayan içerikler paylaşma."
                    )

                    Divider()

                    // Consequences
                    ruleSection(
                        icon: "shield",
                        title: "İhlal Durumu",
                        body: "Kurallara uymayan içerikler gizlenebilir veya silinebilir. Tekrar eden ihlallerde hesabın yasaklanabilir."
                    )

                    // Footer
                    Text("Son güncelleme: Haziran 2026")
                        .font(AppTypography.caption)
                        .foregroundColor(AppColors.textTertiary)
                        .padding(.top, AppSpacing.md)
                }
                .padding(AppSpacing.screenMarginH)
            }
            .background(Color.appBackground)
            .navigationTitle("Topluluk Kuralları")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Kapat") { dismiss() }
                }
            }
        }
    }

    private func ruleSection(icon: String, title: String, body: String) -> some View {
        HStack(alignment: .top, spacing: AppSpacing.sm) {
            Image(systemName: icon)
                .font(.body)
                .foregroundColor(AppColors.accentPrimary)
                .frame(width: 28)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(AppTypography.bodyMedium)
                    .foregroundColor(AppColors.textPrimary)
                Text(body)
                    .font(AppTypography.secondary)
                    .foregroundColor(AppColors.textSecondary)
            }
        }
    }
}
