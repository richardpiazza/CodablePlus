import XCTest
@testable import CodablePlus

class MultipleKeysDecodingTests: XCTestCase {

    static var allTests = [
        ("testSchema1", testSchema1),
        ("testSchema2", testSchema2),
        ("testSchema2WithSchema1Data", testSchema2WithSchema1Data),
    ]
    
    fileprivate let decoder = JSONDecoder()

    func testSchema1() throws {
        let data = schema1json.data(using: .utf8)!
        let company = try decoder.decode(CompanyV1.self, from: data)

        XCTAssertEqual(company.name, "Apple")
        XCTAssertEqual(company.employees, 42000)
    }

    func testSchema2() throws {
        let data = schema2json.data(using: .utf8)!
        let company = try decoder.decode(CompanyV2.self, from: data)

        XCTAssertEqual(company.companyName, "Microsoft")
        XCTAssertEqual(company.employees, 600000)
        XCTAssertEqual(company.ceoName, "Satya Nadella")
    }

    func testSchema2WithSchema1Data() throws {
        let data = schema1json.data(using: .utf8)!
        let company = try decoder.decode(CompanyV2.self, from: data)

        XCTAssertEqual(company.companyName, "Apple")
        XCTAssertEqual(company.employees, 42000)
        XCTAssertEqual(company.ceoName, "")
    }
}

private struct CompanyV1: Decodable {
    var name: String
    var employees: Int
}

private struct CompanyV2: Decodable {
    var companyName: String
    var employees: Int
    var ceoName: String

    private enum CodingKeys: String, CodingKey {
        case name
        case companyName
        case employees
        case ceoName
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        companyName = try container.decode(String.self, forKeys: [.name, .companyName])
        employees = try container.decode(Int.self, forKey: .employees)
        ceoName = try container.decodeIfPresent(String.self, forKey: .ceoName) ?? ""
    }
}

private let schema1json = """
{
    "name": "Apple",
    "employees": 42000
}
"""

private let schema2json = """
{
    "companyName": "Microsoft",
    "employees": 600000,
    "ceoName": "Satya Nadella"
}
"""
