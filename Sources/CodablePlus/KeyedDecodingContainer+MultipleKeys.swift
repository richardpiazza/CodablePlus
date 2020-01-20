import Foundation

public extension KeyedDecodingContainer {
    /// Returns a Boolean value indicating whether the decoder contains a value
    /// associated with the any of the given keys.
    ///
    /// The values associated with the given keys may be a null value as
    /// appropriate for the data format.
    ///
    /// The keys are queried in the order given, with the first matching
    /// key/value being returned.
    ///
    /// - parameter keys: The keys to search for.
    /// - returns: Whether the `Decoder` has an entry for any of the keys.
    func contains(_ keys: [KeyedDecodingContainer<K>.Key]) -> Bool {
        for key in keys {
            if contains(key) {
                return true
            }
        }

        return false
    }

    /// Decodes a value of the given type for any of the given keys.
    ///
    /// This method will attempt to decode data in the order the keys are given.
    /// The first matching key to have valid data will be returned.
    ///
    /// - parameter type: Tye type of value to decode
    /// - parameter keys: the keys that the given value may be associate with.
    /// - returns: A value of the request type, if present for the first valid key.
    /// - throws: `DecodingError.dataCorrupted` if no keys are specified.
    /// - throws: `DecodingError.typeMismatch` if an encountered encoded value for
    ///   one of the keys is not convertible to the requested type.
    /// - throws: `DecodingError.valueNotFound` if `self` has a null entry for all
    ///   of the given keys.
    func decode<T>(_ type: T.Type, forKeys keys: [KeyedDecodingContainer<K>.Key]) throws -> T where T: Decodable {
        guard keys.count > 0 else {
            let context = DecodingError.Context(codingPath: [], debugDescription: "No Keys Specified")
            throw DecodingError.dataCorrupted(context)
        }

        for key in keys {
            if let value = try decodeIfPresent(type, forKey: key) {
                return value
            }
        }

        let context = DecodingError.Context(codingPath: keys, debugDescription: "Value Not Found")
        throw DecodingError.valueNotFound(type, context)
    }

    /// Decodes a value of the given type for any of the given keys, if present.
    ///
    /// This method will attempt to decode data in the order the keys are given.
    /// The first matching key to have valid data will be returned. If no values
    /// are found, than `nil` will be returned.
    ///
    /// - parameter type: Tye type of value to decode
    /// - parameter keys: the keys that the given value may be associate with.
    /// - returns: A value of the request type, if present for the first valid key.
    /// - throws: `DecodingError.dataCorrupted` if no keys are specified.
    /// - throws: `DecodingError.typeMismatch` if an encountered encoded value for
    ///   one of the keys is not convertible to the requested type.
    func decodeIfPresent<T: Decodable>(_ type: T.Type, forKeys keys: [KeyedDecodingContainer<K>.Key]) throws -> T? {
        guard keys.count > 0 else {
            let context = DecodingError.Context(codingPath: [], debugDescription: "No Keys Specified")
            throw DecodingError.dataCorrupted(context)
        }

        for key in keys {
            if let value = try self.decodeIfPresent(type, forKey: key) {
                return value
            }
        }

        return nil
    }
}
