import SwiftUI

// MARK: - Arvia Guide Card
// Calm, local guidance card for the rule-based Rehber foundation.

struct ArviaGuideCard: View {
    let insight: VehicleInsight
    let primaryAction: () -> Void
    let dismissAction: (() -> Void)?

    init(
        insight: VehicleInsight,
        primaryAction: @escaping () -> Void,
        dismissAction: (() -> Void)? = nil
    ) {
        self.insight = insight
        self.primaryAction = primaryAction
        self.dismissAction = dismissAction
    }

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            HStack(alignment: .top, spacing: AppSpacing.sm) {
                VStack(spacing: AppSpacing.xxs) {
                    Image(systemName: iconName)
                        .font(.body.weight(.semibold))
                        .foregroundColor(priorityColor)
                        .frame(width: 38, height: 38)
                        .background(
                            Circle()
                                .fill(priorityColor.opacity(0.12))
                        )
                        .accessibilityHidden(true)

                    RoundedRectangle(cornerRadius: AppRadius.capsule)
                        .fill(priorityColor.opacity(0.24))
                        .frame(width: 2, height: 28)
                }

                VStack(alignment: .leading, spacing: AppSpacing.xxs) {
                    Text("Rehber notu")
                        .font(AppTypography.captionMedium)
                        .foregroundColor(priorityColor)
                    Text(insight.title)
                        .font(AppTypography.bodyMedium)
                        .foregroundColor(AppColors.textPrimary)
                        .fixedSize(horizontal: false, vertical: true)

                    Text(insight.body)
                        .font(AppTypography.secondarySmall)
                        .foregroundColor(AppColors.textSecondary)
                        .fixedSize(horizontal: false, vertical: true)
                }

                Spacer(minLength: AppSpacing.xs)
            }

            HStack(spacing: AppSpacing.sm) {
                Button(action: primaryAction) {
                    Label(insight.action.title, systemImage: actionIconName)
                        .font(AppTypography.captionMedium)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .buttonStyle(.plain)
                .foregroundColor(AppColors.accentPrimary)
                .frame(minHeight: AppSpacing.minimumTapTarget, alignment: .leading)

                Spacer()

                if let dismissAction {
                    Button(action: dismissAction) {
                        Label("Daha sonra", systemImage: "clock")
                            .font(AppTypography.captionMedium)
                    }
                    .buttonStyle(.plain)
                    .foregroundColor(AppColors.textTertiary)
                    .frame(minHeight: AppSpacing.minimumTapTarget)
                }
            }
        }
        .padding(AppSpacing.md)
        .background(
            RoundedRectangle(cornerRadius: AppRadius.card)
                .fill(
                    LinearGradient(
                        colors: [
                            Color.appSurface,
                            priorityColor.opacity(0.055),
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: AppRadius.card)
                .stroke(priorityColor.opacity(insight.priority == .info ? 0.14 : 0.28), lineWidth: 1)
        )
        .subtleShadow()
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(insight.title). \(insight.body). \(insight.action.title)")
    }

    private var iconName: String {
        switch insight.type {
        case .maintenance:
            return "wrench.and.screwdriver"
        case .missingDocument:
            return "doc.text"
        case .saleFileReadiness:
            return "doc.richtext"
        case .odometerUpdate:
            return "gauge.with.needle"
        case .overdueReminder:
            return "bell.badge"
        case .monthlyExpensePrompt:
            return "turkishlirasign.circle"
        case .upcomingReminder:
            return "calendar.badge.clock"
        case .fuelTypeGuidance:
            return "fuelpump"
        case .transmissionGuidance:
            return "gearshape.2"
        case .odometerMilestone:
            return "flag.checkered"
        case .seasonalGuidance:
            return "sun.max"
        case .calendarPeriod:
            return "calendar"
        case .quietGoodState:
            return "checkmark.seal"
        }
    }

    private var actionIconName: String {
        switch insight.action {
        case .addServiceRecord:
            return "plus.circle"
        case .addDocument:
            return "doc.badge.plus"
        case .openSaleFile:
            return "doc.richtext"
        case .updateOdometer:
            return "gauge.with.needle"
        case .openTodos:
            return "checklist"
        case .addInspectionReport:
            return "magnifyingglass"
        case .addReminder, .addMTVReminder:
            return "bell.badge"
        case .addExpense:
            return "turkishlirasign.circle"
        case .addFuelExpense:
            return "fuelpump"
        }
    }

    private var priorityColor: Color {
        switch insight.priority {
        case .info:
            return AppColors.accentPrimary
        case .warning:
            return AppColors.warning
        case .important:
            return AppColors.critical
        }
    }
}
