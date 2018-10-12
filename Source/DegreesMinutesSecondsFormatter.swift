//  Copyright © 2018 Poikile Creations. All rights reserved.

import CoreLocation
import Foundation

// See https://stackoverflow.com/questions/35120793/convert-mapkit-latitude-and-longitude-to-dms-format/35120978#35120978
public struct DMSCoordinate: Codable {
    
    public var degrees: Int {
        return abs(Int(decimalDegrees)) // == floor(self)
    }

    public var minutes: Int {
        let x = (decimalDegrees * 3600.0)
        let y = x.truncatingRemainder(dividingBy: 3600.0).rounded()
        let z = y / 60.0
        return abs(Int(z))
    }

    public var seconds: Int {
        let x = (decimalDegrees * 3600.0)
        let y = x.truncatingRemainder(dividingBy: 3600.0)
        let z = y.truncatingRemainder(dividingBy: 60.0).rounded()

        return abs(Int(z))
    }

    fileprivate let decimalDegrees: Double

    public init(decimalDegrees: Double) {
        self.decimalDegrees = decimalDegrees
    }

    var asString: String {
        return String(format: "\(degrees)° \(minutes)' \(seconds)\"", seconds)
    }
    
}

extension CLLocationCoordinate2D {
    
    var degreesMinutesSeconds: (latitude: DMSCoordinate, longitude: DMSCoordinate) {
        let lat = DMSCoordinate(decimalDegrees: self.latitude)
        let lon = DMSCoordinate(decimalDegrees: self.longitude)

        return (lat, lon)
    }
    
    var degreesMinutesSecondsString: (latitude: String, longitude: String) {
        let dms = degreesMinutesSeconds
        return ("\(dms.latitude.asString) " + (dms.latitude.degrees >= 0 ? "N" : "S"),
                "\(dms.longitude.asString) " + (dms.longitude.degrees >= 0 ? "E" : "W"))
    }
    
}
