//  Copyright © 2018 Poikile Creations. All rights reserved.

import UIKit

/// The layer that draws the pie slice representing daylight hours on an analog
/// 24-hour clock.
class DaylightLayer: ClockLayer {

    /// The layer that draws lines for each daylight hour.
    fileprivate var hourLinesLayer: HourLinesLayer?

    /// Set the daylight hour times.
    ///
    /// - parameter hours: The daylight hours.
    /// - parameter sunset: The end of daylight.
    public var hoursAndEndTime: (hours: [Date], sunset: Date)? {
        didSet {
            guard let hours = hoursAndEndTime?.hours,
                let sunset = hoursAndEndTime?.sunset else {
                return
            }

            let startAngle = hours[0].rotationAngle
            let sunsetAngle = sunset.rotationAngle
            let daylightPath = UIBezierPath(sliceCenter: center,
                                        radius: radius,
                                        startAngle: startAngle,
                                        endAngle: sunsetAngle)

            path = daylightPath.cgPath
            fillColor = UIColor.yellow.cgColor

            hourLinesLayer?.removeFromSuperlayer()
            hourLinesLayer = HourLinesLayer(hours: hours)
            hourLinesLayer?.lineWidth = 1.0
            hourLinesLayer?.strokeColor = UIColor.darkGray.cgColor
            hourLinesLayer?.frame = bounds
            addSublayer(hourLinesLayer!)
            setNeedsDisplay()
        }
    }

}
