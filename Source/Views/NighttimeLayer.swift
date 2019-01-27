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

    override init() {
        super.init()
        fillColor = UIColor(named: "Nighttime")?.cgColor
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(layer: Any) {
        super.init(layer: layer)
    }

    // MARK: - Other Functions

    override func updatePath() {
        guard let sunriseSunset = sunriseSunset else { return }

        path = UIBezierPath(sliceCenter: boundsCenter,
                            radius: radius,
                            startAngle: sunriseSunset.sunset.rotationAngle,
                            endAngle: sunriseSunset.sunrise.rotationAngle).cgPath
        setNeedsDisplay()
    }

}
