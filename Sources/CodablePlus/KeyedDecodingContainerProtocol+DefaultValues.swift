import Foundation

public extension KeyedDecodingContainerProtocol {
    /// Decodes a value for the given key.
    ///
    /// The `defaultValue` will be returned in two conditions:
    /// * The `key` is not present in the container
    /// * The standard `decode(_:,forKey:)` fails.
    ///
    /// This function does not throw any errors. It is assumed that you would want the `defaultValue`
    /// returned if errors are encountered
    ///
    /// This produces a simplified api with type inference:
    /// ```swift
    /// // Standard 'optional' decoding with a default value.
    /// ceoName = try container.decodeIfPresent(String.self, forKey: .ceoName) ?? "Adrian"
    /// // Simplified default decoding.
    /// ceoName = container.decode(.ceoName, defaultValue: "Adrian")
    /// ```
    ///
    /// - parameter key: The key that the decoded value is associated with.
    /// - parameter defaultValue: Closure called to produce a value when needed.
    func decode<T>(_ key: Key, defaultValue: @autoclosure () -> T) -> T where T: Decodable {
        guard contains(key) else {
            return defaultValue()
        }

        do {
            return try decode(T.self, forKey: key)
        } catch {
            return defaultValue()
        }
    }

    /// Decodes a value for the provided keys.
    ///
    /// The `defaultValue` will be returned in two conditions:
    /// * The provided `keys` is empty.
    /// * None of the `keys` produced the expected result type
    ///
    /// This function does not throw any errors. It is assumed that you would want the `defaultValue`
    /// returned if errors are encountered. _No errors are logged._
    ///
    /// This produces a simplified api with type inference:
    /// ```swift
    /// // Standard 'optional' decoding with a default value.
    /// ceoName = try container.decodeIfPresent(String.self, forKeys: [.ceoName, .bigCheese, .headHoncho]) ?? "Adrian"
    /// // Simplified default decoding.
    /// ceoName = container.decode([.ceoName, .bigCheese, .headHoncho], defaultValue: "Adrian")
    /// ```
    ///
    /// - parameter keys: the keys that the given value may be associate with.
    /// - parameter defaultValue: Closure called to produce a value when needed.
    func decode<T>(_ keys: [Key], defaultValue: @autoclosure () -> T) -> T where T: Decodable {
        guard !keys.isEmpty else {
            return defaultValue()
        }

        for key in keys {
            guard contains(key) else {
                continue
            }

            do {
                let value = try decode(T.self, forKey: key)
                return value
            } catch {

            }
        }

        return defaultValue()
    }
}
