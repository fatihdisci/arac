import Foundation

// MARK: - Car Catalog Models

struct CarCatalog: Decodable {
    let version: Int
    let locale: String
    let market: String
    let lastUpdated: String
    let sourceNotes: [String]
    let brands: [CarBrand]
}

struct CarBrand: Decodable, Identifiable, Hashable {
    let id: String
    let displayName: String
    let aliases: [String]
    let category: String
    let models: [CarModel]
}

struct CarModel: Decodable, Identifiable, Hashable {
    let id: String
    let displayName: String
    let aliases: [String]
    let bodyTypes: [String]
    let isCommonInTurkey: Bool
}

// MARK: - Vehicle Catalog Selection

struct VehicleCatalogSelection: Equatable {
    var brand: String
    var model: String

    mutating func selectBrand(_ newBrand: String) {
        if brand != newBrand {
            brand = newBrand
            model = ""
        }
    }

    func validationErrors() -> [String] {
        var errors: [String] = []
        if brand.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            errors.append("Marka zorunludur.")
        }
        if model.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            errors.append("Model zorunludur.")
        }
        return errors
    }
}

// MARK: - Car Catalog Service

final class CarCatalogService {
    static let shared = CarCatalogService()

    static let otherBrandTitle = "Diğer Marka"
    static let otherModelTitle = "Diğer Model"

    let catalog: CarCatalog?

    init(bundle: Bundle = .main) {
        catalog = Self.loadCatalog(bundle: bundle)
    }

    private static func loadCatalog(bundle: Bundle) -> CarCatalog? {
        guard let url = bundle.url(forResource: "CarCatalog.tr", withExtension: "json") else {
            return nil
        }
        do {
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode(CarCatalog.self, from: data)
        } catch {
            #if DEBUG
            print("CarCatalog load failed: \(error.localizedDescription)")
            #endif
            return nil
        }
    }

    var brands: [CarBrand] {
        (catalog?.brands ?? []).sorted { normalized($0.displayName) < normalized($1.displayName) }
    }

    func models(for brand: CarBrand) -> [CarModel] {
        brand.models.sorted { normalized($0.displayName) < normalized($1.displayName) }
    }

    func searchBrands(_ query: String) -> [CarBrand] {
        let sortedBrands = brands
        let q = normalized(query)
        guard !q.isEmpty else { return sortedBrands }
        return sortedBrands.filter { brand in
            searchableTokens(for: brand.displayName, aliases: brand.aliases).contains { $0.contains(q) }
        }
    }

    func searchModels(in brand: CarBrand, query: String) -> [CarModel] {
        let sortedModels = models(for: brand)
        let q = normalized(query)
        guard !q.isEmpty else { return sortedModels }
        return sortedModels.filter { model in
            searchableTokens(for: model.displayName, aliases: model.aliases).contains { $0.contains(q) }
        }
    }

    func brand(named name: String) -> CarBrand? {
        let q = normalized(name)
        return brands.first { brand in
            searchableTokens(for: brand.displayName, aliases: brand.aliases).contains(q)
        }
    }

    func model(named name: String, in brand: CarBrand) -> CarModel? {
        let q = normalized(name)
        return models(for: brand).first { model in
            searchableTokens(for: model.displayName, aliases: model.aliases).contains(q)
        }
    }

    func normalized(_ value: String) -> String {
        value
            .folding(options: [.diacriticInsensitive, .caseInsensitive], locale: Locale(identifier: "tr_TR"))
            .replacingOccurrences(of: "ı", with: "i")
            .replacingOccurrences(of: "İ", with: "i")
            .lowercased(with: Locale(identifier: "tr_TR"))
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private func searchableTokens(for displayName: String, aliases: [String]) -> [String] {
        ([displayName] + aliases).map(normalized)
    }
}
