//  Copyright © 2019 Poikile Creations. All rights reserved.

@testable import Tempus_Romanum
import XCTest

class ClockLayerTests: XCTestCase {

    func testBoundsCenterOk() {
        let layer = ClockLayer()
        layer.frame = CGRect(x: 10.0, y: 99.0, width: 120.0, height: 555.0)
        XCTAssertEqual(layer.boundsCenter.x, 60.0)
        XCTAssertEqual(layer.boundsCenter.y, 277.5)
    }

    func testRadiusOk() {
        let layer = ClockLayer()
        layer.frame = CGRect(x: 10.0, y: 99.0, width: 120.0, height: 555.0)
        XCTAssertEqual(layer.radius, 60.0)
    }

    func testDiameterOk() {
        let layer = ClockLayer()
        layer.frame = CGRect(x: 10.0, y: 99.0, width: 120.0, height: 555.0)
        XCTAssertEqual(layer.diameter, 120.0)
    }

}
