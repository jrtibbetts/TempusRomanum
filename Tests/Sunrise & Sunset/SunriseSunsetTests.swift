//  Copyright © 2019 Poikile Creations. All rights reserved.

@testable import Tempus_Romanum
import XCTest

class SunriseSunsetTests: XCTestCase {

    let midnightToday = Calendar.current.startOfDay(for: Date())

    func date(_ hours: Int, _ minutes: Int) -> Date {
        let interval = TimeInterval((hours * 60) + minutes) * 60
        return midnightToday.addingTimeInterval(interval)
    }

    func testDaylightHoursOk() {
        let sunriseSunset = SimpleSunriseSunset(sunrise: date(7, 13),
                                                sunset: date(18, 33))
        XCTAssertEqual(sunriseSunset.daylightHours.count, 12)
        XCTAssertEqual(sunriseSunset.sunrise, sunriseSunset.daylightHours[0])
    }

    func testNighttimeHoursOk() {
        let sunriseSunset = SimpleSunriseSunset(sunrise: date(7, 13),
                                                sunset: date(18, 33))
        XCTAssertEqual(sunriseSunset.nighttimeHours.count, 12)
    }

    // MARK: - Array<Date>.index()

    func testIndexOfTimeOk() {
        let baseDate = Date()
        let dates = [Date(timeInterval: -5000, since: baseDate),
                     Date(timeInterval: -2500, since: baseDate),
                     baseDate,
                     Date(timeInterval: 2500, since: baseDate)]
        let targetDate = Date(timeInterval: 1000, since: baseDate)
        XCTAssertEqual(dates.index(ofTime: targetDate, hourDurationInSeconds: 2500), 2)
    }

    func testIndexOfTimePastEndReturnsNil() {
        let baseDate = Date()
        let dates = [Date(timeInterval: -5000, since: baseDate),
                     Date(timeInterval: -4000, since: baseDate),
                     Date(timeInterval: -3000, since: baseDate),
                     Date(timeInterval: -2000, since: baseDate),
                     Date(timeInterval: -1000, since: baseDate)]
        XCTAssertNil(dates.index(ofTime: baseDate, hourDurationInSeconds: 1000))
    }

    func testIndexOfTimeBeforeBeginningReturnsNil() {
        let baseDate = Date()
        let dates = [Date(timeInterval: 1000, since: baseDate),
                     Date(timeInterval: 2000, since: baseDate),
                     Date(timeInterval: 3000, since: baseDate),
                     Date(timeInterval: 4000, since: baseDate),
                     Date(timeInterval: 5000, since: baseDate)]
        XCTAssertNil(dates.index(ofTime: baseDate, hourDurationInSeconds: 1000))
    }

    // MARK: - Array<Date>.nearestIndex()

    func testNearestIndexForLowerBoundOk() {
        let baseDate = Date()
        let dates = [Date(timeInterval: -100, since: baseDate),
                     Date(timeInterval: 1000, since: baseDate)]
        XCTAssertEqual(dates.nearestIndex(toTime: baseDate, hourDurationInSeconds: 1000), 0)
    }

    func testNearestIndexForLastElementOk() {
        let baseDate = Date()
        let dates = [Date(timeInterval: -100, since: baseDate),
                     Date(timeInterval: 1000, since: baseDate)]
        XCTAssertEqual(dates.nearestIndex(toTime: baseDate, hourDurationInSeconds: 1000), 0)
    }

    func testNearestIndexForUpperBoundOk() {
        let baseDate = Date()
        let dates = [Date(timeInterval: -1000, since: baseDate),
                     Date(timeInterval: 100, since: baseDate)]
        XCTAssertEqual(dates.nearestIndex(toTime: baseDate, hourDurationInSeconds: 1100), 1)
    }

    func testNearestIndexExactlyHalfwayReturnsUpperBound() {
        let baseDate = Date()
        let dates = [Date(timeInterval: -1000, since: baseDate),
                     Date(timeInterval: 1000, since: baseDate)]
        XCTAssertEqual(dates.nearestIndex(toTime: baseDate, hourDurationInSeconds: 2000), 1)
    }

    func testNearestIndexOfTimePastEndReturnsNil() {
        let baseDate = Date()
        let dates = [Date(timeInterval: -5000, since: baseDate),
                     Date(timeInterval: -4000, since: baseDate),
                     Date(timeInterval: -3000, since: baseDate),
                     Date(timeInterval: -2000, since: baseDate),
                     Date(timeInterval: -1000, since: baseDate)]
        XCTAssertNil(dates.nearestIndex(toTime: baseDate, hourDurationInSeconds: 1000))
    }

    func testNearestIndexOfTimeBeforeBeginningReturnsNil() {
        let baseDate = Date()
        let dates = [Date(timeInterval: 1000, since: baseDate),
                     Date(timeInterval: 2000, since: baseDate),
                     Date(timeInterval: 3000, since: baseDate),
                     Date(timeInterval: 4000, since: baseDate),
                     Date(timeInterval: 5000, since: baseDate)]
        XCTAssertNil(dates.nearestIndex(toTime: baseDate, hourDurationInSeconds: 1000))
    }

    func testTimeStringForTwentyMinutesAfterMidnight() {
        assert(timeString: "septima hora noctis", hour: 0, minute: 20)
    }

    func testTimeStringForOneTwenty() {
        assert(timeString: "octava hora noctis", hour: 1, minute: 20)
    }

    func testTimeStringForOneThirty() {
        assert(timeString: "octava hora noctis et dimidia", hour: 1, minute: 30)
    }

    func testTimeStringForFourteenHundredThirty() {
        assert(timeString: "nona hora diei et dimidia", hour: 14, minute: 30)
    }

    func testTimeStringForTwentyThreeHundredAndFive() {
        assert(timeString: "sexta hora noctis et dimidia", hour: 23, minute: 5)
    }

    func testTimeStringForTwoOClockPM() {
        assert(timeString: "nona hora diei", hour: 14, minute: 0)
    }

    func testTimeForThreeTwentyNineAM() {
        assert(timeString: "decima hora noctis", hour: 3, minute: 29)
    }

    func testTimeForFourFiftyNineAM() {
        assert(timeString: "undecima hora noctis et dimidia", hour: 4, minute: 59)
    }

    func assert(timeString expectedString: String,
                hour: TimeInterval,
                minute: TimeInterval,
                file: StaticString = #file,
                line: UInt = #line) {
        let midnight = Calendar.current.startOfDay(for: Date())
        let date = midnight.addingTimeInterval(hour * 60 * 60).addingTimeInterval(minute * 60)
        let sunriseSunset = SimpleSunriseSunset(sunrise: midnight.addingTimeInterval(6 * 60 * 60),
                                                sunset: midnight.addingTimeInterval(18 * 60 * 60))
        let string = sunriseSunset.romanHour(forDate: date)?.string
        XCTAssertEqual(string, expectedString, file: file, line: line)
    }

}
