//  Copyright © 2019 Poikile Creations. All rights reserved.

import Stylobate
import UIKit

class NighttimeClockLayer: ClockLayer {
    
    // MARK: - Public Properties
    
    var sunriseSunset: SunriseSunset? {
        didSet {
            if let nighttimeHours = sunriseSunset?.nighttimeHourTimes {
                hourLinesLayer.hours = nighttimeHours
                setNeedsLayout()
            }
        }
    }

    // MARK: - Private Properties
    
    private var hourLinesLayer = HourLinesLayer()

    // MARK: - Initialization
    
    override init() {
        super.init()
        
        fillColor = UIColor(named: "Nighttime")?.cgColor

        hourLinesLayer.strokeColor = UIColor(named: "Hour Marks")?.cgColor
        hourLinesLayer.lineWidth = 1.0
        addSublayer(hourLinesLayer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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

        path = UIBezierPath(ovalIn: bounds).cgPath
        setNeedsDisplay()
    }

}
