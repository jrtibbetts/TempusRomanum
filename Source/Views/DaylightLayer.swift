//  Copyright © 2018 Poikile Creations. All rights reserved.

import UIKit

/// The layer that draws the pie slice representing daylight hours on an analog
/// 24-hour clock.
open class DaylightLayer: ClockLayer {

    /// The layer that draws lines for each daylight hour.
    private var hourLinesLayer: HourLinesLayer?

    /// Set the daylight hour times.
    ///
    /// - parameter hours: The daylight hours.
    /// - parameter sunset: The end of daylight.
    open var hoursAndEndTime: (hours: [Date], sunset: Date)? {
        didSet {
            guard let hours = hoursAndEndTime?.hours,
                let sunset = hoursAndEndTime?.sunset,
                let startAngle = hours.first?.rotationAngle else {
                return
            }

            let sunsetAngle = sunset.rotationAngle
            let daylightPath = UIBezierPath(sliceCenter: center,
                                        radius: radius,
                                        startAngle: startAngle,
                                        endAngle: sunsetAngle)

            path = daylightPath.cgPath
            fillColor = UIColor.yellow.cgColor

            if hourLinesLayer == nil {
                hourLinesLayer = HourLinesLayer(hours: hours)
                addSublayer(hourLinesLayer!)
            } else {
                hourLinesLayer?.hours = hours
            }

            hourLinesLayer!.lineWidth = 1.0
            hourLinesLayer!.strokeColor = UIColor.darkGray.cgColor
            hourLinesLayer!.frame = bounds
            setNeedsDisplay()
        }
    }

}
