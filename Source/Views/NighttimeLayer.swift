//  Copyright © 2019 Poikile Creations. All rights reserved.

import Stylobate
import UIKit

class NighttimeClockLayer: ClockSubfaceLayer {

    override var sunriseSunset: SunriseSunset? {
        didSet {
            if let hours = sunriseSunset?.nighttimeHourTimes {
                hourLinesLayer.hours = hours
                setNeedsLayout()
            }
        }
    }

    override init() {
        super.init()
        fillColor = UIColor(named: "Nighttime")?.cgColor
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(layer: Any) {
        super.init(layer: layer)
    }

    // MARK: - Other Functions

    override func updatePath() {
        guard let sunriseSunset = sunriseSunset else { return }

        path = UIBezierPath(sliceCenter: boundsCenter,
                            radius: radius,
                            startAngle: sunriseSunset.sunset.rotationAngle,
                            endAngle: sunriseSunset.sunrise.rotationAngle).cgPath
        setNeedsDisplay()
    }

}

class ClockSubfaceLayer: ClockLayer {
    
    // MARK: - Public Properties

    /// The layer that draws lines for each hour in this subface.
    var hourLinesLayer = HourLinesLayer()

    /// The astronomical information.
    var sunriseSunset: SunriseSunset?

    // MARK: - Initialization
    
    override init() {
        super.init()

        hourLinesLayer.strokeColor = UIColor(named: "Hour Marks")?.cgColor
        hourLinesLayer.lineWidth = 1.0
        addSublayer(hourLinesLayer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(layer: Any) {
        super.init(layer: layer)    // This prevents crashes when rotating.
    }

    convenience init(sunriseSunset: SunriseSunset) {
        self.init()
        self.sunriseSunset = sunriseSunset
    }
    
    // MARK: - CALayer
    
    override func layoutSublayers() {
        super.layoutSublayers()

        hourLinesLayer.frame = bounds
        hourLinesLayer.layoutSublayers()

        updatePath()
    }

    // MARK: - Other Functions

    func updatePath() {
    }

}
