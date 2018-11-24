//  Copyright © 2018 Poikile Creations. All rights reserved.

import UIKit

/// A `CALayer` that draws lines from its center to points along the perimeter
/// of a circle that just fills the frame, where the points correspond to times
/// relative to midnight on the date.
open class HourLinesLayer: ClockLayer {

    // MARK: - Internal Properties

    /// The `Date`s of the hours to be drawn.
    internal let hours: [Date]

    /// The encoding key for the `hours` field.
    fileprivate let hoursKey = "hours"

    // MARK: - Initializers & Serialization

    /// Create an hours layer with a list of hour `Date`s.
    ///
    /// - parameter hours: The hour times for which to draw lines. They don't
    /// need to be in chronological order, but all of them _should_ be on the
    /// same calendar date, if you don't want strange results.
    public init(hours: [Date]) {
        self.hours = hours
        super.init()
    }

    /// Create an hours layer by deserializing one.
    required public init?(coder aDecoder: NSCoder) {
        guard let hours = aDecoder.decodeObject(forKey: hoursKey) as? [Date] else {
            return nil
        }

        self.hours = hours
        super.init(coder: aDecoder)
    }

    /// Serialize the hours layer.
    override open func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        aCoder.encode(hours, forKey: hoursKey)
    }

    // MARK: - CALayer

    override open func layoutIfNeeded() {
        super.layoutIfNeeded()

        // Create the path with a line from the layer's center point to the
        // points at which each hour falls on the circle.
        let path = UIBezierPath()
        path.lineWidth = 2.0

        hours.forEach { (hour) in
            let angle = hour.rotationAngle  // relative to midnight of that
                                            // hour.
            path.move(to: center)
            let borderPoint = CGPoint(x: center.x + (radius * cos(angle)),
                                      y: center.y + (radius * sin(angle)))
            path.addLine(to: borderPoint)
        }

        self.path = path.cgPath
    }

}
