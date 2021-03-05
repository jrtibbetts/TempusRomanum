//  Copyright © 2018 Poikile Creations. All rights reserved.

import UIKit

/// The layer that draws the pie slice representing daylight hours on an analog
/// 24-hour clock.
class DaylightLayer: ClockSubfaceLayer {

    override var sunriseSunset: SunriseSunset? {
        didSet {
            if let hours = sunriseSunset?.daylightHours {
                hourLinesLayer.hours = hours
                setNeedsLayout()
            }
        }
    }

    override func updatePath() {
        guard let sunriseSunset = sunriseSunset else { return }
        fillColor = UIColor(named: "Daylight")?.cgColor
        updatePath(from: CGFloat(sunriseSunset.sunrise.hour12RotationAngle.degrees),
                   to: CGFloat(sunriseSunset.sunset.hour12RotationAngle.degrees))
    }

}
