//  Copyright © 2018 Poikile Creations. All rights reserved.

import PromiseKit
import UIKit

open class MockSunriseSunsetProvider: SunriseSunsetProvider {

    struct MockSunriseSunset: SunriseSunset {
        var sunrise: Date
        var sunset: Date
    }

    public func sunriseSunset() -> Promise<SunriseSunset> {
        return Promise<SunriseSunset> { (promise) in
            let startOfToday = Calendar.current.startOfDay(for: Date())
            let sunrise = startOfToday.addingTimeInterval(5.3 * 60.0 * 60.0)
            let sunset = startOfToday.addingTimeInterval(19.12 * 60.0 * 60.0)
            promise.fulfill(MockSunriseSunset(sunrise: sunrise, sunset: sunset))
        }
    }
    
}
