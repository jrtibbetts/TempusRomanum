//  Copyright © 2019 Poikile Creations. All rights reserved.

import Tempus_Romanum
import XCTest

class ElapsedTimeLayerTests: XCTestCase {

    func testInitHasNilPath() {
        let layer = ElapsedTimeLayer()
        XCTAssertNil(layer.path)
    }

    func testUpdateWithNoonContainsPoints() {
        let layer = ElapsedTimeLayer()
        layer.frame = CGRect(x: 0.0, y: 0.0, width: 400.0, height: 400.0)
        let midnight = Calendar.current.startOfDay(for: Date())
        let noon = midnight.addingTimeInterval(12 * 60 * 1000)
        layer.update(date: noon)
        XCTAssertNotNil(layer.path)
    }

}
