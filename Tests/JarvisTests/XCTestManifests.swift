import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(RequestTests.allTests),
        testCase(ResponseTests.allTests),
        testCase(HttpHeadersTests.allTests),
        testCase(HttpUrlTests.allTests),
        testCase(MediaTypeTests.allTests),
        testCase(BodyContentTests.allTests),
        testCase(HttpClientTests.allTests()),
        testCase(NetworkTaskRepositoryTests.allTests()),
        testCase(UrlSessionHandlerTests.allTests())
    ]
}
#endif
