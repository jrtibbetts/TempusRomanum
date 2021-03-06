//  Copyright © 2019 Poikile Creations. All rights reserved.

@testable import Tempus_Romanum
import XCTest

class Date_TrigonometryTests: XCTestCase {

    let midnight = Calendar.current.startOfDay(for: Date())

    func testNoonRotationAngleOk() {
        let noon = midnight.addingTimeInterval(12 * 60 * 60)
        XCTAssertEqual(noon.hour24RotationAngle.radians, (1.5 * Double.pi), accuracy: 0.001)
    }

    func testMidnightRotationAngleOk() {
        XCTAssertEqual(midnight.hour24RotationAngle.radians, (Double.pi / 2.0), accuracy: 0.001)
    }

    func test6amRotationAngleOk() {
        let sixAm = midnight.addingTimeInterval(6 * 60 * 60)
        XCTAssertEqual(sixAm.hour24RotationAngle.radians, Double.pi, accuracy: 0.001)
    }

    func test6pmRotationAngleOk() {
        let sixPm = midnight.addingTimeInterval(18 * 60 * 60)
        XCTAssertEqual(sixPm.hour24RotationAngle.radians, 2.0 * Double.pi, accuracy: 0.001)
    }

}
