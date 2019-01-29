//  Copyright © 2018 Poikile Creations. All rights reserved.

import PromiseKit
import UIKit

struct SimpleSunriseSunset: SunriseSunset {

    var astronomicalDawn: Date?

    var astronomicalDusk: Date?

    var civilDawn: Date?

    var civilDusk: Date?

    var nauticalDawn: Date?

    var nauticalDusk: Date?

    var sunrise: Date

    var sunset: Date

    init(sunrise: Date, sunset: Date,
         astronomicalDawn: Date? = nil, astronomicalDusk: Date? = nil,
         civilDawn: Date? = nil,        civilDusk: Date? = nil,
         nauticalDawn: Date? = nil,     nauticalDusk: Date? = nil) {
        self.sunrise = sunrise
        self.sunset = sunset
        self.astronomicalDawn = astronomicalDawn
        self.astronomicalDusk = astronomicalDusk
        self.civilDawn = civilDawn
        self.civilDusk = civilDusk
        self.nauticalDawn = nauticalDawn
        self.nauticalDusk = nauticalDusk
    }

}

open class MockSunriseSunsetProvider: SunriseSunsetProvider {

    public func sunriseSunset() -> Promise<SunriseSunset> {
        return Promise<SunriseSunset> { (promise) in
            let startOfToday = Calendar.current.startOfDay(for: Date())
            let sunrise = startOfToday.addingTimeInterval(5.3 * 60.0 * 60.0)
            let sunset = startOfToday.addingTimeInterval(19.12 * 60.0 * 60.0)

            promise.fulfill(SimpleSunriseSunset(sunrise: sunrise, sunset: sunset))
        }
    }
    
}
