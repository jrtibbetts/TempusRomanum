//  Copyright © 2018 Poikile Creations. All rights reserved.

import UIKit

/// A `CALayer` that draws lines from its center to points along the perimeter
/// of a circle that just fills the frame, where the points correspond to times
/// relative to midnight on the date.
open class HourLinesLayer: ClockLayer {

    // MARK: - Internal Properties

    /// The `Date`s of the hours to be drawn.
    open var hours: [Date] = [] {
        didSet {
            layoutIfNeeded()
        }
    }

    /// The encoding key for the `hours` field.
    fileprivate let hoursKey = "hours"

    open override func layoutSublayers() {
        sublayers?.forEach { $0.removeFromSuperlayer() }

        // Create the path with a line from the layer's center point to the
        // points at which each hour falls on the circle.
        let path = UIBezierPath()
        path.lineWidth = lineWidth
        let numeralMargin: CGFloat = 20.0

        hours.dropFirst().enumerated().forEach { (index, hour) in
            let angle = hour.rotationAngle  // relative to 12 am of the same
            // day.
            path.move(to: CGPoint(x: boundsCenter.x + (radius * 0.2 * cos(angle)),
                                  y: boundsCenter.y + (radius * 0.2 * sin(angle))))

            if index % 3 == 1 {
                path.addLine(to: CGPoint(x: boundsCenter.x + ((radius - numeralMargin) * cos(angle)),
                                         y: boundsCenter.y + ((radius - numeralMargin) * sin(angle))))

                let textLayer = self.textLayer(forRomanNumeral: RomanNumeral.romanNumeral(for: index + 2)!)
                addSublayer(textLayer)
                textLayer.center(at: CGPoint(x: boundsCenter.x + ((radius - (numeralMargin / 2.2)) * cos(angle)),
                                             y: boundsCenter.y + ((radius - (numeralMargin / 2.2)) * sin(angle))))
                textLayer.setAffineTransform(CGAffineTransform(rotationAngle: angle + (CGFloat.pi / 2.0)))
            } else {
                path.addLine(to: borderPoint(at: angle))
            }
        }

        self.path = path.cgPath
        setNeedsDisplay()
    }

    private func textLayer(forRomanNumeral romanNumeral: RomanNumeral) -> CATextLayer {
        let textLayer = CATextLayer()
        textLayer.string = romanNumeral.rawValue
        textLayer.foregroundColor = strokeColor
        textLayer.fontSize = 12.0
        textLayer.frame = CGRect(x: 0.0, y: 0.0, width: 18.0, height: 16.0)
        textLayer.alignmentMode = .center

        return textLayer
    }

}
