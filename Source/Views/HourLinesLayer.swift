//  Copyright © 2018 Poikile Creations. All rights reserved.

import UIKit

/// A `CALayer` that draws lines from its center to points along the perimeter
/// of a circle that just fills the frame, where the points correspond to times
/// relative to midnight on the date.
open class HourLinesLayer: CAShapeLayer {

    public convenience init(rect: CGRect,
                            dates: [Date]) {
        self.init()

        // Set up the geometry.
        frame = rect
        let center = CGPoint(x: rect.width / 2.0, y: rect.height / 2.0)
        let minimumDimension = min(rect.width, rect.height)
        let radius = minimumDimension / 2.0

        // Create the path.
        let path = UIBezierPath()
        path.lineWidth = 2.0

        dates.forEach { (date) in
            let angle = date.rotationAngle  // relative to midnight of that
                                            // date.
            path.move(to: center)
            let borderPoint = CGPoint(x: center.x + (radius * cos(angle)),
                                      y: center.y + (radius * sin(angle)))
            path.addLine(to: borderPoint)
        }

        self.path = path.cgPath
    }

}
