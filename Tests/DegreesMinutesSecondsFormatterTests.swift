//  Copyright © 2018 Poikile Creations. All rights reserved.

@testable import Tempus_Romanum
import CoreLocation
import XCTest

class DegreesMinutesSecondsFormatterTests: XCTestCase {

    func testDMSCoordinateAsStringOk() {
        let coord = DMSCoordinate(decimalDegrees: 40.446111)
        XCTAssertEqual(coord.asString, "40° 26' 46\"")
    }

    func testDMSCoordinateWithRoundedSecondsAsStringOk() {
        let coord = DMSCoordinate(decimalDegrees: -23.33)
        XCTAssertEqual(coord.asString, "23° 19' 48\"")
    }

}
