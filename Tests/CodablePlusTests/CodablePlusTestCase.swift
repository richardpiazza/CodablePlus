@testable import CodablePlus
import XCTest

class CodablePlusTestCase: XCTestCase {

    let encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.sortedKeys]
        return encoder
    }()

    let decoder: JSONDecoder = JSONDecoder()
}
