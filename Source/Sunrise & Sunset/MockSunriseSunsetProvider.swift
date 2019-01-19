//  Copyright © 2018 Poikile Creations. All rights reserved.

import PromiseKit
import UIKit

public struct MockSunriseSunsetProvider: SunriseSunsetProvider {
    public func sunriseSunset() -> Promise<SunriseSunset> {
        return Promise<SunriseSunset> { (promise) in
            let midnightToday = Calendar.current.startOfDay(for: Date())
            let sunrise = midnightToday.addingTimeInterval(5.45 * 60 * 60)
            let sunset = midnightToday.addingTimeInterval(19.02 * 60 * 60)
            let sunriseSunset = SunriseSunset(sunrise: sunrise, sunset: sunset)
            promise.fulfill(sunriseSunset)
        }
    }

}
