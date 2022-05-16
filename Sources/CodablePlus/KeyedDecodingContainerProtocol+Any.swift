import Foundation

public extension KeyedDecodingContainerProtocol {
    /// Decodes a value of any decodable type.
    ///
    /// - parameter key: The key that the decoded value is associated with.
    func decodeAny(forKey key: Key) throws -> Any {
        if let boolValue = try? decode(Bool.self, forKey: key) {
            return boolValue
        } else if let intValue = try? decode(Int.self, forKey: key) {
            return intValue
        } else if let doubleValue = try? decode(Double.self, forKey: key) {
            return doubleValue
        } else if let stringValue = try? decode(String.self, forKey: key) {
            return stringValue
        } else if let nestedDictionary = try? decode(Dictionary<String, Any>.self, forKey: key) {
            return nestedDictionary
        } else if let nestedArray = try? decode(Array<Any>.self, forKey: key) {
            return nestedArray
        } else if try decodeNil(forKey: key) {
            return NSNull()
        } else {
            let context = DecodingError.Context(codingPath: [key], debugDescription: "Invalid Decoding Value")
            throw DecodingError.dataCorrupted(context)
        }
    }
    
    /// Decodes a value of any decodable type, if present.
    ///
    /// - parameter key: The key that the decoded value is associated with.
    func decodeAnyIfPresent(forKey key: Key) throws -> Any? {
        guard contains(key) else {
            return nil
        }
        
        return try decodeAny(forKey: key)
    }
}
