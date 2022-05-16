import XCTest
@testable import CodablePlus

class ArrayEncodingDecodingTests: XCTestCase {
    
    fileprivate let decoder = JSONDecoder()
    fileprivate let encoder = JSONEncoder()

    func testDecodingArray() throws {
        let data = arrayJSON.data(using: .utf8)!
        let catalog = try decoder.decode(Catalog.self, from: data)

        XCTAssertEqual(catalog.activities.count, 3)

        guard let swimming = catalog.activities.first(where: { $0["name"] as? String == "Swimming" }) else {
            XCTFail("Failed to locate expected key-value pair (name: Swimming)")
            return
        }

        XCTAssertEqual(swimming["location"] as? String, "Pool")
        XCTAssertEqual(swimming["lanes"] as? Int, 12)

        guard let reading = catalog.activities.first(where: { $0["name"] as? String == "Reading" }) else {
            XCTFail("Failed to locate expected key-value pair (name: Reading)")
            return
        }

        XCTAssertEqual(reading["location"] as? String, "Library")
        XCTAssertEqual(reading["books"] as? Int, 10000)

        guard let coding = catalog.activities.first(where: { $0["name"] as? String == "Coding" }) else {
            XCTFail("Failed to locate expected key-value pair (name: Coding)")
            return
        }

        XCTAssertEqual(coding["location"] as? String, "Everywhere")
        XCTAssertEqual(coding["linesOfCode"] as? Int, 8327563)
    }

    func testEncodingArray() throws {
        var swimming: [String: Any] = [:]
        swimming["name"] = "Swimming"
        swimming["location"] = "Pool"
        swimming["lanes"] = 12

        var reading: [String: Any] = [:]
        reading["name"] = "Reading"
        reading["location"] = "Library"
        reading["books"] = 10000

        var coding: [String: Any] = [:]
        coding["name"] = "Coding"
        coding["location"] = "Everywhere"
        coding["linesOfCode"] = 8327563

        let catalog = Catalog(activities: [swimming, reading, coding])
        let data = try encoder.encode(catalog)

        let json = try JSONSerialization.jsonObject(with: data, options: .init())
        guard let dictionary = json as? [String: Any] else {
            XCTFail("Encoding or JSONSerialization failed.")
            return
        }

        XCTAssert(dictionary.keys.contains("activities"))

        guard let activities = dictionary["activities"] as? [[String: Any]] else {
            XCTFail("Encoding or JSONSerialization failed.")
            return
        }

        for activity in activities {
            guard let name = activity["name"] as? String else {
                XCTFail("Encoding or JSONSerialization failed.")
                return
            }

            guard let location = activity["location"] as? String else {
                XCTFail("Encoding or JSONSerialization failed.")
                return
            }

            switch name {
            case "Swimming":
                XCTAssertEqual(location, "Pool")
                let lanes = activity["lanes"] as? Int
                XCTAssertEqual(lanes, 12)
            case "Reading":
                XCTAssertEqual(location, "Library")
                let books = activity["books"] as? Int
                XCTAssertEqual(books, 10000)
            case "Coding":
                XCTAssertEqual(location, "Everywhere")
                let linesOfCode = activity["linesOfCode"] as? Int
                XCTAssertEqual(linesOfCode, 8327563)
            default:
                XCTFail("Encoding or JSONSerialization failed.")
            }
        }
    }

    func testEncodeNull() throws {
        var activity: [String: Any] = [:]
        activity["name"] = NSNull()

        let catalog = Catalog(activities: [activity])
        let data = try encoder.encode(catalog)

        let json = try JSONSerialization.jsonObject(with: data, options: .init())
        guard let dictionary = json as? [String: Any] else {
            XCTFail("Encoding or JSONSerialization failed.")
            return
        }

        XCTAssert(dictionary.keys.contains("activities"))

        guard let activities = dictionary["activities"] as? [[String: Any]] else {
            XCTFail("Encoding or JSONSerialization failed.")
            return
        }

        guard let first = activities.first else {
            XCTFail("Encoding or JSONSerialization failed.")
            return
        }

        XCTAssertTrue(first["name"] is NSNull)
    }

    func testDecodeNull() throws {
        let data = arrayWithNullJSON.data(using: .utf8)!
        let catalog = try decoder.decode(Catalog.self, from: data)

        guard let activity = catalog.activities.first else {
            XCTFail("Decoding Failure")
            return
        }

        XCTAssertEqual(activity["name"] as? String, "Swimming")
        XCTAssertTrue(activity["location"] is NSNull)
    }

    func testEncodeInvalid() {
        var activity: [String: Any] = [:]
        activity["url"] = URL(string: "https://www.google.com")!

        let catalog = Catalog(activities: [activity])
        XCTAssertThrowsError(try encoder.encode(catalog))
    }

    func testEncodeSubArrays() throws {
        var activity: [String: Any] = [:]
        activity["strings"] = ["String1", "String2"]
        activity["bools"] = [true, false, true]
        activity["ints"] = [0, 1, 2, 3]
        activity["doubles"] = [99.9, 99.8, 99.7, 99.6]

        let catalog = Catalog(activities: [activity])
        let data = try encoder.encode(catalog)

        let json = try JSONSerialization.jsonObject(with: data, options: .init())
        guard let dictionary = json as? [String: Any] else {
            XCTFail("Encoding or JSONSerialization failed.")
            return
        }

        guard let container = dictionary["activities"] as? [[String: Any]] else {
            XCTFail("Encoding or JSONSerialization failed.")
            return
        }

        for element in container {
            for (_, value) in element {
                switch value {
                case let bools as [Bool]:
                    XCTAssertEqual(bools, [true, false, true])
                case let ints as [Int]:
                    XCTAssertEqual(ints, [0, 1, 2, 3])
                case let doubles as [Double]:
                    XCTAssertEqual(doubles, [99.9, 99.8, 99.7, 99.6])
                case let strings as [String]:
                    XCTAssertEqual(strings, ["String1", "String2"])
                default:
                    XCTFail("Encoding Failure")
                }
            }
        }
    }

    func testDecodeOptional() throws {
        let data = arrayWithInstructors.data(using: .utf8)!
        let catalog = try decoder.decode(Catalog.self, from: data)
        XCTAssertFalse(catalog.activities.isEmpty)
        XCTAssertNotNil(catalog.instructors)
        XCTAssertEqual(catalog.instructors?.count, 1)
        XCTAssertNotNil(catalog.coordinates)
        XCTAssertEqual(catalog.coordinates?.count, 1)

        guard let coordinates = catalog.coordinates?["Pool"] as? [String: Any] else {
            XCTFail("Missing required dictionary under key 'Pool'.")
            return
        }

        XCTAssertEqual(coordinates["latitude"] as? Double, 21.07956)
        XCTAssertEqual(coordinates["longitude"] as? Double, -143.32072)
    }

    func testEncodeOptional() throws {
        let activities: [[String: Any]] = [["Boxing": "Fun"], ["Brazilian Jiu Jitsu": "Awesome"], ["Swimming": "OK"]]
        let instructors: [[String: Any]] = [["Boxing": "Bob"], ["Brazilian Jiu Jitsu": "Mary"], ["Swimming": "Jim"]]

        var catalog = Catalog(activities: activities)
        catalog.instructors = instructors

        let data = try encoder.encode(catalog)

        let jsonObject = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
        let writingOptions = JSONSerialization.WritingOptions()
        let jsonData = try JSONSerialization.data(withJSONObject: jsonObject, options: writingOptions)
        guard let json = String(data: jsonData, encoding: .utf8) else {
            XCTFail("Failed to parse UTF-8 string from JSON data.")
            return
        }

        // swiftlint:disable line_length
        let activitiesInstructors = "{\"activities\":[{\"Boxing\":\"Fun\"},{\"Brazilian Jiu Jitsu\":\"Awesome\"},{\"Swimming\":\"OK\"}],\"instructors\":[{\"Boxing\":\"Bob\"},{\"Brazilian Jiu Jitsu\":\"Mary\"},{\"Swimming\":\"Jim\"}]}"
        let instructorsActivities = "{\"instructors\":[{\"Boxing\":\"Bob\"},{\"Brazilian Jiu Jitsu\":\"Mary\"},{\"Swimming\":\"Jim\"}],\"activities\":[{\"Boxing\":\"Fun\"},{\"Brazilian Jiu Jitsu\":\"Awesome\"},{\"Swimming\":\"OK\"}]}"
        XCTAssertTrue(json == activitiesInstructors || json == instructorsActivities)
        // swiftlint:enable line_length
    }
}

private struct Catalog: Codable {
    var activities: [[String: Any]]
    var instructors: [[String: Any]]?
    var coordinates: [String: Any]?

    private enum CodingKeys: String, CodingKey {
        case activities
        case instructors
        case coordinates
    }

    init(activities: [[String: Any]]) {
        self.activities = activities
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let activitiesArray = try container.decode([Any].self, forKey: .activities)
        activities = activitiesArray as? [[String: Any]] ?? [[:]]
        if let instructorsArray = try container.decodeIfPresent([Any].self, forKey: .instructors) {
            instructors = instructorsArray as? [[String: Any]]
        }
        coordinates = try container.decodeIfPresent([String: Any].self, forKey: .coordinates)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(activities, forKey: .activities)
        try container.encodeIfPresent(instructors, forKey: .instructors)
        try container.encodeIfPresent(coordinates, forKey: .coordinates)
    }
}

private let arrayJSON = """
{
    "activities" : [
        {
            "name": "Swimming",
            "location": "Pool",
            "lanes": 12
        },
        {
            "name": "Reading",
            "location": "Library",
            "books": 10000
        },
        {
            "name": "Coding",
            "location": "Everywhere",
            "linesOfCode": 8327563
        }
    ]
}
"""

private let arrayWithNullJSON = """
{
    "activities" : [
        {
            "name": "Swimming",
            "location": null
        }
    ]
}
"""

private let arrayWithInstructors = """
{
    "activities" : [
        {
            "name": "Swimming",
            "location": "Pool"
        }
    ],
    "instructors" : [
        {
            "name": "Bob",
            "activity": "Swimming"
        }
    ],
    "coordinates" : {
        "Pool": {
            "latitude": 21.07956,
            "longitude": -143.32072
        }
    }
}
"""
