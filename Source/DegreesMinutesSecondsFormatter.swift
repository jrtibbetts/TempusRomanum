//  Copyright © 2018 Poikile Creations. All rights reserved.

import CoreLocation
import Foundation

public extension Double {

    public var minutesPerHour: Double { return 60.0 }
    public var secondsPerHour: Double { return minutesPerHour * 60.0 }

    public var minutes: Double {
        return (self * secondsPerHour)
            .truncatingRemainder(dividingBy: secondsPerHour) / minutesPerHour
    }

    public var seconds: Double {
        return (self * secondsPerHour)
            .truncatingRemainder(dividingBy: secondsPerHour)
            .truncatingRemainder(dividingBy: minutesPerHour)
    }

}

extension CLLocationCoordinate2D {

    var degreesMinutesSeconds: (latitude: String, longitude: String) {
        return (String(format:"%d° %d' %.4f\" %@",
                       Int(abs(latitude)),
                       Int(abs(latitude.minutes)),
                       abs(latitude.seconds),
                       latitude >= 0 ? "N" : "S"),
                String(format:"%d° %d' %.4f\" %@",
                       Int(abs(longitude)),
                       Int(abs(longitude.minutes)),
                       abs(longitude.seconds),
                       longitude >= 0 ? "E" : "W"))
    }

}
