import XCTest
@testable import CodablePlus

class DictionaryEncodingDecodingTests: XCTestCase {
    
    fileprivate let decoder = JSONDecoder()
    fileprivate let encoder = JSONEncoder()

    func testDecodingDictionary() throws {
        let data = dictionaryJSON.data(using: .utf8)!
        let container = try decoder.decode(Container.self, from: data)

        let string = container.dictionary["aString"] as? String
        let int = container.dictionary["aInt"] as? Int
        let double = container.dictionary["aDouble"] as? Double
        let bool = container.dictionary["aBool"] as? Bool
        let array = container.dictionary["aArray"] as? [Any]
        let dictionary = container.dictionary["aDictionary"] as? [String: Any]

        XCTAssertEqual(string, "This is a string.")
        XCTAssertEqual(int, 47)
        XCTAssertEqual(double, 55.88)
        XCTAssertEqual(bool, true)
        XCTAssertEqual(array?.count, 4)
        XCTAssertEqual(dictionary?.keys.count, 2)
    }

    func testEncodingDictionary() throws {
        var subDictionary: [String: Any] = [:]
        subDictionary["name"] = "Bob"
        subDictionary["age"] = 69

        var primeDictionary: [String: Any] = [:]
        primeDictionary["aString"] = "This is a string."
        primeDictionary["aInt"] = 47
        primeDictionary["aDouble"] = 55.88
        primeDictionary["aBool"] = true
        primeDictionary["aArray"] = ["String", 123, 123.456, false]
        primeDictionary["aDictionary"] = subDictionary

        let container = Container(dictionary: primeDictionary)
        let data = try encoder.encode(container)

        let json = try JSONSerialization.jsonObject(with: data, options: .init())
        guard let object = json as? [String: Any] else {
            XCTFail("Encoding or JSONSerialization failed.")
            return
        }

        XCTAssert(object.keys.contains("dictionary"))

        guard let dictionary = object["dictionary"] as? [String: Any] else {
            XCTFail("Encoding or JSONSerialization failed.")
            return
        }

        XCTAssertEqual(dictionary["aString"] as? String, "This is a string.")
        XCTAssertEqual(dictionary["aInt"] as? Int, 47)
        XCTAssertEqual(dictionary["aDouble"] as? Double, 55.88)
        XCTAssertEqual(dictionary["aBool"] as? Bool, true)
        guard let aArray = dictionary["aArray"] as? [Any] else {
            XCTFail("Encoding or JSONSerialization failed.")
            return
        }

        for element in aArray {
            if let bool = element as? Bool {
                XCTAssertEqual(bool, false)
            } else if let integer = element as? Int {
                XCTAssertEqual(integer, 123)
            } else if let double = element as? Double {
                XCTAssertEqual(double, 123.456)
            } else if let string = element as? String {
                XCTAssertEqual(string, "String")
            } else {
                XCTFail("Unexpected value in dictionary: \(String(describing: element))")
                return
            }
        }

        guard let aDictionary = dictionary["aDictionary"] as? [String: Any] else {
            XCTFail("Encoding or JSONSerialization failed.")
            return
        }

        XCTAssertEqual(aDictionary["name"] as? String, "Bob")
        XCTAssertEqual(aDictionary["age"] as? Int, 69)
    }

    func testEncodeNull() throws {
        var containerDictionary: [String: Any] = [:]
        containerDictionary["nullValue"] = NSNull()

        let container = Container(dictionary: containerDictionary)
        let data = try encoder.encode(container)

        let json = try JSONSerialization.jsonObject(with: data, options: .init())
        guard let object = json as? [String: Any] else {
            XCTFail("Encoding or JSONSerialization failed.")
            return
        }

        XCTAssert(object.keys.contains("dictionary"))

        guard let dictionary = object["dictionary"] as? [String: Any] else {
            XCTFail("Encoding or JSONSerialization failed.")
            return
        }

        XCTAssertTrue(dictionary["nullValue"] is NSNull)
    }

    func testDecodeNull() throws {
        let data = dictionaryWithNullJSON.data(using: .utf8)!
        let container = try decoder.decode(Container.self, from: data)

        XCTAssertTrue(container.dictionary["nullValue"] is NSNull)
        XCTAssertEqual(container.dictionary["nonNullValue"] as? Int, 47)
    }

    func testEncodeInvalid() {
        var containerDictionary: [String: Any] = [:]
        containerDictionary["url"] = URL(string: "https://www.google.com")!

        let container = Container(dictionary: containerDictionary)
        XCTAssertThrowsError(try encoder.encode(container))
    }

    func testDecodeSubarrays() throws {
        let data = dictionaryWithSubArraysJSON.data(using: .utf8)!
        let container = try decoder.decode(Container.self, from: data)

        guard let array = container.dictionary["container"] as? [Any] else {
            XCTFail("Decoding Failure")
            return
        }

        for element in array {
            switch element {
            case let strings as [String]:
                XCTAssertEqual(strings, ["String1", "String2"])
            case let ints as [Int]:
                XCTAssertEqual(ints, [0, 1, 2, 3])
            case let doubles as [Double]:
                XCTAssertEqual(doubles, [99.9, 99.8, 99.7, 99.6])
            case let bools as [Bool]:
                XCTAssertEqual(bools, [true, false, true])
            default:
                XCTFail("Decoding Failure")
            }
        }
    }
}

private struct Container: Codable {
    var dictionary: [String: Any]

    private enum CodingKeys: String, CodingKey {
        case dictionary
    }

    init(dictionary: [String: Any]) {
        self.dictionary = dictionary
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        dictionary = try container.decode([String: Any].self, forKey: .dictionary)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(dictionary, forKey: .dictionary)
    }
}

private let dictionaryJSON = """
{
    "dictionary": {
        "aString": "This is a string.",
        "aInt": 47,
        "aDouble": 55.88,
        "aBool": true,
        "aArray": ["String", 123, 123.456, false],
        "aDictionary": {
            "name": "Bob",
            "age": 69
        }
    }
}
"""

private let dictionaryWithNullJSON = """
{
    "dictionary": {
        "nullValue": null,
        "nonNullValue": 47
    }
}
"""

private let dictionaryWithSubArraysJSON = """
{
    "dictionary": {
        "container": [
            ["String1", "String2"],
            [0, 1, 2, 3],
            [99.9, 99.8, 99.7, 99.6],
            [true, false, true]
        ]
    }
}
"""
