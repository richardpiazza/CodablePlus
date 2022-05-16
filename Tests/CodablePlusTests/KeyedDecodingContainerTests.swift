import XCTest
@testable import CodablePlus

class KeyedDecodingContainerTests: XCTestCase {
    
    let json1 = """
    {
        "name": "Apple",
        "employees": 42000
    }
    """
    
    let json2 = """
    {
        "companyName": "Microsoft",
        "employees": 600000,
        "ceoName": "Satya Nadella"
    }
    """
    
    struct CompanyV1: Decodable {
        var name: String
        var employees: Int
    }
    
    struct CompanyV2: Decodable {
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
    
    var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        return decoder
    }
    
    func testVersion1() {
        guard let data = json1.data(using: .utf8) else {
            XCTFail()
            return
        }
        
        let company: CompanyV1
        do {
            company = try decoder.decode(CompanyV1.self, from: data)
        } catch {
            XCTFail()
            return
        }
        
        XCTAssertEqual(company.name, "Apple")
        XCTAssertEqual(company.employees, 42000)
    }
    
    func testVersion2() {
        guard let data = json2.data(using: .utf8) else {
            XCTFail()
            return
        }
        
        let company: CompanyV2
        do {
            company = try decoder.decode(CompanyV2.self, from: data)
        } catch {
            XCTFail()
            return
        }
        
        XCTAssertEqual(company.companyName, "Microsoft")
        XCTAssertEqual(company.employees, 600000)
        XCTAssertEqual(company.ceoName, "Satya Nadella")
    }
    
    func testVersion2WithV1Data() {
        guard let data = json1.data(using: .utf8) else {
            XCTFail()
            return
        }
        
        let company: CompanyV2
        do {
            company = try decoder.decode(CompanyV2.self, from: data)
        } catch {
            XCTFail()
            return
        }
        
        XCTAssertEqual(company.companyName, "Apple")
        XCTAssertEqual(company.employees, 42000)
        XCTAssertEqual(company.ceoName, "")
    }
}
