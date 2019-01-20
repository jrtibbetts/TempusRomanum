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
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        
        let backgroundSideLength = min(frame.width, frame.height)
        let backgroundSize = CGSize(width: backgroundSideLength,
                                    height: backgroundSideLength)
        let backgroundFrame = CGRect(origin: CGPoint(), size: backgroundSize)
        backgroundLayer.frame = backgroundFrame
        layer.addSublayer(backgroundLayer)
        backgroundLayer.centerInSuperlayer()
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

fileprivate extension CGRect {

    var center: CGPoint {
        return CGPoint(x: width / 2.0, y: height / 2.0)
    }

}
