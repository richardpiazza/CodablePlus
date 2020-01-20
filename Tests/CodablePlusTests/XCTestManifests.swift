import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(ArrayEncodingDecodingTests.allTests),
        testCase(DictionaryEncodingDecodingTests.allTests),
        testCase(KeyedDecodingContainerTests.allTests),
        testCase(MultipleKeysDecodingTests.allTests),
    ]
}
#endif
