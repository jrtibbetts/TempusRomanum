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
                let sunriseAngle = hours.first?.rotationAngle else {
                    return
            }

            let sunsetAngle = sunset.rotationAngle
            let daylightPath = UIBezierPath(sliceCenter: boundsCenter,
                                            radius: radius,
                                            startAngle: sunriseAngle,
                                            endAngle: sunsetAngle)

            path = daylightPath.cgPath
            fillColor = UIColor(named: "Daylight")?.cgColor

            if hourLinesLayer == nil {
                hourLinesLayer = HourLinesLayer(hours: hours)
                addSublayer(hourLinesLayer!)
            } else {
                hourLinesLayer?.hours = hours
            }

            hourLinesLayer!.lineWidth = 1.0
            hourLinesLayer!.strokeColor = UIColor(named: "Hour Marks")?.cgColor
            hourLinesLayer!.frame = bounds
            setNeedsDisplay()
        }
    }

}
