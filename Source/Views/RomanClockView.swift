//  Copyright © 2018 Poikile Creations. All rights reserved.

import UIKit

/// A 24-hour analog clock that displays daylight and nighttime hours with
/// Roman-style durations, such that each daylight hour is exactly 1/12th of
/// the time between sunrise and sunset, and each nighttime hour is exactly
/// 1/12th of the time between sunset and sunrise the next day.
///
/// The view is composed of the following layers, from rearmost to foremost:
///  1. The background clock layer, which is the largest possible square that
///     can be centered in the view;
///  2. The clock face, colored with the nighttime color;
///  3. **The daylight pie slice**;
///  4. **The daylight hour lines**;
///  5. **The nighttime hour lines**;
///  6. The modern hour marks; and
///  7. **The Roman hour marks**.
///
/// Layers marked in **bold** change when the `sunriseSunset` value changes.
public final class RomanClockView: UIView {

    fileprivate var backgroundLayer: BackgroundSquareLayer!
    
    public var sunriseSunset: SunriseSunset? {
        didSet {
            backgroundLayer.sunriseSunset = sunriseSunset
        }
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        backgroundLayer = BackgroundSquareLayer()
        let backgroundSideLength = min(frame.width, frame.height)
        let backgroundSize = CGSize(width: backgroundSideLength,
                                    height: backgroundSideLength)
        let backgroundOrigin = CGPoint(x: (frame.width - backgroundSideLength) / 2,
                                       y: (frame.height - backgroundSideLength) / 2.0)
        let backgroundFrame = CGRect(origin: backgroundOrigin, size: backgroundSize)
        backgroundLayer.frame = backgroundFrame
        layer.addSublayer(backgroundLayer)
    }

}

//fileprivate extension UIEdgeInsets {
//
//    static func + (a: UIEdgeInsets, b: UIEdgeInsets) -> UIEdgeInsets {
//        return UIEdgeInsets(top: a.top + b.top,
//                            left: a.left + b.left,
//                            bottom: a.bottom + b.bottom,
//                            right: a.right + b.right)
//    }
//
//    static func - (a: UIEdgeInsets, b: UIEdgeInsets) -> UIEdgeInsets {
//        return UIEdgeInsets(top: a.top - b.top,
//                            left: a.left - b.left,
//                            bottom: a.bottom - b.bottom,
//                            right: a.right - b.right)
//    }
//
//}

public extension CALayer {

    @discardableResult public func centerInSuperlayer() -> CGRect {
        let size = bounds.size

        guard let superlayerBounds = superlayer?.bounds else {
            return frame
        }

        let origin = CGPoint(x: (superlayerBounds.width - frame.width) / 2.0,
                             y: (superlayerBounds.height - frame.height) / 2.0)

        frame = CGRect(origin: origin, size: size)

        return frame
    }

}

fileprivate final class BackgroundSquareLayer: CALayer {

    override init() {
        nighttimeClockFace = CAShapeLayer()
        nighttimeClockFace.fillColor = UIColor.blue.cgColor

        daylightLayer = DaylightLayer()

        super.init()

        addSublayer(nighttimeClockFace)
        addSublayer(daylightLayer)
    }

    required init?(coder aDecoder: NSCoder) {
        nighttimeClockFace = aDecoder.decodeObject(forKey: "nighttimeClockFace") as! CAShapeLayer

        super.init(coder: aDecoder)

        addSublayer(nighttimeClockFace)
    }

    override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        aCoder.encode(nighttimeClockFace, forKey: "nighttimeClockFace")
    }

    override func layoutSublayers() {
        super.layoutSublayers()

        // Calculate the size of the clock layer
        let marksInsets = modernHourMarksInset + romanHourMarksInset
        let sublayerSideLength = min(frame.size.width - marksInsets, frame.size.width - marksInsets)
        let clockFaceFrame = CGRect(x: 0.0, y: 0.0, width: sublayerSideLength, height: sublayerSideLength)
        nighttimeClockFace.frame = clockFaceFrame
        nighttimeClockFace.centerInSuperlayer()
        nighttimeClockFace.path = UIBezierPath(ovalIn: nighttimeClockFace.bounds).cgPath

        daylightLayer.frame = clockFaceFrame
        daylightLayer.centerInSuperlayer()
    }

    // MARK: - Private Properties

    fileprivate var nighttimeClockFace: CAShapeLayer

    fileprivate var daylightLayer = DaylightLayer()

    fileprivate var nighttimeHourLinesLayer = CAShapeLayer()

    fileprivate var modernHourMarksLabel = CALayer()

    fileprivate var romanHourMarks = CALayer()

    fileprivate var modernHourMarksInset: CGFloat = 30.0 {
        didSet {
            layoutSublayers()
        }
    }

    fileprivate var romanHourMarksInset: CGFloat = 30.0 {
        didSet {
            layoutSublayers()
        }
    }

    public var sunriseSunset: SunriseSunset? {
        didSet {
            guard let sunriseSunset = sunriseSunset else {
                return
            }
            
            daylightLayer.hoursAndEndTime = (sunriseSunset.daylightHourTimes, sunriseSunset.sunset)
//            let radius = minimumDimension / 2.0
//            let layerCenter = CGPoint(x: layer.frame.width / 2.0, y: layer.frame.height / 2.0)
//
//            if let sunriseSunset = sunriseSunset {
//                daylightLayer?.removeFromSuperview()
//                daylightLayer = DaylightLayer()
//                daylightLayer?.hoursAndEndTime = (sunriseSunset.daylightHourTimes, sunriseSunset.sunset)
//                clockFace.addSublayer(daylightLayer!)
//
//                let nighttimePath = UIBezierPath(sliceCenter: layerCenter,
//                                                 radius: radius,
//                                                 startAngle: sunsetAngle,
//                                                 endAngle: sunriseAngle,
//                                                 clockwise: true)
//                let nighttimeLayer = CAShapeLayer()
//                nighttimeLayer.path = nighttimePath.cgPath
//                nighttimeLayer.fillColor = UIColor.blue.cgColor
//                clockFace.addSublayer(nighttimeLayer)
//
//                nighttimeHourLinesLayer?.removeFromSuperlayer()
//                nighttimeHourLinesLayer?.lineWidth = 1.0
//                nighttimeHourLinesLayer?.strokeColor = UIColor.white.cgColor
//                nighttimeHourLinesLayer = HourLinesLayer(rect: bounds, dates: sunriseSunset.nighttimeHourTimes)
//                clockFace.addSublayer(nighttimeHourLinesLayer!)
            setNeedsLayout()
            layoutIfNeeded()
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

fileprivate extension CGRect {

    var center: CGPoint {
        return CGPoint(x: width / 2.0, y: height / 2.0)
    }

}
