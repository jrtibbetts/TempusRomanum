//  Copyright © 2019 Poikile Creations. All rights reserved.

@testable import Tempus_Romanum
import XCTest

class SunriseSunsetDotOrgTimesTests: XCTestCase {

    let json = """
{
    "sunrise":"2015-05-21T05:05:35+00:00",
    "sunset":"2015-05-21T19:22:59+00:00",
    "solar_noon":"2015-05-21T12:14:17+00:00",
    "day_length":51444,
    "civil_twilight_begin":"2015-05-21T04:36:17+00:00",
    "civil_twilight_end":"2015-05-21T19:52:17+00:00",
    "nautical_twilight_begin":"2015-05-21T04:00:13+00:00",
    "nautical_twilight_end":"2015-05-21T20:28:21+00:00",
    "astronomical_twilight_begin":"2015-05-21T03:20:49+00:00",
    "astronomical_twilight_end":"2015-05-21T21:07:45+00:00"
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
