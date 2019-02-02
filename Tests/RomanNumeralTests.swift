//  Copyright © 2019 Poikile Creations. All rights reserved.

@testable import Tempus_Romanum
import XCTest

class RomanNumeralTests: XCTestCase {

    func testAllCasesOk() {
        XCTAssertEqual(RomanNumeral.allCases[4], RomanNumeral.V)
        XCTAssertEqual(RomanNumeral.allCases[10], RomanNumeral.XI)
    }

    func testRomanNumeralForIntOk() {
        XCTAssertEqual(RomanNumeral.romanNumeral(for: 1), RomanNumeral.I)
        XCTAssertEqual(RomanNumeral.romanNumeral(for: 3), RomanNumeral.III)
        XCTAssertEqual(RomanNumeral.romanNumeral(for: 10), RomanNumeral.X)
        XCTAssertEqual(RomanNumeral.romanNumeral(for: 12), RomanNumeral.XII)
    }

    func testRomanNumeralForNegativeNumberIsNil() {
        XCTAssertNil(RomanNumeral.romanNumeral(for: -44))
    }

    func testRomanNumeralForZeroIsNil() {
        XCTAssertNil(RomanNumeral.romanNumeral(for: 0))
    }

    func testRomanNumeralFor13Nil() {
        XCTAssertNil(RomanNumeral.romanNumeral(for: 13))
    }

}
