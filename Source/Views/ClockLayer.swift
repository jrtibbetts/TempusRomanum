//  Copyright © 2018 Poikile Creations. All rights reserved.

import UIKit

/// Base class for shape layers that display components of a round, analog
/// clock face.
open class ClockLayer: CAShapeLayer {

    // MARK: - Properties

    /// Get the diameter of the largest circle that will fit in the bounds.
    open var diameter: CGFloat {
        return min(bounds.width, bounds.height)
    }

    /// Get the exact center of the layer's `bounds`.
    open var boundsCenter: CGPoint {
        return CGPoint(x: bounds.width / 2.0, y: bounds.height / 2.0)
    }

    /// Get the maximum radius of a circle that will fit in the bounds.
    open var radius: CGFloat {
        return diameter / 2.0
    }

    // MARK: - Functions

    /// Get the point along the circle at the specified angle.
    ///
    /// - parameter angle: The angle, expressed as a float from `0.0` to `2π`.
    ///
    /// - returns: The point along the circle at the specified angle.
    open func borderPoint(at angle: CGFloat) -> CGPoint {
        return CGPoint(x: boundsCenter.x + (radius * cos(angle)),
                       y: boundsCenter.y + (radius * sin(angle)))
    }

}
