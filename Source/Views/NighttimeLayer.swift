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

    func gradientLayer(from startDate: Date, to endDate: Date, color: CGColor) -> CALayer {
        return gradientLayer(from: startDate.rotationAngle, to: endDate.rotationAngle, color: color)
    }

    func gradientLayer(from: CGFloat, to: CGFloat, color: CGColor) -> CALayer {
        let layer = CAShapeLayer()
        layer.fillColor = color
        layer.path = UIBezierPath(sliceCenter: boundsCenter, radius: radius, startAngle: from, endAngle: to).cgPath

        return layer
    }

    private func addDawnAndDuskLayers(dawnStart: Date, dawnEnd: Date,
                                      duskStart: Date, duskEnd: Date,
                                      color: CGColor) {
        addSublayer(gradientLayer(from: dawnStart, to: dawnEnd, color: color))
        addSublayer(gradientLayer(from: duskStart, to: duskEnd, color: color))
    }

    private func addSolarAndLunarLayers(for times: SolarAndLunarTimes) {
        let civilColor = UIColor(named: "Civil Dawn and Dusk")!.cgColor
        addDawnAndDuskLayers(dawnStart: times.civilDawn,
                             dawnEnd: times.sunrise,
                             duskStart: times.sunset,
                             duskEnd: times.civilDusk,
                             color: civilColor)

        let nauticalColor = UIColor(named: "Nautical Dawn and Dusk")!.cgColor
        addDawnAndDuskLayers(dawnStart: times.nauticalDawn,
                             dawnEnd: times.civilDawn,
                             duskStart: times.civilDusk,
                             duskEnd: times.nauticalDusk,
                             color: nauticalColor)

        let astronomicalColor = UIColor(named: "Astronomical Dawn and Dusk")!.cgColor
        addDawnAndDuskLayers(dawnStart: times.astronomicalDawn,
                             dawnEnd: times.nauticalDawn,
                             duskStart: times.nauticalDusk,
                             duskEnd: times.astronomicalDusk,
                             color: astronomicalColor)
    }

}
