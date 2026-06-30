import Foundation

// MARK: - Arvia Rehber Insight Models
// AI-ready surface: v1 uses only rule-based local insights.

struct VehicleInsight: Identifiable, Equatable {
    let id: String
    let type: VehicleInsightType
    let priority: VehicleInsightPriority
    let source: VehicleInsightSource
    let title: String
    let body: String
    let action: VehicleInsightAction
    let relatedReminderId: UUID?

    init(
        type: VehicleInsightType,
        priority: VehicleInsightPriority,
        source: VehicleInsightSource = .ruleBased,
        title: String,
        body: String,
        action: VehicleInsightAction,
        relatedReminderId: UUID? = nil
    ) {
        self.id = relatedReminderId.map { "\(type.rawValue)-\($0.uuidString)" } ?? type.rawValue
        self.type = type
        self.priority = priority
        self.source = source
        self.title = title
        self.body = body
        self.action = action
        self.relatedReminderId = relatedReminderId
    }
}

enum VehicleInsightType: String, CaseIterable {
    case maintenance
    case missingDocument
    case saleFileReadiness
    case odometerUpdate
    case overdueReminder
    case monthlyExpensePrompt
    case upcomingReminder
    case fuelTypeGuidance
    case transmissionGuidance
    case odometerMilestone
    case seasonalGuidance
    case calendarPeriod
    case quietGoodState
}

enum VehicleInsightPriority: String {
    case info
    case warning
    case important
}

enum VehicleInsightSource: String {
    case ruleBased
    case aiGenerated
}

enum VehicleInsightDisplayContext {
    case garageDaily
    case vehicleDetailGuide(excludingReminderIds: Set<UUID> = [])
}

enum VehicleInsightAction: String, CaseIterable {
    case addServiceRecord
    case addDocument
    case openSaleFile
    case updateOdometer
    case openTodos
    case addInspectionReport
    case addReminder
    case addMTVReminder
    case addExpense
    case addFuelExpense

    var title: String {
        switch self {
        case .addServiceRecord:
            return "Bakım Kaydı Ekle"
        case .addDocument:
            return "Belge Ekle"
        case .openSaleFile:
            return "Satış Dosyasına Git"
        case .updateOdometer:
            return "Km Güncelle"
        case .openTodos:
            return "Yapılacaklara Git"
        case .addInspectionReport:
            return "Ekspertiz Ekle"
        case .addReminder:
            return "Hatırlatıcı Ekle"
        case .addMTVReminder:
            return "MTV Hatırlatıcısı Ekle"
        case .addExpense:
            return "Masraf Ekle"
        case .addFuelExpense:
            return "Yakıt Ekle"
        }
    }

    var destinationKey: String {
        switch self {
        case .addServiceRecord:
            return "serviceRecordForm"
        case .addDocument:
            return "documentForm"
        case .openSaleFile:
            return "saleFile"
        case .updateOdometer:
            return "vehicleEdit"
        case .openTodos:
            return "todosTab"
        case .addInspectionReport:
            return "inspectionReportForm"
        case .addReminder:
            return "reminderForm"
        case .addMTVReminder:
            return "mtvReminderForm"
        case .addExpense:
            return "expenseForm"
        case .addFuelExpense:
            return "fuelExpenseForm"
        }
    }
}

struct VehicleUpcomingTask: Identifiable, Equatable {
    let id: UUID
    let title: String
    let relativeText: String
    let priority: VehicleInsightPriority
    let reminderId: UUID
}

struct MonthlyExpenseSummary: Equatable {
    let total: Double
    let count: Int
    let topCategory: ExpenseCategory?

    var isEmpty: Bool { count == 0 }
}

enum QuickOdometerValidationResult: Equatable {
    case valid
    case empty
    case invalid
    case negative
    case lowerNeedsConfirmation
}
