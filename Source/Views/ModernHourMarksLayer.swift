//  Copyright © 2018 Poikile Creations. All rights reserved.

import CoreGraphics
import Stylobate
import UIKit

/// A layer that draws the midnight, 3 am, 6 am, 9 am, noon, 3 pm, 6 pm, and
/// 9 pm labels on a round, analog 24-hour clock.
open class ModernHourMarksLayer: CALayer, Codable {

    // MARK: - Public Properties

    /// The width of the band _outside_ the circle, where the marks will be
    /// drawn.
    open var margin: CGFloat

    /// The radius of the clock face around which the marks will be drawn.
    open var radius: CGFloat

    // MARK: - Initialization

    /// Create a layer for a circle of a given radius, with a specified margin
    /// margin (_beyond_ the radius) for the mark labels.
    ///
    /// - parameter radius: The radius of the clock-face circle around which
    ///             the marks will be drawn. It cannot be less than 0, but this
    ///             class does not enforce that.
    /// - parameter margin: The margin _outside_ the radius in which the marks
    ///             will be drawn.
    public init(radius: CGFloat, margin: CGFloat = 30.0) {
        self.radius = radius
        self.margin = margin
        super.init()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - CALayer

    open override func draw(in ctx: CGContext) {
        super.draw(in: ctx)

        let textLayerSize = CGSize(width: 30.0, height: margin * 0.9)

        let noonLayer = CATextLayer() <~ {
            $0.string = "12 pm"
            $0.position = CGPoint(x: bounds.width / 2.0, y: 0)
            $0.frame = CGRect(origin: $0.position, size: textLayerSize)
        }
        addSublayer(noonLayer)

        let sixPmLayer = CATextLayer() <~ {
            $0.string = "6 pm"
            $0.position = CGPoint(x: 0, y: bounds.height / 2.0)
            $0.frame = CGRect(origin: $0.position, size: textLayerSize)
        }
        addSublayer(sixPmLayer)
    }

}
