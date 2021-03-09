//  Copyright © 2019 Poikile Creations. All rights reserved.

@testable import Tempus_Romanum
import XCTest

class DaylightLayerTests: XCTestCase {

    var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short

        return dateFormatter
    }()

    func testSetSunriseSunsetUpdatesPath() {
        let layer = DaylightLayer()
        layer.frame = CGRect(x: 0, y: 0, width: 400, height: 400)
        let midnight = Calendar.current.startOfDay(for: Date())
        let sixAM = midnight.addingTimeInterval(6 * 60 * 60)
        let sixPM = midnight.addingTimeInterval(18 * 60 * 60)
        layer.sunriseSunset = SimpleSunriseSunset(sunrise: sixAM, sunset: sixPM)
        layer.layoutIfNeeded()  // since we're not running a UI test, force the layout
        XCTAssertTrue(layer.path!.contains(CGPoint(x: 50, y: 50)))
        XCTAssertFalse(layer.path!.contains(CGPoint(x: 350, y: 350)))

        layer.sunriseSunset = SimpleSunriseSunset(sunrise: sixPM, sunset: sixAM)
        layer.layoutIfNeeded()
        XCTAssertFalse(layer.path!.contains(CGPoint(x: 50, y: 50)))
        XCTAssertTrue(layer.path!.contains(CGPoint(x: 350, y: 350)))
    }

}
