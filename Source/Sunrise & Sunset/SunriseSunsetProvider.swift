//  Copyright © 2018 Poikile Creations. All rights reserved.

import Combine
import CoreLocation

/// Implemented by classes that can provide sunrise and sunset times for
/// today's date and the device's current location.
public protocol SunriseSunsetProvider {

    var sunriseSunset: SunriseSunset { get }

    var sunriseSunsetPublisher: PassthroughSubject<SunriseSunset, Error> { get }

    /// Fetch the sunrise & sunset times for the user's current location and
    /// date. When finished, the `sunriseSunset` property will be updated.
    func start()

    func stop()

}
