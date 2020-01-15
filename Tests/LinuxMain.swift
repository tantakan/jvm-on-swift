import XCTest

import jvm_on_swiftTests

var tests = [XCTestCaseEntry]()
tests += jvm_on_swiftTests.allTests()
XCTMain(tests)
