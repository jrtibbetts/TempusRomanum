//  Copyright © 2019 Poikile Creations. All rights reserved.

import Stylobate
import UIKit

class NighttimeLayer: ClockSubfaceLayer {

    override var sunriseSunset: SunriseSunset? {
        didSet {
            if let hours = sunriseSunset?.nighttimeHours {
                hourLinesLayer.hours = hours
                setNeedsLayout()
            }
        }
    }

    // MARK: - Private Properties

    private var gradientLayers = [CALayer]()

    // MARK: - CALayer

    override func layoutSublayers() {
        super.layoutSublayers()

        gradientLayers.forEach { (layer) in
            layer.removeFromSuperlayer()
        }

        if let solarAndLunarTimes = sunriseSunset as? SolarAndLunarTimes {
            addSolarAndLunarLayers(for: solarAndLunarTimes)
        }
    }

    // MARK: - Other Functions

    override func updatePath() {
        fillColor = UIColor(named: "Nighttime")!.cgColor

        // Use the astronomical times, if any, to calculate the angles;
        // otherwise, use the regular sunrise and sunset.
        let startAngle: CGFloat
        let endAngle: CGFloat

        if let extendedTimes = sunriseSunset as? SolarAndLunarTimes {
            startAngle = extendedTimes.astronomicalDusk.rotationAngle
            endAngle = extendedTimes.astronomicalDawn.rotationAngle
            updatePath(from: startAngle, to: endAngle)
        } else if let sunriseSunset = sunriseSunset {
            startAngle = sunriseSunset.sunset.rotationAngle
            endAngle = sunriseSunset.sunrise.rotationAngle
            updatePath(from: startAngle, to: endAngle)
        }

    }

    func addGradientLayer(fromStartDate startDate: Date,
                          toEndDate endDate: Date,
                          color: CGColor) {
        let layer = CAShapeLayer()
        layer.fillColor = color
        layer.path = UIBezierPath(sliceCenter: boundsCenter,
                                  radius: radius,
                                  startAngle: startDate.rotationAngle,
                                  endAngle: endDate.rotationAngle).cgPath

        addSublayer(layer)
    }

    private func addSolarAndLunarLayers(for times: SolarAndLunarTimes) {
        let civilColor = UIColor(named: "Civil Dawn and Dusk")!.cgColor
        addGradientLayer(fromStartDate: times.civilDawn, toEndDate: times.sunrise, color: civilColor)
        addGradientLayer(fromStartDate: times.sunset, toEndDate: times.civilDusk, color: civilColor)

        let nauticalColor = UIColor(named: "Nautical Dawn and Dusk")!.cgColor
        addGradientLayer(fromStartDate: times.nauticalDawn, toEndDate: times.civilDawn, color: nauticalColor)
        addGradientLayer(fromStartDate: times.civilDusk, toEndDate: times.nauticalDusk, color: nauticalColor)

        let astroColor = UIColor(named: "Astronomical Dawn and Dusk")!.cgColor
        addGradientLayer(fromStartDate: times.astronomicalDawn, toEndDate: times.nauticalDawn, color: astroColor)
        addGradientLayer(fromStartDate: times.nauticalDusk, toEndDate: times.astronomicalDusk, color: astroColor)
    }

}
