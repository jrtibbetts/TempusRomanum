//  Copyright © 2019 Poikile Creations. All rights reserved.

@testable import Tempus_Romanum
import XCTest

class ElapsedTimeLayerTests: XCTestCase {

    let fillColor = UIColor(named: "Elapsed Time")!.cgColor
    let midnightToday = Calendar.current.startOfDay(for: Date())

    func testEmptyInitializerOk() {
        let layer = ElapsedTimeLayer()
        XCTAssertEqual(layer.fillColor, fillColor)
    }

}
