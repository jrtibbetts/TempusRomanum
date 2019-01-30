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

    public var nighttimeHours: [Date] = [] {
        didSet {
            setNeedsLayout()
        }
    }

    public var textColor: CGColor? = UIColor(named: "Text")?.cgColor {
        didSet {
            labelLayers.forEach { $0.foregroundColor = textColor }
            setNeedsDisplay()
        }
    }

    // MARK: - Private Properties

    private var labelLayers = [CATextLayer]()

    private var labelSize: CGSize {
        return CGSize(width: fontSize * 2.5, height: fontSize * 1.2)
    }

    // MARK: - CALayer

    public override func layoutSublayers() {
        super.layoutSublayers()

        labelLayers.forEach { (sublayer) in
            sublayer.removeFromSuperlayer()
        }

        daylightHours.enumerated().forEach { (index, date) in
            let layer = createLayer(forNumber: index, time: daylightHours[index])
            labelLayers.append(layer)
        }

        nighttimeHours.enumerated().forEach { (index, date) in
            let layer = createLayer(forNumber: index, time: nighttimeHours[index])
            labelLayers.append(layer)
        }

        labelLayers.forEach { (sublayer) in
            addSublayer(sublayer)
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
