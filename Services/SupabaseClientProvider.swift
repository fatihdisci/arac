import Foundation
import Supabase

// MARK: - Supabase Client Provider
// SupabaseClient'i lazy olarak başlatan singleton.
// Config eksikse client nil kalır — topluluk özelliği crash olmaz.

@MainActor
final class SupabaseClientProvider {
    static let shared = SupabaseClientProvider()

    /// Config eksikse nil. Tüm topluluk servisleri bu guard'ı kullanmalı:
    /// `guard let client = SupabaseClientProvider.shared.client else { return }`
    private(set) var client: SupabaseClient?

    private init() {
        guard SupabaseConfig.isConfigured,
              let url = SupabaseConfig.supabaseURL,
              let key = SupabaseConfig.supabaseAnonKey else {
            client = nil
            return
        }

        // ISO8601 with fractional seconds — Supabase/Postgres varsayılan timestamp formatı
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let raw = try container.decode(String.self)
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            if let date = formatter.date(from: raw) { return date }
            formatter.formatOptions = [.withInternetDateTime]
            if let date = formatter.date(from: raw) { return date }
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Beklenmeyen tarih formatı: \(raw)"
            )
        }

        let options = SupabaseClientOptions(
            db: SupabaseClientOptions.DatabaseOptions(decoder: decoder)
        )

        client = SupabaseClient(
            supabaseURL: url,
            supabaseKey: key,
            options: options
        )
    }
}
