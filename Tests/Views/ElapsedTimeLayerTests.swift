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

}
