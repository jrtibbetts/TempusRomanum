//  Copyright © 2018 Poikile Creations. All rights reserved.

import Foundation
import PromiseKit

/// Implemented by classes that can provide sunrise and sunset times for
/// today's date and the device's current location.
public protocol SunriseSunsetProvider {

    /// Get a promise that will contain the sunrise & sunset times.
    ///
    /// - returns: The solar & lunar data promise.
    func sunriseSunset() -> Promise<SunriseSunset>

}
