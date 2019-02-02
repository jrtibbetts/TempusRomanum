//  Copyright © 2019 Poikile Creations. All rights reserved.

@testable import Tempus_Romanum
import XCTest

class SunriseSunsetTests: XCTestCase {

    let midnightToday = Calendar.current.startOfDay(for: Date())

    func date(_ hours: Int, _ minutes: Int) -> Date {
        let interval = TimeInterval((hours * 60) + minutes) * 60
        return midnightToday.addingTimeInterval(interval)
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

//    func testTimeStringForOneTwenty() {
//        assert(timeString: "septima hora noctis", hour: 1, minute: 20)
//    }
//
//    func testTimeStringForOneThirty() {
//        assert(timeString: "octava hora noctis et dimidia", hour: 1, minute: 30)
//    }
//
//    func testTimeStringForFourteenHundredThirty() {
//        assert(timeString: "nona hora diei et dimidia", hour: 14, minute: 30)
//    }
//
//    func testTimeStringForTwentyThreeHundredAndFive() {
//        assert(timeString: "sexta hora diei et dimidia", hour: 23, minute: 5)
//    }
//
//    func testTimeStringForTwoOClockPM() {
//        assert(timeString: "nona hora diei", hour: 14, minute: 0)
//    }
//
//    func testTimeForThreeTwentyNineAM() {
//        assert(timeString: "decima hora noctis", hour: 3, minute: 29)
//    }
//
//    func testTimeForFourFiftyNineAM() {
//        assert(timeString: "undecima hora noctis et dimidia", hour: 4, minute: 59)
//    }

    func assert(timeString expectedString: String,
                hour: TimeInterval,
                minute: TimeInterval,
                file: StaticString = #file,
                line: UInt = #line) {
        let midnight = Calendar.current.startOfDay(for: Date())
        let date = midnight.addingTimeInterval(hour * 60.0 * 60.0).addingTimeInterval(minute * 60)
        let sunriseSunset = SimpleSunriseSunset(sunrise: midnight.addingTimeInterval(6 * 60 * 60),
                                                sunset: midnight.addingTimeInterval(18 * 60 * 60))
        let string = sunriseSunset.romanHour(forDate: date)?.string
        XCTAssertEqual(string, expectedString, file: file, line: line)
    }

}
