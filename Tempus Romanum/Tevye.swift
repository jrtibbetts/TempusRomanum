//  Copyright © 2018 Poikile Creations. All rights reserved.

import CoreLocation
import Foundation
import PromiseKit

public final class Tevye: NSObject, CLLocationManagerDelegate {

    public typealias SunriseSunset = (Date, Date)

    // Example: http://api.usno.navy.mil/rstt/oneday?date=12/1/2016&coords=41.89N,12.48E&tz=1
    fileprivate let urlPattern = "http://api.usno.navy.mil/rstt/oneday?date=%@&coords=%@,%@&tz=%@"
    fileprivate var latitudeString: String = ""
    fileprivate var longitudeString: String = ""
    fileprivate var timezoneOffset: Int {
        return Date()
    }

    public func sunriseSunset(for location: CLLocation) -> Promise<SunriseSunset> {
        return Promise<SunriseSunset> { (seal) in
            seal.fulfill((Date(), Date()))
        }
    }

    public func locationManager(_ manager: CLLocationManager,
                                didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            latitudeString = String(double: location.coordinate.latitude)
            let longitude = location.coordinate.longitude
        }
    }

}
