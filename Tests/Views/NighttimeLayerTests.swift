//  Copyright © 2019 Poikile Creations. All rights reserved.

@testable import Tempus_Romanum
import XCTest

class NighttimeLayerTests: XCTestCase {

    func testSetSunriseSunsetUpdatesPath() {
        let layer = NighttimeLayer()
        layer.frame = CGRect(x: 0, y: 0, width: 400, height: 400)
        let midnight = Calendar.current.startOfDay(for: Date())
        let sunset = midnight.addingTimeInterval(12 * 60 * 1000)
        var sunriseSunset = SimpleSunriseSunset(sunrise: sunset, sunset: midnight)
        layer.sunriseSunset = sunriseSunset
        layer.layoutIfNeeded()  // since we're not running a UI test, force the layout
        XCTAssertTrue(layer.path!.contains(CGPoint(x: 100, y: 200)))
        XCTAssertFalse(layer.path!.contains(CGPoint(x: 300, y: 200)))

        sunriseSunset = SimpleSunriseSunset(sunrise: midnight, sunset: sunset)
        layer.sunriseSunset = sunriseSunset
        layer.layoutIfNeeded()
        XCTAssertFalse(layer.path!.contains(CGPoint(x: 100, y: 200)))
        XCTAssertTrue(layer.path!.contains(CGPoint(x: 300, y: 200)))
    }

}
