//  Copyright © 2019 Poikile Creations. All rights reserved.

import CoreLocation

public extension CLLocationCoordinate2D {

    public typealias CoordinateStrings = (latitude: String, longitude: String)

    public var strings: CoordinateStrings {
        return formatted(with: "%.2f")
    }

    public func formatted(with pattern: String) -> CoordinateStrings {
        return (String(format: pattern, latitude),
                String(format: pattern, longitude))
    }

}
