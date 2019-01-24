//  Copyright © 2019 Poikile Creations. All rights reserved.

@testable import Tempus_Romanum
import XCTest

class SunriseSunsetTests: XCTestCase {

    let midnightToday = Calendar.current.startOfDay(for: Date())

    func date(_ hours: Int, _ minutes: Int) -> Date {
        let interval = TimeInterval((hours * 60) + minutes) * 60
        return midnightToday.addingTimeInterval(interval)
    }

    func testDaylightMinutesOk() {
        let sunriseSunset = SunriseSunset(sunrise: date(7, 13),
                                          sunset: date(18, 33))
        XCTAssertEqual(sunriseSunset.daylightMinutes, 680)
    }

    func testDaylightHourDurationOk() {
        let sunriseSunset = SunriseSunset(sunrise: date(7, 13),
                                          sunset: date(18, 33))
        XCTAssertEqual(sunriseSunset.daylightHourDuration, 680 / 12)
    }

    func testNighttimeMinutesOk() {
        let sunriseSunset = SunriseSunset(sunrise: date(7, 13),
                                          sunset: date(18, 33))
        XCTAssertEqual(sunriseSunset.nighttimeMinutes, 760)
    }

    func testNighttimeHourDurationOk() {
        let sunriseSunset = SunriseSunset(sunrise: date(7, 13),
                                          sunset: date(18, 33))
        XCTAssertEqual(sunriseSunset.nighttimeHourDuration, (760) / 12)
    }

}
