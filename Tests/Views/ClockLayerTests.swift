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

    func testBorderPointAt2πOk() {
        let layer = ClockLayer()
        layer.frame = CGRect(x: 0.0, y: 0.0, width: 120.0, height: 120.0)
        let borderPointAt2π = layer.borderPoint(at: (2.0 * CGFloat.pi))
        XCTAssertEqual(borderPointAt2π.x, 120.0, accuracy: 0.001)
        XCTAssertEqual(borderPointAt2π.y, 60.0, accuracy: 0.001)
    }

    func testBorderPointAtπOk() {
        let layer = ClockLayer()
        layer.frame = CGRect(x: 0.0, y: 0.0, width: 120.0, height: 120.0)
        let borderPointAtπ = layer.borderPoint(at: CGFloat.pi)
        XCTAssertEqual(borderPointAtπ.x, 0.0, accuracy: 0.001)
        XCTAssertEqual(borderPointAtπ.y, 60.0, accuracy: 0.001)
    }

}
