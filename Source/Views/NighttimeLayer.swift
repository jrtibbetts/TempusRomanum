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

        guard let times = sunriseSunset,
            let civilDawn = times.civilDawn?.rotationAngle,
            let civilDusk = times.civilDusk?.rotationAngle,
            let nauticalDawn = times.nauticalDawn?.rotationAngle,
            let nauticalDusk = times.nauticalDusk?.rotationAngle,
            let astronomicalDawn = times.astronomicalDawn?.rotationAngle,
            let astronomicalDusk = times.astronomicalDusk?.rotationAngle else {
                return
        }

        let civilColor = UIColor(named: "Civil Dawn and Dusk")!.cgColor
        let civilDawnLayer = gradientLayer(from: civilDawn, to: times.sunrise.rotationAngle, color: civilColor)
        let civilDuskLayer = gradientLayer(from: times.sunset.rotationAngle, to: civilDusk, color: civilColor)
        gradientLayers.append(contentsOf: [civilDawnLayer, civilDuskLayer])

        let nauticalColor = UIColor(named: "Nautical Dawn and Dusk")!.cgColor
        let nauticalDawnLayer = gradientLayer(from: nauticalDawn, to: civilDawn, color: nauticalColor)
        let nauticalDuskLayer = gradientLayer(from: civilDusk, to: nauticalDusk, color: nauticalColor)
        gradientLayers.append(contentsOf: [nauticalDawnLayer, nauticalDuskLayer])

        let astronomicalColor = UIColor(named: "Astronomical Dawn and Dusk")!.cgColor
        let astronomicalDawnLayer = gradientLayer(from: astronomicalDawn, to: nauticalDawn, color: astronomicalColor)
        let astronomicalDuskLayer = gradientLayer(from: nauticalDusk, to: astronomicalDusk, color: astronomicalColor)
        gradientLayers.append(contentsOf: [astronomicalDawnLayer, astronomicalDuskLayer])

        gradientLayers.forEach { (gradientLayer) in
            addSublayer(gradientLayer)
        }
    }

    // MARK: - Other Functions

    override func updatePath() {
        guard let sunriseSunset = sunriseSunset else { return }
        fillColor = UIColor(named: "Nighttime")!.cgColor

        // Use the astronomical times, if any, to calculate the angles;
        // otherwise, use the regular sunrise and sunset.
        let startAngle = (sunriseSunset.astronomicalDusk ?? sunriseSunset.sunset).rotationAngle
        let endAngle = (sunriseSunset.astronomicalDawn ?? sunriseSunset.sunrise).rotationAngle
        updatePath(from: startAngle, to: endAngle)
    }

    func gradientLayer(from: CGFloat, to: CGFloat, color: CGColor) -> CALayer {
        let layer = CAShapeLayer()
        layer.fillColor = color
        layer.path = UIBezierPath(sliceCenter: boundsCenter, radius: radius, startAngle: from, endAngle: to).cgPath

        return layer
    }

}
