import XCTest
import JarvisTests

var tests = [XCTestCaseEntry]()
tests += BodyContentTests.allTests()
tests += RequestTests.allTests()
tests += ResponseTests.allTests()
tests += HttpHeaderTest.allTests()
tests += HttpUrlTests.allTests()
tests += MediaTypeTests.allTests()
tests += HttpClientTests.allTests()
tests += NetworkTaskRepositoryTests.allTests()
tests += UrlSessionHandlerTests.allTests()
XCTMain(tests)
