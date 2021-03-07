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

    open override func layoutSublayers() {
        if frame.isEmpty {
            return
        }

        sublayers?.forEach { $0.removeFromSuperlayer() }

        // Create the path with a line from the layer's center point to the
        // points at which each hour falls on the circle.
        let path = UIBezierPath()
        path.lineWidth = lineWidth * 5
        let numeralMargin: CGFloat = 30.0

        hours.enumerated().forEach { (index, hour) in
            let degrees = CGFloat(hour.hour24RotationAngle.degrees)  // relative to 12 am of the same
            // day.
            path.move(to: CGPoint(x: boundsCenter.x + (radius * 0.2 * cos(degrees)),
                                  y: boundsCenter.y + (radius * 0.2 * sin(degrees))))

            if index > 0 && index % 3 == 2 {
                path.addLine(to: CGPoint(x: boundsCenter.x + ((radius - numeralMargin) * cos(degrees)),
                                         y: boundsCenter.y + ((radius - numeralMargin) * sin(degrees))))

                let textLayer = self.textLayer(forRomanNumeral: RomanNumeral.romanNumeral(for: index + 1)!)
                addSublayer(textLayer)
                textLayer.center(at: CGPoint(x: boundsCenter.x + ((radius - (numeralMargin / 2.4)) * cos(degrees)),
                                             y: boundsCenter.y + ((radius - (numeralMargin / 2.4)) * sin(degrees))))
                textLayer.setAffineTransform(CGAffineTransform(rotationAngle: degrees + (CGFloat.pi / 2.0)))
            } else {
                path.addLine(to: borderPoint(at: degrees))
            }
        }

        self.path = path.cgPath
        setNeedsDisplay()
    }

    private func textLayer(forRomanNumeral romanNumeral: RomanNumeral) -> CATextLayer {
        let textLayer = CATextLayer()
        textLayer.string = romanNumeral.rawValue
        textLayer.foregroundColor = strokeColor
        textLayer.font = UIFont(name: "Palatino", size: 20.0)
        textLayer.fontSize = 20.0
        textLayer.frame = CGRect(x: 0.0, y: 0.0, width: 24.0, height: 24.0)
        textLayer.alignmentMode = .center

        return textLayer
    }

}
