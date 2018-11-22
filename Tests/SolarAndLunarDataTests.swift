//  Copyright © 2018 Poikile Creations. All rights reserved.

@testable import Tempus_Romanum
import Stylobate
import XCTest

class SolarAndLunarDataTests: XCTestCase {

    func testSolarAndLunarDataParsesCorrectly() {
        XCTAssertFalse(solarData.error)
        XCTAssertEqual(solarData.year, 2016)
        XCTAssertEqual(solarData.timeZoneOffset, 1)
    }

    // MARK: - SolarAndLunarData.sunriseString & .sunsetString

    func testSunriseAndSunsetStringsOk() {
        XCTAssertEqual(sunriseSunset.sunriseString, "07:18")
        XCTAssertEqual(sunriseSunset.sunsetString, "16:40")
    }

    // MARK: - SolarAndLunarData.sunrise & .sunset

    func testSunriseAndSunsetDatesOk() {
        let timeFormatter = DateFormatter() <~ {
            $0.dateFormat = "HH:mm"
        }

        XCTAssertEqual(sunriseSunset.sunrise, timeFormatter.date(from: "07:18"))
        XCTAssertEqual(sunriseSunset.sunset, timeFormatter.date(from: "16:40"))
    }

    // MARK: - SolarAndLunarData.daylightHourInterval

    func testDaylightMinutesOk() {
        let minutes = sunriseSunset.daylightMinutes
        // 9:22 hours = 562 minutes
        XCTAssertLessThan(fabs(minutes - 562.0), 0.1)
    }

    // MARK: - SolarAndLunarData.daylightMinutes

    func testDaylightHourIntervalOk() {
        let interval = sunriseSunset.daylightHourInterval
        // Interval should be = (9:22 / 12) = 46.8 minutes
        XCTAssertLessThan(fabs(interval - 46.8333), 0.1)
    }

    // MARK: - SolarAndLunarData.daylightHours

    func testDaylightHoursOk() {
        let hours = sunriseSunset.daylightHourTimes
        XCTAssertEqual(hours.count, 12)

        hours.enumerated().forEach { (offset, hour) in
            let expectedHour = sunriseSunset.sunrise.addingTimeInterval(46.8333 * 60 * Double(offset))
            XCTAssertLessThan(fabs(hour.timeIntervalSince(expectedHour)), 0.1)
        }
    }

    func testDaylightHoursContainsSunrise() {
        let hours = sunriseSunset.daylightHourTimes

        XCTAssertTrue(hours.contains(sunriseSunset.sunrise))
        XCTAssertFalse(hours.contains(sunriseSunset.sunset))
    }

    // MARK: - SolarAndLunarData.nighttimeMinutes

    func testNighttimeMinutesOk() {
        let minutes = sunriseSunset.nighttimeMinutes
        // 13:38 hours = 878 minutes
        XCTAssertLessThan(fabs(minutes - 878.0), 0.1)
    }

    // MARK: - SolarAndLunarData.nighttimeHourInterval

    func testNighttimeHourIntervalOk() {
        let interval = sunriseSunset.nighttimeHourInterval
        // Interval should be = (13:38 / 12) = 73.2 minutes
        XCTAssertLessThan(fabs(interval - 73.1667), 0.1)
    }

    // MARK: - SolarAndLunarData.nighttimeHours

    func testNighttimeHoursOk() {
        let hours = sunriseSunset.nighttimeHourTimes

        hours.enumerated().forEach { (offset, hour) in
            let expectedHour = sunriseSunset.sunset.addingTimeInterval(73.1667 * 60 * Double(offset))
            XCTAssertLessThan(fabs(hour.timeIntervalSince(expectedHour)), 0.1)
        }
    }

    // MARK: - Test Data

    var solarData: SolarAndLunarData {
        return try! JSONDecoder().decode(SolarAndLunarData.self, from: sampleData)
    }
    var sunriseSunset: SunriseSunset {
        return SunriseSunset(sunrise: solarData.sunrise, sunset: solarData.sunset)
    }

    var sampleData: Data {
        return sampleJson.data(using: .utf8)!
    }

    let sampleJson = """
{
    "error":false,
    "apiversion":"2.1.0",
    "year":2016,
    "month":12,
    "day":1,
    "dayofweek":"Thursday",
    "datechanged":false,
    "lon":12.480000,
    "lat":41.890000,
    "tz":1,

    "closestphase":{
        "phase": "New Moon",
        "date": "November 29, 2016",
        "time":"13:18"
    },
    "fracillum":"4%",
    "curphase":"Waxing Crescent",

    "sundata":[
    {"phen":"BC", "time":"06:47"},
    {"phen":"R", "time":"07:18"},
    {"phen":"U", "time":"11:59"},
    {"phen":"S", "time":"16:40"},
    {"phen":"EC", "time":"17:11"}],

    "moondata":[
    {"phen":"R", "time":"08:37"},
    {"phen":"U", "time":"13:35"},
    {"phen":"S", "time":"18:32"}]
}
"""
}
