//  Copyright © 2019 Poikile Creations. All rights reserved.

@testable import Tempus_Romanum
import XCTest

class SunriseSunsetDotOrgTimesTests: XCTestCase {

    let json = """
{
    "sunrise":"7:27:02 AM",
    "sunset":"5:05:55 PM",
    "solar_noon":"12:16:28 PM",
    "day_length":"9:38:53",
    "civil_twilight_begin":"6:58:14 AM",
    "civil_twilight_end":"5:34:43 PM",
    "nautical_twilight_begin":"6:25:47 AM",
    "nautical_twilight_end":"6:07:10 PM",
    "astronomical_twilight_begin":"5:54:14 AM",
    "astronomical_twilight_end":"6:38:43 PM"
}
"""

    var times: SunriseSunsetDotOrgTimes!

    override func setUp() {
        super.setUp()

        let decoder = SunriseSunsetDotOrgProvider.SunriseSunsetDotOrgJSONDecoder()
        let jsonData = json.data(using: .utf8)!
        times = try! decoder.decode(SunriseSunsetDotOrgTimes.self, from: jsonData)
    }

    func testAstronomicalDawnIsAstronomicalTwilightBegin() {
        assert(times.astronomicalDawn, times.astronomicalTwilightBegin)
    }

    func testAstronomicalDuskIsAstronomicalTwilightEnd() {
        assert(times.astronomicalDusk, times.astronomicalTwilightEnd)
    }

    func testCivilDawnIsCivilTwilightBegin() {
        assert(times.civilDawn, times.civilTwilightBegin)
    }

    func testCivilDuskIsCivilTwilightEnd() {
        assert(times.civilDusk, times.civilTwilightEnd)
    }

    func testNauticalDawnIsNauticalTwilightBegin() {
        assert(times.nauticalDawn, times.nauticalTwilightBegin)
    }

    func testNauticalDuskIsNauticalTwilightEnd() {
        assert(times.nauticalDusk, times.nauticalTwilightEnd)
    }

    func assert(_ aliasedDate: Date, _ parsedDate: Date) {
        XCTAssertNotNil(aliasedDate)
        XCTAssertEqual(aliasedDate, parsedDate)
    }

}
