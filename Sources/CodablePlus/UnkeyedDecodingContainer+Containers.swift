import Foundation

public extension UnkeyedDecodingContainer {
    /// Decodes a value of the given type.
    ///
    /// - parameter type: The type of value to decode.
    /// - returns: A value of the requested type, if present for the given key
    ///   and convertible to the requested type.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value
    ///   is not convertible to the requested type.
    mutating func decode(_ type: [String: Any].Type) throws -> [String: Any] {
        let container = try nestedContainer(keyedBy: DictionaryKeys.self)
        return try container.decode(type)
    }

    /// Decodes a value of the given type.
    ///
    /// - parameter type: The type of value to decode.
    /// - returns: A value of the requested type, if present for the given key
    ///   and convertible to the requested type.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value
    ///   is not convertible to the requested type.
    mutating func decode(_ type: [Any].Type) throws -> [Any] {
        var array: [Any] = []

        while isAtEnd == false {
            if let value = try? decode(Bool.self) {
                array.append(value)
            } else if let value = try? decode(Int.self) {
                array.append(value)
            } else if let value = try? decode(Double.self) {
                array.append(value)
            } else if let value = try? decode(String.self) {
                array.append(value)
            } else if let nestedDictionary = try? decode([String: Any].self) {
                array.append(nestedDictionary)
            } else if let nestedArray = try? decode([Bool].self) {
                array.append(nestedArray)
            } else if let nestedArray = try? decode([Int].self) {
                array.append(nestedArray)
            } else if let nestedArray = try? decode([Double].self) {
                array.append(nestedArray)
            } else if let nestedArray = try? decode([String].self) {
                array.append(nestedArray)
            } else if let nestedArray = try? decode([Any].self) {
                array.append(nestedArray)
            } else if let _ = try? decodeNil() {
                array.append(NSNull())
            } else {
                let context = DecodingError.Context(codingPath: [DictionaryKeys(intValue: currentIndex)], debugDescription: "Invalid Decoding Value")
                throw DecodingError.typeMismatch(type, context)
            }
        }

        return array
    }
}
