import Foundation

public extension KeyedEncodingContainerProtocol {
    /// Encodes the given value for the given key.
    ///
    /// - parameter value: The value to encode.
    /// - parameter key: The key to associate the value with.
    /// - throws: `EncodingError.invalidValue` if the given value is invalid in
    ///   the current context for this format.
    mutating func encode(_ value: [String: Any], forKey key: Key) throws {
        var container = nestedContainer(keyedBy: DictionaryKeys.self, forKey: key)
        try container.encode(value)
    }

    /// Encodes the given value for the given key.
    ///
    /// - parameter value: The value to encode.
    /// - parameter key: The key to associate the value with.
    /// - throws: `EncodingError.invalidValue` if the given value is invalid in
    ///   the current context for this format.
    mutating func encode(_ value: [Any], forKey key: Key) throws {
        var container = nestedUnkeyedContainer(forKey: key)
        try container.encode(value)
    }

    /// Encodes the given value for the given key if it is not `nil`.
    ///
    /// - parameter value: The value to encode.
    /// - parameter key: The key to associate the value with.
    /// - throws: `EncodingError.invalidValue` if the given value is invalid in
    ///   the current context for this format.
    mutating func encodeIfPresent(_ value: [String: Any]?, forKey key: Key) throws {
        guard let value else {
            return
        }

        try encode(value, forKey: key)
    }

    /// Encodes the given value for the given key if it is not `nil`.
    ///
    /// - parameter value: The value to encode.
    /// - parameter key: The key to associate the value with.
    /// - throws: `EncodingError.invalidValue` if the given value is invalid in
    ///   the current context for this format.
    mutating func encodeIfPresent(_ value: [Any]?, forKey key: Key) throws {
        guard let value else {
            return
        }

        try encode(value, forKey: key)
    }
}

public extension KeyedEncodingContainerProtocol where Key == DictionaryKeys {
    /// Encodes the given value for the given key.
    ///
    /// - parameter value: The value to encode.
    /// - throws: `EncodingError.invalidValue` if the given value is invalid in
    ///   the current context for this format.
    mutating func encode(_ value: [String: Any]) throws {
        for (index, element) in value {
            let key = DictionaryKeys(stringValue: index)

            switch element {
            case let primitive as Bool:
                try encode(primitive, forKey: key)
            case let primitive as Int:
                try encode(primitive, forKey: key)
            case let primitive as Double:
                try encode(primitive, forKey: key)
            case let primitive as String:
                try encode(primitive, forKey: key)
            case let primitive as [String: Any]:
                try encode(primitive, forKey: key)
            case let primitive as [Any]:
                try encode(primitive, forKey: key)
            case is NSNull:
                try encodeNil(forKey: key)
            default:
                let context = EncodingError.Context(codingPath: [key], debugDescription: "Invalid Encoding Value")
                throw EncodingError.invalidValue(element, context)
            }
        }
    }
}
