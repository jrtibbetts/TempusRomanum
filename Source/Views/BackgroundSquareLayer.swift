//  Copyright © 2018 Poikile Creations. All rights reserved.

import UIKit

/// The background layer of the clock view.
final class BackgroundSquareLayer: CALayer {
    
    // MARK: - Private Properties
    
    fileprivate var daylightLayer = DaylightLayer()
    
    fileprivate var modernHourMarksInset: CGFloat = 30.0 {
        didSet {
            layoutSublayers()
        }
    }

    fileprivate var modernHourMarksLayer: ModernHourMarksLayer?
    
    fileprivate var nighttimeClockFace: CAShapeLayer

    fileprivate var nighttimeLinesLayer: HourLinesLayer?

    fileprivate var romanHourMarks = CALayer()

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
            
            nighttimeLinesLayer?.removeFromSuperlayer()
            nighttimeLinesLayer?.lineWidth = 1.0
            nighttimeLinesLayer?.strokeColor = UIColor.white.cgColor
            nighttimeLinesLayer = HourLinesLayer(hours: sunriseSunset.nighttimeHourTimes)
            nighttimeClockFace.addSublayer(nighttimeLinesLayer!)
            
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

    // MARK: - Initialization
    
    override init() {
        nighttimeClockFace = CAShapeLayer()
        nighttimeClockFace.fillColor = UIColor.blue.cgColor
        
        daylightLayer = DaylightLayer()
        
        super.init()
        
        modernHourMarksLayer = ModernHourMarksLayer(radius: minimumDimension, margin: modernHourMarksInset)
        addSublayer(modernHourMarksLayer!)
        modernHourMarksLayer?.centerInSuperlayer()
        addSublayer(nighttimeClockFace)
        addSublayer(daylightLayer)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - CALayer
    
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
    
}
