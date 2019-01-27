//  Copyright © 2019 Poikile Creations. All rights reserved.

import Stylobate
import UIKit

class NighttimeClockLayer: ClockSubfaceLayer {

    override var sunriseSunset: SunriseSunset? {
        didSet {
            if let hours = sunriseSunset?.nighttimeHourTimes {
                hourLinesLayer.hours = hours
                setNeedsLayout()
            }
        }
    }

    // MARK: - Other Functions

    override func updatePath() {
        guard let sunriseSunset = sunriseSunset else { return }
        fillColor = UIColor(named: "Nighttime")?.cgColor
        updatePath(from: sunriseSunset.sunset.rotationAngle,
                   to: sunriseSunset.sunrise.rotationAngle)
    }

}
