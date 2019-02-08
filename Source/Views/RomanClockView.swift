//  Copyright © 2018 Poikile Creations. All rights reserved.

import UIKit

/// A 24-hour analog clock that displays daylight and nighttime hours with
/// Roman-style durations, such that each daylight hour is exactly 1/12th of
/// the time between sunrise and sunset, and each nighttime hour is exactly
/// 1/12th of the time between sunset and sunrise the next day.
public final class RomanClockView: UIView {

    // MARK: - Public Properties

    public var sunriseSunset: SunriseSunset? {
        didSet {
            romanClockLayer.sunriseSunset = sunriseSunset

            if sunriseSunset != nil {
                update()
            }
        }
    }

    // MARK: - Private Properties

    private var elapsedTimeTimer = Timer(timeInterval: 60.0,
                                         target: self,
                                         selector: #selector(update),
                                         userInfo: nil,
                                         repeats: true)

    var romanClockLayer: RomanClockLayer!

    // MARK: - UIView

    public override func awakeFromNib() {
        super.awakeFromNib()
        romanClockLayer = RomanClockLayer()
        layer.addSublayer(romanClockLayer)
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        let backgroundSideLength = min(frame.width, frame.height)
        let backgroundSize = CGSize(width: backgroundSideLength,
                                    height: backgroundSideLength)
        let backgroundFrame = CGRect(origin: CGPoint(), size: backgroundSize)
        romanClockLayer.frame = backgroundFrame
        romanClockLayer.centerInSuperlayer()
    }

    // MARK: - Other Functions

    @IBAction public func update() {
        romanClockLayer.elapsedTimeLayer.update()
    }

}
