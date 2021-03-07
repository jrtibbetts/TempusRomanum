//  Copyright © 2019 Poikile Creations. All rights reserved.

@testable import Stylobate
@testable import Tempus_Romanum
import XCTest

class Date_TrigonometryTests: XCTestCase {

    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }()

    func testTwoOClockMinutesAngleIs270Degrees() {
        let time = dateFormatter.date(from: "2:00 AM")!
        XCTAssertEqual(time.minutesAngle.degrees, 270.0, accuracy: 0.001)
    }

    func testTwoFifteenAngleIs0Degrees() {
        let time = dateFormatter.date(from: "2:15 AM")!
        XCTAssertEqual(time.minutesAngle.degrees, 0.0, accuracy: 0.001)
    }

    func testTwoThirtyAngleIs90Degrees() {
        let time = dateFormatter.date(from: "2:30 AM")!
        XCTAssertEqual(time.minutesAngle.degrees, 90.0, accuracy: 0.001)
    }

    func testTwoFortyFiveAngleIs180Degrees() {
        let time = dateFormatter.date(from: "2:45 AM")!
        XCTAssertEqual(time.minutesAngle.degrees, 180.0, accuracy: 0.001)
    }

    func testMidnightRotationAngleOk() {
        let midnight = dateFormatter.date(from: "12:00 AM")!
        XCTAssertEqual(midnight.rotationAngle, (CGFloat.pi / 2.0), accuracy: 0.001) // Stylobate
        XCTAssertEqual(midnight.hour24RotationAngle.degrees, 270.0, accuracy: 0.001) // TR
    }

    func test6amRotationAngleOk() {
        let sixAm = dateFormatter.date(from: "6:00 AM")!
        XCTAssertEqual(sixAm.rotationAngle, CGFloat.pi, accuracy: 0.001) // Stylobate
        XCTAssertEqual(sixAm.hour24RotationAngle.degrees, 0.0, accuracy: 0.001) // TR
    }

    func testNoonRotationAngleOk() {
        let noon = dateFormatter.date(from: "12:00 PM")!
        XCTAssertEqual(noon.rotationAngle, (1.5 * CGFloat.pi), accuracy: 0.001) // Stylobate
        XCTAssertEqual(noon.hour24RotationAngle.degrees, 90.0, accuracy: 0.001) // TR
    }

    func test6pmRotationAngleOk() {
        let sixPm = dateFormatter.date(from: "6:00 PM")!
        XCTAssertEqual(sixPm.rotationAngle, 2.0 * CGFloat.pi, accuracy: 0.001) // Stylobate
        XCTAssertEqual(sixPm.hour24RotationAngle.degrees, 180.0, accuracy: 0.001) // TR
    }

}
