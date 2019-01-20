//  Copyright © 2018 Poikile Creations. All rights reserved.

import CoreGraphics
import Stylobate
import UIKit

/// A layer that draws the midnight, 3 am, 6 am, 9 am, noon, 3 pm, 6 pm, and
/// 9 pm labels on a round, analog 24-hour clock.
open class ModernHourMarksLayer: CALayer {

    // MARK: - Public Properties


    private var font: CGFont? {
        didSet {
            labelLayers.forEach { (layer) in
                layer.font = font
            }

            setNeedsDisplay()
        }
    }

    open var fontSize: CGFloat {
        return margin / 3.5
    }

    open var foregroundColor: CGColor? {
        didSet {
            labelLayers.forEach { (layer) in
                layer.foregroundColor = foregroundColor
            }

            setNeedsDisplay()
        }
    }

    /// The width of the band _outside_ the circle, where the marks will be
    /// drawn.
    open var margin: CGFloat {
        didSet {
            setNeedsLayout()
        }
    }

    /// The radius of the clock face around which the marks will be drawn.
    open var radius: CGFloat {
        didSet {
            setNeedsLayout()
        }
    }

    // MARK: - Private Properties

    private var labelLayers: [CATextLayer] {
        return [midnightLayer, noonLayer, sixAmLayer, sixPmLayer]
    }

    private var midnightLayer = CATextLayer()

    private var noonLayer = CATextLayer()

    private var sixAmLayer = CATextLayer()

    private var sixPmLayer = CATextLayer()

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

        midnightLayer.string = "12 am"
        midnightLayer.alignmentMode = .center
        addSublayer(midnightLayer)

        sixAmLayer.string = "6 am"
        sixAmLayer.alignmentMode = .right
        addSublayer(sixAmLayer)

        noonLayer.string = "12 pm"
        noonLayer.alignmentMode = .center
        addSublayer(noonLayer)

        sixPmLayer.string = "6 pm"
        sixPmLayer.alignmentMode = .left
        addSublayer(sixPmLayer)

        labelLayers.forEach { (layer) in
            layer.font = font ?? UIFont.systemFont(ofSize: fontSize)
            layer.fontSize = fontSize
            layer.foregroundColor = foregroundColor
        }
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - CALayer

    open override func layoutSublayers() {
        super.layoutSublayers()

        let labelWidth = margin * 0.9
        let labelHeight = margin * 0.4
        let textLayerSize = CGSize(width: labelWidth, height: labelHeight)

        let noonLayerOrigin = CGPoint(x: (bounds.width - labelWidth) / 2.0,
                                      y: margin - labelHeight)
        noonLayer.frame = CGRect(origin: noonLayerOrigin, size: textLayerSize)

        let sixPmLayerOrigin = CGPoint(x: (margin - labelWidth) / 2.0,
                                       y: (bounds.height - labelHeight) / 2.0)
        sixPmLayer.frame = CGRect(origin: sixPmLayerOrigin, size: textLayerSize)

        let midnightLayerOrigin = CGPoint(x: (bounds.width - labelWidth) / 2.0,
                                          y: bounds.height - margin)
        midnightLayer.frame = CGRect(origin: midnightLayerOrigin, size: textLayerSize)

        let sixAmLayerOrigin = CGPoint(x: bounds.width - margin,
                                       y: (bounds.height - labelHeight) / 2.0)
        sixAmLayer.frame = CGRect(origin: sixAmLayerOrigin, size: textLayerSize)
    }

}
