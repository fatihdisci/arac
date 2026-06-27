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

        client = SupabaseClient(
            supabaseURL: url,
            supabaseKey: key
        )
    }
}
