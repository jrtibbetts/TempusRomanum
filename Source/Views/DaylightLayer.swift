//  Copyright © 2018 Poikile Creations. All rights reserved.

import UIKit

class DaylightLayer: ClockLayer {

    fileprivate var hourLinesLayer: HourLinesLayer?

    public var hoursAndEndTime: (hours: [Date], end: Date)? {
        didSet {
            guard let hours = hoursAndEndTime?.hours,
                let end = hoursAndEndTime?.end else {
                return
            }

            let startAngle = hours[0].rotationAngle
            let sunsetAngle = end.rotationAngle
            let daylightPath = UIBezierPath(sliceCenter: center,
                                        radius: radius,
                                        startAngle: startAngle,
                                        endAngle: sunsetAngle)

            path = daylightPath.cgPath
            fillColor = UIColor.yellow.cgColor

            hourLinesLayer?.removeFromSuperlayer()
            hourLinesLayer = HourLinesLayer(hours: hours)
            hourLinesLayer?.lineWidth = 1.0
            hourLinesLayer?.strokeColor = UIColor.lightGray.cgColor
            hourLinesLayer?.frame = bounds
            addSublayer(hourLinesLayer!)
        }
    }

}
