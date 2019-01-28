//  Copyright © 2019 Poikile Creations. All rights reserved.

@testable import Tempus_Romanum
import XCTest

class RomanNumeralTests: XCTestCase {

    func testTimeStringForOneTwenty() {
        assert(timeString: "prima hora", hour: 1, minute: 20)
    }

    func testTimeStringForOneThirty() {
        assert(timeString: "prima hora et dimidia", hour: 1, minute: 30)
    }

    func testTimeStringForFourteenHundredThirty() {
        assert(timeString: "secunda hora et dimidia", hour: 14, minute: 30)
    }

    func testTimeStringForTwoOClock() {
        assert(timeString: "secunda hora", hour: 2, minute: 0)
    }

    func testTimeForThreeTwentyNine() {
        assert(timeString: "tertia hora", hour: 3, minute: 29)
    }

    func testTimeForFourFiftyNine() {
        assert(timeString: "quarta hora et dimidia", hour: 4, minute: 59)
    }

    func assert(timeString expectedString: String, hour: Int, minute: Int) {
        let components = DateComponents(calendar: Calendar.current, hour: hour, minute: minute)
        XCTAssertTrue(components.isValidDate)
        let date = components.date!
        let string = RomanNumeral.timeString(from: date)
        XCTAssertEqual(string, expectedString)
    }

}
