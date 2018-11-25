//  Copyright © 2018 Poikile Creations. All rights reserved.

import CoreLocation
import Foundation
import PMKCoreLocation
import PMKFoundation
import Stylobate

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
