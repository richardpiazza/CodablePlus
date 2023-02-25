import XCTest
@testable import CodablePlus

class DefaultValueDecodingTests: XCTestCase {
    
    struct GameSystem: Decodable {
        let name: String
        let manufacturer: String
        let price: Double
        
        enum CodingKeys: CodingKey {
            case name
            case manufacturer
            case price
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            name = try container.decode(String.self, forKey: .name)
            manufacturer = try container.decode(String.self, forKey: .manufacturer)
            price = container.decode(.price, defaultValue: 299.99)
        }
    }
    
    let json1 = """
    {
        "name": "Switch",
        "manufacturer": "Nintendo",
        "price": 199.99
    }
    """
    
    let json2 = """
    {
        "name": "Switch",
        "manufacturer": "Nintendo"
    }
    """
    
    let decoder: JSONDecoder = .init()
    
    func testDefaultValueDecoding() throws {
        var data = try XCTUnwrap(json1.data(using: .utf8))
        var gameSystem = try decoder.decode(GameSystem.self, from: data)
        XCTAssertEqual(gameSystem.price, 199.99, accuracy: 0.1)
        data = try XCTUnwrap(json2.data(using: .utf8))
        gameSystem = try decoder.decode(GameSystem.self, from: data)
        XCTAssertEqual(gameSystem.price, 299.99, accuracy: 0.1)
    }
}
