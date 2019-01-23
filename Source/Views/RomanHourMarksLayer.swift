//  Copyright © 2019 Poikile Creations. All rights reserved.

import UIKit

public final class RomanHourMarksLayer: ClockLayer {

    // MARK: - Public Properties

    public var daylightHours: [Date] = [] {
        didSet {
            setNeedsLayout()
        }
    }

    public var font: CGFont? {
        didSet {
            if let font = font {
                labelLayers.forEach { (layer) in
                    layer.font = font
                }

                setNeedsDisplay()
            }
        }
    }

    public var fontSize: CGFloat = 10.0 {
        didSet {
            labelLayers.forEach { (layer) in
                layer.fontSize = fontSize
            }

            setNeedsLayout()
        }
    }

    public var textColor: CGColor = UIColor.black.cgColor {
        didSet {
            labelLayers.forEach { (layer) in
                layer.foregroundColor = textColor
            }

            setNeedsDisplay()
        }
    }

    public var nighttimeHours: [Date] = [] {
        didSet {
            nighttimeLabelLayers.forEach { (layer) in
                layer.removeFromSuperlayer()
            }

            nighttimeHours.enumerated().forEach { (i, date) in
                let layer = CATextLayer()
                layer.fontSize = fontSize
                layer.font = font
                layer.string = romanNumerals[i]
                layer.foregroundColor = textColor
                layer.frame = CGRect(origin: CGPoint(), size: labelSize)

                let angle = date.rotationAngle
                let borderPoint = CGPoint(x: center.x + (radius * cos(angle)),
                                          y: center.y + (radius * sin(angle)))
                layer.center(at: borderPoint)
                nighttimeLabelLayers.append(layer)
                addSublayer(layer)
            }

            setNeedsLayout()
        }
    }

    // MARK: - Private Properties

    private var daylightLabelLayers: [CATextLayer] = []

    private var labelLayers: [CATextLayer] {
        return daylightLabelLayers + nighttimeLabelLayers
    }

    private var labelSize: CGSize {
        return CGSize(width: fontSize * 3.0, height: fontSize * 2.0)
    }

    private var nighttimeLabelLayers: [CATextLayer] = []

    private let romanNumerals = [ "I", "II", "III", "IV", "V", "VI",
                                  "VII", "VIII", "IX", "X", "XI", "XII" ]

    // MARK: - CALayer

    public override func layoutSublayers() {
        super.layoutSublayers()
    }

}
