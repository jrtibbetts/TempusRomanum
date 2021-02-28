//  Copyright © 2018 Poikile Creations. All rights reserved.

import CoreGraphics
import Stylobate
import UIKit

/// A layer that draws the midnight, 3 am, 6 am, 9 am, noon, 3 pm, 6 pm, and
/// 9 pm labels on a round, analog 24-hour clock.
open class ModernHourMarksLayer: ClockLayer {

    // MARK: - Public Properties

    open override var frame: CGRect {
        didSet {
            updateMarks()
        }
    }

    open var foregroundColor: CGColor? {
        didSet {
            strokeColor = foregroundColor
            setNeedsDisplay()
        }
    }

    /// The width of the band _outside_ the circle, where the marks will be
    /// drawn.
    open var margin: CGFloat = 0.0 {
        didSet {
            updateMarks()
        }
    }

    private var hourLayers: [CATextLayer] = []

    private var innerRadius: CGFloat {
        return radius - margin
    }

    private var innerFrame: CGRect {
        let innerWidth = innerRadius * 2.0
        let origin = CGPoint(x: margin, y: margin)

        return CGRect(origin: origin, size: CGSize(width: innerWidth, height: innerWidth))
    }

    // MARK: - CAShapeLayer

    open override func layoutSublayers() {
        // Don't call super.layoutSublayers()

        if frame.isEmpty {
            return
        }
        
        hourLayers.forEach { (layer) in
            layer.removeFromSuperlayer()
        }

        ["12 p.m.": CGFloat.pi * 1.5, "6 p.m.": 0.0, "12 a.m.": CGFloat.pi * 0.5, "6 a.m.": CGFloat.pi].forEach { (key, angle) in
            let layer = CATextLayer()
            layer.string = key
            layer.alignmentMode = .center
            layer.fontSize = margin * 0.67
            layer.frame = CGRect(x: 0.0, y: 0.0, width: margin * 2.0, height: margin)
            hourLayers.append(layer)
            addSublayer(layer)
            layer.setAffineTransform(CGAffineTransform(rotationAngle: angle + (CGFloat.pi / 2.0)))
            layer.center(at: CGPoint(x: boundsCenter.x + (radius * cos(angle)),
                                     y: boundsCenter.y + (radius * sin(angle))))
            layer.foregroundColor = UIColor.black.cgColor
        }
    }

    // MARK: - Other Functions

    private func updateMarks() {
        if frame.isEmpty {
            return
        }

        fillColor = UIColor.clear.cgColor
        strokeColor = UIColor.black.cgColor
        lineWidth = 2.0
        let path = UIBezierPath()

        // Noon
        stride(from: 0.0, to: 360.0, by: 15.0).enumerated().forEach { (index, angle) in
            if index % 6 == 0 {
                return
            } else {
                addLine(fromBorderAt: (CGFloat.pi * 2.0 * CGFloat(angle) / 360.0), length: -margin * 0.4, toPath: path)
            }
        }

        self.path = path.cgPath
        setNeedsDisplay()
    }

    private func addLine(fromBorderAt angle: CGFloat,
                         length: CGFloat,
                         toPath path: UIBezierPath) {
        path.move(to: borderPoint(at: angle))
        path.addLine(to: CGPoint(x: boundsCenter.x + ((radius + length) * cos(angle)),
                                 y: boundsCenter.y + ((radius + length) * sin(angle))))
    }

}
