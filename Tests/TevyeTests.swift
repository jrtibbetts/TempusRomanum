//  Copyright © 2018 Poikile Creations. All rights reserved.

@testable import Tempus_Romanum
import CoreLocation
import PromiseKit
import XCTest

class TevyeTests: XCTestCase {

    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"

        return formatter
    }()

    lazy var timeZoneOffsetFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "%z"

        return formatter
    }()

    // MARK: - url(for:date:)

    func testUrlWithDefaultDateOk() {
        let coords = CLLocationCoordinate2D(latitude: 45.00, longitude: -45.00)
        let date = Date()
        let dateString = dateFormatter.string(from: date)
        let expectedUrl = URL(string: "http://api.usno.navy.mil/rstt/oneday?date=\(dateString)&coords=45.00,-45.00&tz=-5")!

        do {
            guard let actualUrl = try Tevye.url(for: coords, date: date) else {
                XCTFail("The URL returned by Tevye is nil.")
                return
            }

            XCTAssertEqual(actualUrl.absoluteString, expectedUrl.absoluteString)
        } catch {
            XCTFail("The URL couldn't be constructed: \(error.localizedDescription)")
        }
    }

    func testUrlWithSpecificDateOk() {
        let coords = CLLocationCoordinate2D(latitude: 45.00, longitude: -45.00)
        let expectedUrl = URL(string: "http://api.usno.navy.mil/rstt/oneday?date=10/11/1987&coords=45.00,-45.00&tz=-5")!

        do {
            guard let actualUrl = try Tevye.url(for: coords,
                                                date: Date(timeIntervalSince1970: 560994216.106689)) else {
                XCTFail("The URL returned by Tevye is nil.")
                return
            }

            XCTAssertEqual(actualUrl.absoluteString, expectedUrl.absoluteString)
        } catch {
            XCTFail("The URL couldn't be constructed: \(error.localizedDescription)")
        }
    }

    // MARK: - sunriseSunset()

    /// In order for this test to run, the app must be set up with app transport
    /// security and an exception for the navy.mil domain.
    func testSunriseSunsetReturnsOk() {
        let exp = expectation(description: "sunriseSunset()")

        let tevye = Tevye()
        tevye.sunriseSunset().done { (solarAndLunarData) in
            exp.fulfill()
            }.catch { (error) in
                XCTFail("There was an error getting the latest sunrise & sunset data")
                print(error)
        }

        wait(for: [exp], timeout: 10.0)
    }
    
}
