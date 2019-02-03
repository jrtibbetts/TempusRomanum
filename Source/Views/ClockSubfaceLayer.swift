//  Copyright © 2019 Poikile Creations. All rights reserved.

import Stylobate
import UIKit

/// Base class for the daytime and nighttime clock subfaces. I'm sure that
/// there's an official watchmaking term for the daytime and nighttime sections,
/// but I couldn't find one!
class ClockSubfaceLayer: ClockLayer {

    // MARK: - Public Properties

    /// The layer that draws lines for each hour in this subface.
    var hourLinesLayer = HourLinesLayer() <~ {
        $0.strokeColor = UIColor(named: "Hour Marks")?.cgColor
        $0.lineWidth = 1.0
    }

    /// The astronomical information.
    var sunriseSunset: SunriseSunset?


    // MARK: - CALayer

    override func layoutSublayers() {
        super.layoutSublayers()

        if hourLinesLayer.superlayer == nil {
            addSublayer(hourLinesLayer)
        }

        hourLinesLayer.frame = bounds
        hourLinesLayer.layoutSublayers()

        updatePath()
    }

    // MARK: - Other Functions

    /// Recalculate the Bézier path. This implementation does nothing, so
    /// subclasses should override it with their own implementation, call
    /// `updateDate(from:to:)`, and not bother calling `super.updatePath()`.
    func updatePath() {
    }

    func updatePath(from startAngle: CGFloat, to endAngle: CGFloat) {
        path = UIBezierPath(sliceCenter: boundsCenter,
                            radius: radius,
                            startAngle: startAngle,
                            endAngle: endAngle).cgPath
        setNeedsDisplay()
    }

}
