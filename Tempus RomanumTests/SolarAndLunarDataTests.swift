//  Copyright © 2018 Poikile Creations. All rights reserved.

@testable import Tempus_Romanum
import XCTest

class SolarAndLunarDataTests: XCTestCase {

    func testSolarAndLunarDataParsesCorrectly() {
        guard let rawData = sampleJson.data(using: .utf8) else {
            XCTFail("Failed to create raw data from the sampleJSON property.")
            return
        }

        do {
            let parsedData = try JSONDecoder().decode(SolarAndLunarData.self, from: rawData)
            XCTAssertFalse(parsedData.error)
            XCTAssertEqual(parsedData.year, 2016)
            XCTAssertEqual(parsedData.timeZoneOffset, 1)
        } catch {
            XCTFail("Failed to parse the sample JSON property as valid JSON.")
        }
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
