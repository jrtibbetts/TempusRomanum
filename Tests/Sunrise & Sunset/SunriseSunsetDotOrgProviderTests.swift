//  Copyright © 2019 Poikile Creations. All rights reserved.

@testable import Tempus_Romanum
import Stylobate
import XCTest

class SunriseSunsetDotOrgProviderTests: XCTestCase {

    func testDecoderThrowsWhenDateIsMalformed() {
        let decoder = SunriseSunsetDotOrgProvider.Decoder()
        let jsonString =
        """
{
"sunrise":"7:27:02 AM",
"sunset":"5:05:55 PM",
}
"""
        let jsonData = jsonString.data(using: .utf8)!

        do {
            _ = try decoder.decode(SimpleSunriseSunset.self, from: jsonData)
            XCTFail("A DecodingError.dataCorrupted error should have been thrown.")
        } catch DecodingError.dataCorrupted(let context) {
            XCTAssertTrue(context.debugDescription.starts(with: "Date values must be formatted"))
        } catch {
            XCTFail("A DecodingError.dataCorrupted error should have been thrown.")
        }
    }

}
