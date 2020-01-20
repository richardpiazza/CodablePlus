import Foundation

/// A struct used to support `Dictionary` _(`[String:Any]`)_ and `Array` _(`[Any]`)_
/// encoding and decoding.
///
/// Both _Keyed_ and _Unkeyed_ containers are supported. Keep in mind that 'Any', must be
/// a primitive type that is supported with JSON:
///
/// * `Bool`
/// * `Int`
/// * `Double`
/// * `String`
/// * `Dictionary<String, Any>`
/// * `Array<Any>`
///
/// ## Inspiration
/// * [https://gist.github.com/mbuchetics/c9bc6c22033014aa0c550d3b4324411a](https://gist.github.com/mbuchetics/c9bc6c22033014aa0c550d3b4324411a)
/// * [https://gist.github.com/loudmouth/332e8d89d8de2c1eaf81875cfcd22e24](https://gist.github.com/loudmouth/332e8d89d8de2c1eaf81875cfcd22e24)
/// * [https://stackoverflow.com/questions/47575309/how-to-encode-a-property-with-type-of-json-dictionary-in-swift-4-encodable-proto](https://stackoverflow.com/questions/47575309/how-to-encode-a-property-with-type-of-json-dictionary-in-swift-4-encodable-proto)
public struct DictionaryKeys: CodingKey {
    public var stringValue: String
    public var intValue: Int?
    
    public init(stringValue: String) {
        self.stringValue = stringValue
    }
    
    public init(intValue: Int) {
        self.stringValue = "\(intValue)"
        self.intValue = intValue
    }
}
