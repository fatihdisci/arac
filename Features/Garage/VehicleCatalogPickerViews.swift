import SwiftUI

// MARK: - Vehicle Catalog Picker Rows

struct VehicleCatalogSelectionField: View {
    let title: String
    let value: String
    let placeholder: String
    let systemImage: String
    var isDisabled = false
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: AppSpacing.sm) {
                Image(systemName: systemImage)
                    .font(.body)
                    .foregroundColor(isDisabled ? AppColors.textTertiary.opacity(0.6) : AppColors.textTertiary)
                    .frame(width: 24)

                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(AppTypography.caption)
                        .foregroundColor(AppColors.textTertiary)
                    Text(value.isEmpty ? placeholder : value)
                        .font(AppTypography.body)
                        .foregroundColor(value.isEmpty ? AppColors.textSecondary : AppColors.textPrimary)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(AppColors.textTertiary)
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .disabled(isDisabled)
        .opacity(isDisabled ? 0.55 : 1)
    }
}

struct CarBrandPickerSheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var query = ""

    let service: CarCatalogService
    let selectedBrand: String
    let onSelect: (CarBrand?) -> Void

    var body: some View {
        NavigationStack {
            List {
                Button {
                    onSelect(nil)
                    dismiss()
                } label: {
                    Label(CarCatalogService.otherBrandTitle, systemImage: "pencil")
                        .foregroundColor(AppColors.accentPrimary)
                }

                Section("Markalar") {
                    ForEach(service.searchBrands(query)) { brand in
                        Button {
                            onSelect(brand)
                            dismiss()
                        } label: {
                            HStack {
                                Text(brand.displayName)
                                    .foregroundColor(AppColors.textPrimary)
                                Spacer()
                                if selectedBrand == brand.displayName {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(AppColors.accentPrimary)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Marka Seç")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $query, prompt: "Marka ara")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Kapat") { dismiss() }
                }
            }
        }
    }
}

struct CarModelPickerSheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var query = ""

    let service: CarCatalogService
    let brand: CarBrand
    let selectedModel: String
    let onSelect: (CarModel?) -> Void

    var body: some View {
        NavigationStack {
            List {
                Button {
                    onSelect(nil)
                    dismiss()
                } label: {
                    Label(CarCatalogService.otherModelTitle, systemImage: "pencil")
                        .foregroundColor(AppColors.accentPrimary)
                }

                Section(brand.displayName) {
                    ForEach(service.searchModels(in: brand, query: query)) { model in
                        Button {
                            onSelect(model)
                            dismiss()
                        } label: {
                            HStack {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(model.displayName)
                                        .foregroundColor(AppColors.textPrimary)
                                    if model.isCommonInTurkey {
                                        Text("Türkiye'de yaygın")
                                            .font(AppTypography.caption)
                                            .foregroundColor(AppColors.textTertiary)
                                    }
                                }
                                Spacer()
                                if selectedModel == model.displayName {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(AppColors.accentPrimary)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Model Seç")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $query, prompt: "Model ara")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Kapat") { dismiss() }
                }
            }
        }
    }
}
