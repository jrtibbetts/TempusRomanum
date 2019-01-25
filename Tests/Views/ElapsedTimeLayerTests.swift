//  Copyright © 2019 Poikile Creations. All rights reserved.

@testable import Tempus_Romanum
import XCTest

class ElapsedTimeLayerTests: XCTestCase {

    let fillColor = UIColor(named: "Elapsed Time")!.cgColor
    let midnightToday = Calendar.current.startOfDay(for: Date())

    func testEmptyInitializerOk() {
        let layer = ElapsedTimeLayer()
        XCTAssertEqual(layer.previousEndAngle, ElapsedTimeLayer.midnightAngle)
        XCTAssertEqual(layer.fillColor, fillColor)
    }

    func NOtestNoonAngleOk() {
        let noonToday = midnightToday.addingTimeInterval(12 * 60 * 60)
        let layer = ElapsedTimeLayer()
        layer.update(date: noonToday)
        XCTAssertEqual(layer.previousEndAngle, noonToday.rotationAngle)
    }

    func testDateLessThanOneMinuteAfterMidnightDoesNothing() {
        let layer = ElapsedTimeLayer()
        XCTAssertEqual(layer.previousEndAngle, midnightToday.rotationAngle)
        let midnightPlus30 = midnightToday.addingTimeInterval(45.0)
        layer.update(date: midnightPlus30)
        XCTAssertEqual(layer.previousEndAngle, midnightToday.rotationAngle)
    }

    func NOtestDateTwoMinutesAfterMidnightUpdates() {
        let layer = ElapsedTimeLayer()
        XCTAssertEqual(layer.previousEndAngle, midnightToday.rotationAngle)
        let midnightPlus2Minutes = midnightToday.addingTimeInterval(120.0)
        layer.update(date: midnightPlus2Minutes)
        XCTAssertEqual(layer.previousEndAngle, midnightPlus2Minutes.rotationAngle)
    }

    func NOtestCrossingMidnightResetsPreviousEndAngle() {
        let layer = ElapsedTimeLayer()
        let midnightMinus1Minute = midnightToday.addingTimeInterval(-60.0)
        layer.update(date: midnightMinus1Minute)
        let midnightPlus2Minutes = midnightToday.addingTimeInterval(120.0)
        layer.update(date: midnightPlus2Minutes)
        XCTAssertEqual(layer.previousEndAngle, ElapsedTimeLayer.midnightAngle)
    }

}
