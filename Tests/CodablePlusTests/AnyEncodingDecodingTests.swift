import XCTest
@testable import CodablePlus

final class AnyEncodingDecodingTests: CodablePlusTestCase {
    
    private struct Demo: Codable {
        
        enum CodingKeys: String, CodingKey {
            case value
        }
        
        let value: Any
        
        init(value: Any) {
            self.value = value
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            value = try container.decodeAny(forKey: .value)
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encodeAny(value, forKey: .value)
        }
    }
    
    func testEncodingAny() throws {
        var demo = Demo(value: "Hello World")
        var data = try encoder.encode(demo)
        var json = try XCTUnwrap(String(data: data, encoding: .utf8))
        
        XCTAssertEqual(json, #"{"value":"Hello World"}"#)
        
        demo = Demo(value: 47)
        data = try encoder.encode(demo)
        json = try XCTUnwrap(String(data: data, encoding: .utf8))
        
        XCTAssertEqual(json, #"{"value":47}"#)
        
        demo = Demo(value: 3.14)
        data = try encoder.encode(demo)
        json = try XCTUnwrap(String(data: data, encoding: .utf8))
        
        var object = try XCTUnwrap(JSONSerialization.jsonObject(with: data) as? [String: Any])
        let value = try XCTUnwrap(object["value"] as? Double)
        
        XCTAssertEqual(value, 3.14, accuracy: 0.1)
        
        demo = Demo(value: false)
        data = try encoder.encode(demo)
        json = try XCTUnwrap(String(data: data, encoding: .utf8))
        
        XCTAssertEqual(json, #"{"value":false}"#)
        
        demo = Demo(value: ["1", "2", "3"])
        data = try encoder.encode(demo)
        json = try XCTUnwrap(String(data: data, encoding: .utf8))
        
        XCTAssertEqual(json, #"{"value":["1","2","3"]}"#)
        
        demo = Demo(value: ["1", 2, 3.1, true])
        data = try encoder.encode(demo)
        json = try XCTUnwrap(String(data: data, encoding: .utf8))
        
        object = try XCTUnwrap(JSONSerialization.jsonObject(with: data) as? [String: Any])
        let array = try XCTUnwrap(object["value"] as? [Any])
        XCTAssertTrue(array.count == 4)
        
        XCTAssertEqual(array[0] as? String, "1")
        XCTAssertEqual(array[1] as? Int, 2)
        XCTAssertEqual(array[2] as? Double ?? 0.0, 3.1, accuracy: 0.1)
        XCTAssertEqual(array[3] as? Bool, true)
    }
    
    func testDecodeAny() throws {
        var json = #"{"value":"string"}"#
        var data = try XCTUnwrap(json.data(using: .utf8))
        var demo = try decoder.decode(Demo.self, from: data)
        
        XCTAssertEqual(demo.value as? String, "string")
        
        json = #"{"value":88}"#
        data = try XCTUnwrap(json.data(using: .utf8))
        demo = try decoder.decode(Demo.self, from: data)
        
        XCTAssertEqual(demo.value as? Int, 88)
        
        json = #"{"value":43.21}"#
        data = try XCTUnwrap(json.data(using: .utf8))
        demo = try decoder.decode(Demo.self, from: data)
        
        XCTAssertEqual(demo.value as? Double ?? 0.0, 43.21, accuracy: 0.1)
        
        json = #"{"value":true}"#
        data = try XCTUnwrap(json.data(using: .utf8))
        demo = try decoder.decode(Demo.self, from: data)
        
        XCTAssertEqual(demo.value as? Bool, true)
    }
}
