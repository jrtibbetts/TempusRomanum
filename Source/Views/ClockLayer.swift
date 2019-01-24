//  Copyright © 2018 Poikile Creations. All rights reserved.

import UIKit

/// Base class for shape layers that display components of a round, analog
/// clock face.
open class ClockLayer: CAShapeLayer {

    /// Get the exact center of the layer's `bounds`.
    open var boundsCenter: CGPoint {
        return CGPoint(x: bounds.width / 2.0, y: bounds.height / 2.0)
    }

    /// Get the maximum radius of a circle that will fit in the bounds.
    open var radius: CGFloat {
        return diameter / 2.0
    }

    /// Get the diameter of the largest circle that will fit in the bounds.
    open var diameter: CGFloat {
        return min(bounds.width, bounds.height)
    }

}
