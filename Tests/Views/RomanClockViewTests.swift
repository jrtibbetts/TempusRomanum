//  Copyright © 2019 Poikile Creations. All rights reserved.

@testable import Tempus_Romanum
import XCTest

class RomanClockViewTests: XCTestCase {

    func NOtestSetSunriseSunsetOk() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let viewController = storyboard.instantiateViewController(withIdentifier: "Main")
        let rootView = viewController.view  // force viewDidLoad() to be called

        if let clockView = rootView?.viewWithTag(23) as? RomanClockView {
            XCTAssertNil(clockView.sunriseSunset)

            let sunriseSunset = SimpleSunriseSunset(sunrise: Date(),
                                                    sunset: Date().addingTimeInterval(12 * 60 * 60))
            clockView.sunriseSunset = sunriseSunset
            XCTAssertNotNil(clockView.sunriseSunset)
        } else {
            XCTFail("Couldn't find the RomanClockView. It should be tagged with '23'.")
        }
    }

}
