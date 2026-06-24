import Foundation
import SwiftData

// MARK: - Expense Model
@Model
final class Expense {
    var id: UUID
    var vehicleId: UUID
    var categoryRaw: String
    var amount: Double
    var currencyCode: String
    var date: Date
    var odometer: Int?
    var vendorName: String?
    var note: String
    var documentIds: [UUID]
    var linkedServiceRecordId: UUID?
    var createdAt: Date

    // MARK: Computed — Enum dönüşümleri
    var category: ExpenseCategory {
        get { ExpenseCategory(rawValue: categoryRaw) ?? .other }
        set { categoryRaw = newValue.rawValue }
    }

    // MARK: Formatting helpers
    var amountDisplay: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = currencyCode
        formatter.locale = Locale(identifier: "tr_TR")
        return formatter.string(from: NSNumber(value: amount)) ?? "₺\(String(format: "%.2f", amount))"
    }

    var amountCompactDisplay: String {
        if amount >= 1000 {
            return "₺\(String(format: "%.0f", amount))"
        }
        return "₺\(String(format: "%.2f", amount))"
    }

    var dateDisplay: String {
        date.formatted(date: .abbreviated, time: .omitted)
    }

    init(
        id: UUID = UUID(),
        vehicleId: UUID,
        category: ExpenseCategory = .other,
        amount: Double = 0,
        currencyCode: String = "TRY",
        date: Date = Date(),
        odometer: Int? = nil,
        vendorName: String? = nil,
        note: String = "",
        documentIds: [UUID] = [],
        linkedServiceRecordId: UUID? = nil,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.vehicleId = vehicleId
        self.categoryRaw = category.rawValue
        self.amount = amount
        self.currencyCode = currencyCode
        self.date = date
        self.odometer = odometer
        self.vendorName = vendorName
        self.note = note
        self.documentIds = documentIds
        self.linkedServiceRecordId = linkedServiceRecordId
        self.createdAt = createdAt
    }
}
