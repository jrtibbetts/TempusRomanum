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

    fileprivate var backgroundLayer: RomanClockLayer!
    
    public var sunriseSunset: SunriseSunset? {
        didSet {
            backgroundLayer.sunriseSunset = sunriseSunset
        }
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        backgroundLayer = RomanClockLayer()
        layer.addSublayer(backgroundLayer)
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        
        let backgroundSideLength = min(frame.width, frame.height)
        let backgroundSize = CGSize(width: backgroundSideLength,
                                    height: backgroundSideLength)
        let backgroundFrame = CGRect(origin: CGPoint(), size: backgroundSize)
        backgroundLayer.frame = backgroundFrame
        backgroundLayer.centerInSuperlayer()
    }

}
