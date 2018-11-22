//  Copyright © 2018 Poikile Creations. All rights reserved.

import UIKit

fileprivate var midnight: Date = Calendar.autoupdatingCurrent.startOfDay(for: Date())

public final class RomanClockView: UIView {

    // MARK: - Private Properties

    fileprivate var labelsLayer: CALayer?

    // MARK: - Initializers

    public override init(frame: CGRect) {
        super.init(frame: frame)
        awakeFromNib()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        layer.addSublayer(borderLayer)
    }

    // MARK: - UIView

    public override func awakeFromNib() {
        super.awakeFromNib()
        layer.addSublayer(clockFace)
        layer.masksToBounds = true
    }

    fileprivate var daylightHourLinesLayer: CAShapeLayer?
    fileprivate var nighttimeHourLinesLayer: CAShapeLayer?

    public var sunriseSunset: SunriseSunset? {
        didSet {
            labelsLayer?.removeFromSuperlayer()
            labelsLayer = CALayer()
            labelsLayer?.frame = layer.bounds
            let radius = minimumDimension / 2.0
            let layerCenter = CGPoint(x: layer.frame.width / 2.0, y: layer.frame.height / 2.0)

            if let sunriseSunset = sunriseSunset {
                let sunriseAngle = sunriseSunset.sunrise.rotationAngle
                let sunsetAngle = sunriseSunset.sunset.rotationAngle
                let daylightPath = UIBezierPath(sliceCenter: layerCenter,
                                                radius: radius,
                                                startAngle: sunriseAngle,
                                                endAngle: sunsetAngle,
                                                clockwise: true)
                let daylightLayer = CAShapeLayer()
                daylightLayer.path = daylightPath.cgPath
                daylightLayer.fillColor = UIColor.yellow.cgColor
                clockFace.addSublayer(daylightLayer)

                let nighttimePath = UIBezierPath(sliceCenter: layerCenter,
                                                 radius: radius,
                                                 startAngle: sunsetAngle,
                                                 endAngle: sunriseAngle,
                                                 clockwise: true)
                let nighttimeLayer = CAShapeLayer()
                nighttimeLayer.path = nighttimePath.cgPath
                nighttimeLayer.fillColor = UIColor.blue.cgColor
                clockFace.addSublayer(nighttimeLayer)

                daylightHourLinesLayer?.removeFromSuperlayer()
                daylightHourLinesLayer = HourLinesLayer(rect: bounds, dates: sunriseSunset.daylightHourTimes)
                daylightHourLinesLayer?.lineWidth = 1.0
                daylightHourLinesLayer?.strokeColor = UIColor.lightGray.cgColor
                clockFace.addSublayer(daylightHourLinesLayer!)

                nighttimeHourLinesLayer?.removeFromSuperlayer()
                nighttimeHourLinesLayer?.lineWidth = 1.0
                nighttimeHourLinesLayer?.strokeColor = UIColor.white.cgColor
                nighttimeHourLinesLayer = HourLinesLayer(rect: bounds, dates: sunriseSunset.nighttimeHourTimes)
                clockFace.addSublayer(nighttimeHourLinesLayer!)
            }

//            layer.addSublayer(labelsLayer!)

            setNeedsDisplay()
        }
    }

    fileprivate var clockFaceFrame: CGRect {
        // We want a circle, so determine the largest circle that will fit in
        // the bounds, minus a margin for the numerals.
        let frameHeight = self.bounds.height
        let frameWidth = self.bounds.width
        let faceOrigin = CGPoint(x: (frameWidth - minimumDimension) / 2.0, y: (frameHeight - minimumDimension) / 2.0)
        let faceSize = CGSize(width: minimumDimension, height: minimumDimension)

        return CGRect(origin: faceOrigin, size: faceSize)
    }

    fileprivate lazy var clockFace: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.frame = clockFaceFrame
        layer.path = CGPath(ellipseIn: layer.frame, transform: nil)
        layer.strokeColor = UIColor.black.cgColor
        layer.lineWidth = 3.0
        layer.fillColor = UIColor.clear.cgColor

        return layer
    }()

    fileprivate var minimumDimension: CGFloat {
        return min(self.bounds.height, self.bounds.width)
    }

}
