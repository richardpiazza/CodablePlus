import XCTest
@testable import CodablePlus

class CodablePlusTestCase: XCTestCase {
    
    let encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.sortedKeys]
        return encoder
    }()
    
    let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        return decoder
    }()
}
