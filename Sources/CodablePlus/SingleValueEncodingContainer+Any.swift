import Foundation

public extension SingleValueEncodingContainer {
    mutating func encodeAny(_ value: Any) throws {
        switch value {
        case let primitive as Bool:
            try encode(primitive)
        case let primitive as Int:
            try encode(primitive)
        case let primitive as Double:
            try encode(primitive)
        case let primitive as String:
            try encode(primitive)
        case let primitive as Array<Bool>:
            try encode(primitive)
        case let primitive as Array<Int>:
            try encode(primitive)
        case let primitive as Array<Double>:
            try encode(primitive)
        case let primitive as Array<String>:
            try encode(primitive)
        case is NSNull:
            try encodeNil()
        default:
            let context = EncodingError.Context(codingPath: [], debugDescription: "Invalid Encoding Value")
            throw EncodingError.invalidValue(value, context)
        }
    }
}
