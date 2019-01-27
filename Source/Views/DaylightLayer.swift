//  Copyright © 2018 Poikile Creations. All rights reserved.

import UIKit

/// The layer that draws the pie slice representing daylight hours on an analog
/// 24-hour clock.
class DaylightLayer: ClockSubfaceLayer {

    override var sunriseSunset: SunriseSunset? {
        didSet {
            if let hours = sunriseSunset?.daylightHourTimes {
                hourLinesLayer.hours = hours
                setNeedsLayout()
            }
        }
    }

    override init() {
        super.init()
        fillColor = UIColor(named: "Daylight")?.cgColor
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(layer: Any) {
        super.init(layer: layer)
    }

    override func updatePath() {
        guard let sunriseSunset = sunriseSunset else { return }

        path = UIBezierPath(sliceCenter: boundsCenter,
                            radius: radius,
                            startAngle: sunriseSunset.sunrise.rotationAngle,
                            endAngle: sunriseSunset.sunset.rotationAngle).cgPath
        setNeedsDisplay()
    }

}
