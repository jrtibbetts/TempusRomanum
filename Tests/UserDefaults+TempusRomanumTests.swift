//  Copyright © 2019 Poikile Creations. All rights reserved.

import XCTest

class UserDefaults_TempusRomanumTests: XCTestCase {

    func testToggle24HourClock() {
        let defaults = UserDefaults()
        defaults.use24HourClock = true
        XCTAssertTrue(defaults.use24HourClock)
        defaults.use24HourClock = false
        XCTAssertFalse(defaults.use24HourClock)
    }

}
