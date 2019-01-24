//  Copyright © 2018 Poikile Creations. All rights reserved.

import UIKit

/// A `CALayer` that draws lines from its center to points along the perimeter
/// of a circle that just fills the frame, where the points correspond to times
/// relative to midnight on the date.
open class HourLinesLayer: ClockLayer {

    // MARK: - Internal Properties

    /// The `Date`s of the hours to be drawn.
    open var hours: [Date] {
        didSet {
            layoutIfNeeded()
        }
    }

    /// The encoding key for the `hours` field.
    fileprivate let hoursKey = "hours"

    // MARK: - Initializers & Serialization

    /// Create an hours layer with a list of hour `Date`s.
    ///
    /// - parameter hours: The hour times for which to draw lines. They don't
    /// need to be in chronological order, but all of them _should_ be on the
    /// same calendar date, if you don't want strange results.
    public init(hours: [Date] = []) {
        self.hours = hours
        super.init()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override init(layer: Any) {
        self.hours = []
        super.init(layer: layer)
    }

    open override func layoutSublayers() {
        // Create the path with a line from the layer's center point to the
        // points at which each hour falls on the circle.
        let path = UIBezierPath()
        path.lineWidth = 1.0

        hours.dropFirst().forEach { (hour) in
            let angle = hour.rotationAngle  // relative to 12 am of the same
            // day.
            path.move(to: boundsCenter)
            let borderPoint = CGPoint(x: boundsCenter.x + (radius * cos(angle)),
                                      y: boundsCenter.y + (radius * sin(angle)))
            path.addLine(to: borderPoint)
        }

        self.path = path.cgPath
        setNeedsDisplay()
    }

}
