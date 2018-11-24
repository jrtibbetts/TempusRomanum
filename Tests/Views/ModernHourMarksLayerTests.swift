//  Copyright © 2018 Poikile Creations. All rights reserved.

@testable import Tempus_Romanum
import XCTest

class ModernHourMarksLayerTests: XCTestCase {

    // MARK: - init(radius:margin:)

    func testInitWithRadiusAndMarginOk() {
        let radius = CGFloat(40.0)
        let margin = CGFloat(12.0)

        let layer = ModernHourMarksLayer(radius: radius, margin: margin)
        XCTAssertEqual(layer.radius, radius)
        XCTAssertEqual(layer.margin, margin)
    }

    func testInitWithRadiusHasDefaultMargin() {
        let radius = CGFloat(40.0)

        let layer = ModernHourMarksLayer(radius: radius)
        XCTAssertEqual(layer.radius, radius)
        XCTAssertEqual(layer.margin, 30.0)
    }

}
