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
        let sunriseSunset = SimpleSunriseSunset(sunrise: date(7, 13),
                                                sunset: date(18, 33))
        XCTAssertEqual(sunriseSunset.daylightMinutes, 680)
    }

    func testDaylightHourDurationOk() {
        let sunriseSunset = SimpleSunriseSunset(sunrise: date(7, 13),
                                                sunset: date(18, 33))
        XCTAssertEqual(sunriseSunset.daylightHourDuration, 680 / 12)
    }

    func testDaylightHoursOk() {
        let sunriseSunset = SimpleSunriseSunset(sunrise: date(7, 13),
                                                sunset: date(18, 33))
        XCTAssertEqual(sunriseSunset.daylightHours.count, 12)
        XCTAssertEqual(sunriseSunset.sunrise, sunriseSunset.daylightHours[0])
    }

    func testNighttimeMinutesOk() {
        let sunriseSunset = SimpleSunriseSunset(sunrise: date(7, 13),
                                                sunset: date(18, 33))
        XCTAssertEqual(sunriseSunset.nighttimeMinutes, 760)
    }

    func testNighttimeHourDurationOk() {
        let sunriseSunset = SimpleSunriseSunset(sunrise: date(7, 13),
                                                sunset: date(18, 33))
        XCTAssertEqual(sunriseSunset.nighttimeHourDuration, (760) / 12)
    }

    func testNighttimeHoursOk() {
        let sunriseSunset = SimpleSunriseSunset(sunrise: date(7, 13),
                                                sunset: date(18, 33))
        XCTAssertEqual(sunriseSunset.nighttimeHours.count, 12)
        XCTAssertEqual(sunriseSunset.sunset, sunriseSunset.nighttimeHours[0])
    }

}
