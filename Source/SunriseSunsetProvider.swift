//  Copyright © 2018 Poikile Creations. All rights reserved.

import CoreLocation
import Foundation
import PMKCoreLocation
import PMKFoundation
import Stylobate

public protocol SunriseSunsetProvider {

    /// Get a promise that will contain the sunrise & sunset times.
    ///
    /// - returns: The solar & lunar data promise.
    func sunriseSunset() -> Promise<SunriseSunset>

}

public struct SunriseSunsetDotOrgProvider: SunriseSunsetProvider {

    public func sunriseSunset() -> Promise<SunriseSunset> {
        return CLLocationManager.requestLocation().then { (locations) -> Promise<SunriseSunset> in
            return self.sunriseSunset(for: locations[0].coordinate)
        }
    }

    public func sunriseSunset(for coordinate: CLLocationCoordinate2D,
                              date: Date = Date(),
                              formatDates: Bool = false) -> Promise<SunriseSunset> {
        return Promise<SunriseSunset> { (promise) in
            promise.reject(NSError(domain: "SunriseSunsetDotOrgProvider", code: 1, userInfo: nil))
        }
    }

}
