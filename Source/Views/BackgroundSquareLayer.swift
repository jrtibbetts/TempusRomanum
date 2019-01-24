//  Copyright © 2018 Poikile Creations. All rights reserved.

import Stylobate
import UIKit

/// The background layer of the clock view.
final class BackgroundSquareLayer: CALayer {
    
    // MARK: - Private Properties

    /// The layer that draws the daylight portion of the clock circle.
    private var daylightLayer = DaylightLayer()

    private var elapsedTimeLayer = CAShapeLayer()

    /// The number of points to inset the `modernHourMarksLayer`.
    private var modernHourMarksInset: CGFloat = 25.0 {
        didSet {
            layoutSublayers()
        }
    }

    /// The layer that draws the modern-style hour mark lines.
    private var modernHourMarksLayer: ModernHourMarksLayer?

    /// The layer that draws the nighttime portion of the clock table.
    private var nighttimeClockFace = CAShapeLayer()


    private var nighttimeLinesLayer: HourLinesLayer?

    private var romanHourMarksLayer: RomanHourMarksLayer?

    private var romanHourMarksInset: CGFloat = 15.0 {
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

            nighttimeLinesLayer?.removeFromSuperlayer()
            nighttimeLinesLayer = HourLinesLayer(hours: sunriseSunset.nighttimeHourTimes) <~ {
                $0.lineWidth = 1.0
                $0.strokeColor = UIColor(named: "Hour Marks")?.cgColor
                $0.frame = nighttimeClockFace.bounds
                nighttimeClockFace.addSublayer($0)
                $0.centerInSuperlayer()
            }

            romanHourMarksLayer?.daylightHours = sunriseSunset.daylightHourTimes
            romanHourMarksLayer?.nighttimeHours = sunriseSunset.nighttimeHourTimes

            setNeedsLayout()
        }
    }
    
    private var clockFaceFrame: CGRect {
        // We want a circle, so determine the largest circle that will fit in
        // the bounds, minus a margin for the numerals.
        let frameHeight = self.bounds.height
        let frameWidth = self.bounds.width
        let faceOrigin = CGPoint(x: (frameWidth - minimumDimension) / 2.0, y: (frameHeight - minimumDimension) / 2.0)
        let faceSize = CGSize(width: minimumDimension, height: minimumDimension)
        
        return CGRect(origin: faceOrigin, size: faceSize)
    }

    private var minimumDimension: CGFloat {
        return min(self.bounds.height, self.bounds.width)
    }

    // MARK: - Initialization
    
    override init() {
        nighttimeClockFace.allowsEdgeAntialiasing = false
        nighttimeClockFace.fillColor = UIColor(named: "Nighttime")?.cgColor

        super.init()

        addSublayer(nighttimeClockFace)
        addSublayer(daylightLayer)

        modernHourMarksLayer = ModernHourMarksLayer(radius: minimumDimension, margin: modernHourMarksInset)
        addSublayer(modernHourMarksLayer!)
        romanHourMarksLayer = RomanHourMarksLayer()
        addSublayer(romanHourMarksLayer!)

        elapsedTimeLayer.fillColor = UIColor(named: "Elapsed Time")?.cgColor
        addSublayer(elapsedTimeLayer)
        elapsedTimeLayer.frame = clockFaceFrame
        elapsedTimeLayer.centerInSuperlayer()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(layer: Any) {
        super.init(layer: layer)
    }

    // MARK: - CALayer
    
    override func layoutSublayers() {
        super.layoutSublayers()

        modernHourMarksLayer?.frame = self.bounds
        modernHourMarksLayer?.centerInSuperlayer()

        // Calculate the size of the clock layer
        let marksInsets = modernHourMarksInset + romanHourMarksInset
        let sublayerSideLength = min(frame.size.width - marksInsets * 2, frame.size.width - marksInsets * 2)
        let clockFaceFrame = CGRect(x: 0.0, y: 0.0, width: sublayerSideLength, height: sublayerSideLength)
        nighttimeClockFace.frame = clockFaceFrame
        nighttimeClockFace.centerInSuperlayer()
        nighttimeClockFace.path = UIBezierPath(ovalIn: nighttimeClockFace.bounds).cgPath
        daylightLayer.frame = clockFaceFrame
        daylightLayer.centerInSuperlayer()

        let romanHourMarksFrame = CGRect(x: frame.origin.x + modernHourMarksInset,
                                         y: frame.origin.y + modernHourMarksInset,
                                         width: frame.width - (modernHourMarksInset * 2.0),
                                         height: frame.height - (modernHourMarksInset * 2.0))
        romanHourMarksLayer?.frame = romanHourMarksFrame

        daylightLayer.borderColor = UIColor(named: "Text")?.cgColor
        daylightLayer.borderWidth = 2.0
        daylightLayer.cornerRadius = sublayerSideLength / 2.0

        // Update the elapsed time.
        let elapsedTimePath = UIBezierPath(sliceCenter: frame.center,
                                           radius: clockFaceFrame.width / 2.0,
                                           startAngle: 0.5 * CGFloat.pi,
                                           endAngle: Date().rotationAngle)
        elapsedTimeLayer.path = elapsedTimePath.cgPath
    }
    
}
