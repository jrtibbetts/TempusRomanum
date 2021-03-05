//  Copyright © 2018 Poikile Creations. All rights reserved.

import Foundation
import SwiftUI

internal extension Date {

    var minutesAngle: Angle {
        return angle(startingAt: Angle(radians: (Double.pi * 1.5)), divisions: 60.0 * 60.0)
    }

    var hour12RotationAngle: Angle {
        return angle(startingAt: Angle(radians: (Double.pi * 0.5)), divisions: 12.0 * 60.0 * 60.0)
    }
    
    /// The angle, in radians, of the `Date`, relative to 12:00 am the same day.
    var hour24RotationAngle: Angle {
        return angle(startingAt: Angle(radians: (Double.pi * 0.5)), divisions: 24.0 * 60.0 * 60.0)
    }
    
    func angle(startingAt startingPoint: Angle,
               divisions: Double) -> Angle {
        let midnight = Calendar.current.startOfDay(for: self)
        let timeInMinutes = timeIntervalSince(midnight).truncatingRemainder(dividingBy: divisions)
        let percentage = timeInMinutes / (divisions)
        
        return Angle(radians: startingPoint.radians + (Double.pi * 2 * Double(percentage)))
    }
    
}
