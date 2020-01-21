<p align="center">
    <img src="CodablePlus.png" width="1000" max-width="90%" alt="CodablePlus" />
</p>

<p align="center">
    <img src="https://img.shields.io/badge/Swift-5.1-orange.svg" />
    <a href="https://swift.org/package-manager">
        <img src="https://img.shields.io/badge/swiftpm-compatible-brightgreen.svg?style=flat" alt="Swift Package Manager" />
    </a>
     <img src="https://img.shields.io/badge/platforms-mac+linux-brightgreen.svg?style=flat" alt="Mac + Linux" />
    <a href="https://twitter.com/richardpiazza">
        <img src="https://img.shields.io/badge/twitter-@richardpiazza-blue.svg?style=flat" alt="Twitter: @richardpiazza" />
    </a>
</p>

<p align="center">A collection of extensions around the Swift `Codable` implementation.</p>

## Installation

Codable+ is distributed using the [Swift Package Manager](https://swift.org/package-manager). To install it into a project, add it as a dependency within your `Package.swift` manifest:

```swift
let package = Package(    ...    dependencies: [        .package(url: "https://github.com/richardpiazza/CodablePlus.git", from: "0.3.0")    ],    ...)
```

Then import **Codable+** wherever you'd like to use it:

```swift
import CodablePlus
```

## Usage

### Decoding/Encoding `Dictionary<String, Any>` & `Array<Any>`

The type `Any` in Swift does not conform to `Codable` because it can represent *any* type (whether codable or not). But, we run into situations where JSON objects are represented by a `Dictionary<String, Any>`, where *Any* here is limited to a set of known, codable-supporting types.

Now it's possible to de/serialize JSON objects into/from their *swift* counterparts. A prime example where this might be used is with API's that may have an expectation of a 'reasonably' defined response, but could use*random*or unknown-at-runtime keys. When this is the case, type safety can't be met, but the data is still valuable.

Interacting with the following `Container` definition and JSON snippet are now possible:

```swift
struct Container: Codable {
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
```

```json
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
```

These same examples can apply to `Array<Any>` where *Any* represents one of the JSON compatible primptives:

- String

- Int

- Double

- Bool

As well as these containers, when composed of the same primitive types.

* Array

* Dictionary

### Decoding Multiple Keys

During active development of projects, often times an API spec will change, or could possibly be inconsistent from one endpoint to another. It would be handy if our Swift models could be consistent, but support decoding of multiple possible entity models. With **Codable+** this is possible.

Given the following:

```swift
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

let schema1json = """
{
    "name": "Apple",
    "employees": 42000
}
"""

let schema2json = """
{
    "companyName": "Microsoft",
    "employees": 600000,
    "ceoName": "Satya Nadella"
}
"""
```

Notice the `companyName =` in the `init(from:)` method? This specifies multiple `CodingKey`s as possibilities. Now our `CompanyV2` model supports decoding of our `CompanyV1` schema.

## Inspiration

**Codable+** has grown and been inspired by several posts around the interwebs:

* [https://gist.github.com/mbuchetics/c9bc6c22033014aa0c550d3b4324411a](https://gist.github.com/mbuchetics/c9bc6c22033014aa0c550d3b4324411a)

* [https://gist.github.com/loudmouth/332e8d89d8de2c1eaf81875cfcd22e24](https://gist.github.com/loudmouth/332e8d89d8de2c1eaf81875cfcd22e24)

* [https://stackoverflow.com/questions/47575309/how-to-encode-a-property-with-type-of-json-dictionary-in-swift-4-encodable-proto](https://stackoverflow.com/questions/47575309/how-to-encode-a-property-with-type-of-json-dictionary-in-swift-4-encodable-proto)
