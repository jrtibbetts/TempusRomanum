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
            XCTFail("A DecodingError.dataCorruptedError should have been thrown.")
        } catch {
            // I can't seem to catch the specific DecodingError.dataCorruptedError;
            // see my question at https://stackoverflow.com/questions/54546829/swift-cant-catch-specific-error-case-with-associated-data
        }
    }

}
