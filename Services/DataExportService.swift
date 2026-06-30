import Foundation
import SwiftData

// MARK: - Data Export Service
// Verileri JSON olarak dışa aktarır. Binary dosyalar (PDF/fotoğraf) dahil edilmez.
struct DataExportService {

    struct ExportResult {
        let url: URL
        let recordCounts: [String: Int]
    }

    enum ExportError: LocalizedError {
        case serializationFailed
        case writeFailed(Error)
        case fetchFailed

        var errorDescription: String? {
            switch self {
            case .serializationFailed: return "JSON serileştirme başarısız"
            case .writeFailed(let e): return "Dosya yazılamadı: \(e.localizedDescription)"
            case .fetchFailed: return "Veri okuma başarısız"
            }
        }
    }

    static func export(context: ModelContext) throws -> ExportResult {
        let vehicles = (try? context.fetch(FetchDescriptor<Vehicle>())) ?? []
        let reminders = (try? context.fetch(FetchDescriptor<Reminder>())) ?? []
        let expenses = (try? context.fetch(FetchDescriptor<Expense>())) ?? []
        let services = (try? context.fetch(FetchDescriptor<ServiceRecord>())) ?? []
        let documents = (try? context.fetch(FetchDescriptor<VehicleDocument>())) ?? []
        let inspections = (try? context.fetch(FetchDescriptor<InspectionReport>())) ?? []
        let saleFiles = (try? context.fetch(FetchDescriptor<SaleFile>())) ?? []
        let partChanges = (try? context.fetch(FetchDescriptor<PartChange>())) ?? []

        var export: [String: Any] = [:]

        // Vehicles
        export["vehicles"] = vehicles.map { v in
            [
                "id": v.id.uuidString,
                "nickname": v.nickname,
                "plate": v.plate,
                "brand": v.brand,
                "model": v.model,
                "year": v.year as Any,
                "vehicleType": v.vehicleType.rawValue,
                "bodyType": v.bodyType as Any,
                "fuelType": v.fuelType.rawValue,
                "transmissionType": v.transmissionType?.rawValue as Any,
                "currentOdometer": v.currentOdometer,
                "purchaseDate": v.purchaseDate?.ISO8601Format() as Any,
                "purchaseOdometer": v.purchaseOdometer as Any,
                "purchasePrice": v.purchasePrice as Any,
                "usageType": v.usageType.rawValue,
                "notes": v.notes,
                "hasPhoto": v.photoFileName != nil,
                "createdAt": v.createdAt.ISO8601Format(),
                "archivedAt": v.archivedAt?.ISO8601Format() as Any,
            ] as [String: Any]
        }

        // Reminders
        export["reminders"] = reminders.map { r in
            [
                "id": r.id.uuidString,
                "vehicleId": r.vehicleId.uuidString,
                "title": r.title,
                "type": r.type.rawValue,
                "dueDate": r.dueDate?.ISO8601Format() as Any,
                "dueOdometer": r.dueOdometer as Any,
                "repeatRule": r.repeatRuleRaw as Any,
                "priority": r.priority.rawValue,
                "status": r.status.rawValue,
                "completedAt": r.completedAt?.ISO8601Format() as Any,
                "createdAt": r.createdAt.ISO8601Format(),
            ] as [String: Any]
        }

        // Expenses
        export["expenses"] = expenses.map { e in
            [
                "id": e.id.uuidString,
                "vehicleId": e.vehicleId.uuidString,
                "category": e.category.rawValue,
                "amount": e.amount,
                "currency": e.currencyCode,
                "date": e.date.ISO8601Format(),
                "odometer": e.odometer as Any,
                "vendorName": e.vendorName as Any,
                "note": e.note,
            ] as [String: Any]
        }

        // Service Records + Part Changes
        export["serviceRecords"] = services.map { s in
            [
                "id": s.id.uuidString,
                "vehicleId": s.vehicleId.uuidString,
                "serviceType": s.serviceType.rawValue,
                "date": s.date.ISO8601Format(),
                "odometer": s.odometer as Any,
                "vendorName": s.vendorName as Any,
                "laborCost": s.laborCost as Any,
                "partsCost": s.partsCost as Any,
                "totalCost": s.totalCost as Any,
                "oilType": s.oilType as Any,
                "notes": s.notes,
            ] as [String: Any]
        }

        // Part Changes
        export["partChanges"] = partChanges.map { p in
            [
                "id": p.id.uuidString,
                "serviceRecordId": p.serviceRecordId.uuidString,
                "partType": p.partType.rawValue,
                "brand": p.brand as Any,
                "model": p.model as Any,
                "warrantyUntil": p.warrantyUntil?.ISO8601Format() as Any,
                "note": p.note,
                "createdAt": p.createdAt.ISO8601Format(),
            ] as [String: Any]
        }

        // Documents (metadata only)
        export["documents"] = documents.map { d in
            [
                "id": d.id.uuidString,
                "vehicleId": d.vehicleId.uuidString,
                "type": d.type.rawValue,
                "title": d.title,
                "originalFileName": d.originalFileName as Any,
                "issueDate": d.issueDate?.ISO8601Format() as Any,
                "expiryDate": d.expiryDate?.ISO8601Format() as Any,
                "includeInSaleFile": d.includeInSaleFile,
            ] as [String: Any]
        }

        // Inspection Reports
        export["inspectionReports"] = inspections.map { i in
            [
                "id": i.id.uuidString,
                "vehicleId": i.vehicleId.uuidString,
                "providerName": i.providerName,
                "reportDate": i.reportDate.ISO8601Format(),
                "odometer": i.odometer as Any,
                "summary": i.summary,
                "includeInSaleFile": i.includeInSaleFile,
            ] as [String: Any]
        }

        // Sale Files
        export["saleFiles"] = saleFiles.map { sf in
            [
                "id": sf.id.uuidString,
                "vehicleId": sf.vehicleId.uuidString,
                "title": sf.title,
                "createdAt": sf.createdAt.ISO8601Format(),
                "hasPDF": sf.generatedPDFFileName != nil,
            ] as [String: Any]
        }

        // Metadata
        let counts: [String: Int] = [
            "vehicles": vehicles.count,
            "reminders": reminders.count,
            "expenses": expenses.count,
            "serviceRecords": services.count,
            "partChanges": partChanges.count,
            "documents": documents.count,
            "inspectionReports": inspections.count,
            "saleFiles": saleFiles.count,
        ]

        export["exportDate"] = Date().ISO8601Format()
        export["appVersion"] = AppEnvironment.appVersion
        export["recordCounts"] = counts
        export["note"] = "Belge dosyaları (PDF/fotoğraf) JSON içine dahil edilmez."

        guard let jsonData = try? JSONSerialization.data(withJSONObject: export, options: .prettyPrinted) else {
            throw ExportError.serializationFailed
        }

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateStr = formatter.string(from: Date())
        let filename = "arvia-export-\(dateStr).json"
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(filename)

        do {
            try jsonData.write(to: tempURL)
        } catch {
            throw ExportError.writeFailed(error)
        }

        return ExportResult(url: tempURL, recordCounts: counts)
    }
}
