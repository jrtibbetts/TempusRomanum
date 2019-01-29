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
            labelLayers.forEach { $0.font = font }
            setNeedsDisplay()
        }
    }

    public var fontSize: CGFloat = 10.0 {
        didSet {
            labelLayers.forEach { $0.fontSize = fontSize }
            setNeedsLayout()
        }
    }

    public var textColor: CGColor? = UIColor(named: "Text")?.cgColor {
        didSet {
            labelLayers.forEach { $0.foregroundColor = textColor }

            setNeedsDisplay()
        }
    }

    public var nighttimeHours: [Date] = [] {
        didSet {
            setNeedsLayout()
        }
    }

    // MARK: - Private Properties

    private var daylightLabelLayers: [CATextLayer] = []

    private var labelLayers: [CATextLayer] {
        return daylightLabelLayers + nighttimeLabelLayers
    }

    private var labelSize: CGSize {
        return CGSize(width: fontSize * 2.5, height: fontSize * 1.2)
    }

    private var nighttimeLabelLayers: [CATextLayer] = []

    // MARK: - CALayer

    public override func layoutSublayers() {
        super.layoutSublayers()

        guard !frame.size.equalTo(CGSize(width: 0.0, height: 0.0)) else {
            return
        }

        labelLayers.forEach { (layer) in
            layer.removeFromSuperlayer()
        }

        daylightHours.enumerated().forEach { (index, date) in
            let date = daylightHours[index]
            let layer = createLayer(forNumber: index, time: date)
            daylightLabelLayers.append(layer)
            addSublayer(layer)
        }

        nighttimeHours.enumerated().forEach { (index, date) in
            let date = nighttimeHours[index]
            let layer = createLayer(forNumber: index, time: date)
            nighttimeLabelLayers.append(layer)
            addSublayer(layer)
        }
    }

    private func createLayer(forNumber number: Int, time: Date) -> CATextLayer {
        let layer = CATextLayer()
        layer.alignmentMode = .center
        layer.fontSize = fontSize
        layer.font = font
        layer.string = RomanNumeral.allCases[number].rawValue
        layer.foregroundColor = textColor
        layer.frame = CGRect(origin: CGPoint(), size: labelSize)
        layer.center(at: borderPoint(at: time.rotationAngle))

        return layer
    }

}
