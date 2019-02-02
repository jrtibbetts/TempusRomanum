//  Copyright © 2019 Poikile Creations. All rights reserved.

@testable import Tempus_Romanum
import XCTest

class RomanTimeTests: XCTestCase {

    // MARK: - Initializers

    func testInitializerWithRomanNumeralOnlyOk() {
        let time = RomanTime(.V)
        XCTAssertEqual(time.romanNumeral, .V)
        XCTAssertEqual(time.isDaylightHour, true)
        XCTAssertEqual(time.isHalfPast, false)
    }

    func testInitializerWithRomanNumeralAndDaylightHourFlagOk() {
        let time = RomanTime(.V, isDaylightHour: false)
        XCTAssertEqual(time.romanNumeral, .V)
        XCTAssertEqual(time.isDaylightHour, false)
        XCTAssertEqual(time.isHalfPast, false)
    }

    func testInitializerWithThreeArgumentsOk() {
        let time = RomanTime(.V, isDaylightHour: false, isHalfPast: true)
        XCTAssertEqual(time.romanNumeral, .V)
        XCTAssertEqual(time.isDaylightHour, false)
        XCTAssertEqual(time.isHalfPast, true)
    }

    // MARK: - string

    func testStringsForTimesOk() {
        XCTAssertEqual(RomanTime(.V).string, "quinta hora diei")
        XCTAssertEqual(RomanTime(.V, isDaylightHour: false).string, "quinta hora noctis")
        XCTAssertEqual(RomanTime(.V, isDaylightHour: false, isHalfPast: true).string, "quinta hora noctis et dimidia")
    }

}
