//  Copyright © 2018 Poikile Creations. All rights reserved.

import Foundation
import SwiftUI

internal extension Date {

    /// The angle of the current time's minutes, relative to 270° (the top of
    /// the circle). For example, `3:45` will have an angle of `180`, and `2:15`
    /// will have an angle of `0`.
    var minutesAngle: Angle {
        return angle(startingAt: Angle(degrees: 270.0), divisions: 60.0 * 60.0)
    }

    var hour12RotationAngle: Angle {
        return angle(startingAt: Angle(degrees: 270.0), divisions: 12.0 * 60.0 * 60.0)
    }
    
    /// The angle, in radians, of the `Date`, relative to 12:00 am the same day.
    var hour24RotationAngle: Angle {
        return angle(startingAt: Angle(degrees: 270.0), divisions: 24.0 * 60.0 * 60.0)
    }
    
    func angle(startingAt startingPoint: Angle,
               divisions: Double) -> Angle {
        let midnight = Calendar.current.startOfDay(for: self)
        print("Midnight: \(midnight)")
        let timeInMinutes = self.timeIntervalSince(midnight).truncatingRemainder(dividingBy: divisions)
        print("Time in minutes: \(timeInMinutes)")
        let percentage = timeInMinutes / (divisions)
        print("Percentage: \(percentage)")
        let radians = (startingPoint.radians + (Double.pi * 2 * Double(percentage))).truncatingRemainder(dividingBy: (Double.pi * 2.0))

        return Angle(radians: radians)
    }
    
}
