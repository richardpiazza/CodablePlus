import Foundation

public extension KeyedEncodingContainerProtocol {
    /// Encodes the given value for the given key.
    ///
    /// - parameter value: The value to encode.
    /// - throws: `EncodingError.invalidValue` if the given value is invalid in the current context for this format.
    mutating func encodeAny(_ value: Any, forKey key: Key) throws {
        switch value {
        case let primitive as Bool:
            try encode(primitive, forKey: key)
        case let primitive as Int:
            try encode(primitive, forKey: key)
        case let primitive as Double:
            try encode(primitive, forKey: key)
        case let primitive as String:
            try encode(primitive, forKey: key)
        case let primitive as Dictionary<String, Any>:
            try encode(primitive, forKey: key)
        case let primitive as Array<Bool>:
            try encode(primitive, forKey: key)
        case let primitive as Array<Int>:
            try encode(primitive, forKey: key)
        case let primitive as Array<Double>:
            try encode(primitive, forKey: key)
        case let primitive as Array<String>:
            try encode(primitive, forKey: key)
        case let primitive as Array<Any>:
            try encode(primitive, forKey: key)
        case is NSNull:
            try encodeNil(forKey: key)
        default:
            let context = EncodingError.Context(codingPath: [key], debugDescription: "Invalid Encoding Value")
            throw EncodingError.invalidValue(value, context)
        }
    }
    
    /// Encodes the given value if present for the key.
    ///
    /// - parameter value: The value to encode.
    /// - throws: `EncodingError.invalidValue` if the given value is invalid in the current context for this format.
    mutating func encodeAnyIfPresent(_ value: Any?, forKey key: Key) throws {
        guard let value = value else {
            return
        }
        
        try encodeAny(value, forKey: key)
    }
}
