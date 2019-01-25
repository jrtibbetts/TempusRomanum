//  Copyright © 2019 Poikile Creations. All rights reserved.

import UIKit

class ElapsedTimeLayer: ClockLayer {

    // MARK: - Properties

    static let midnightAngle = 0.5 * CGFloat.pi

    private(set) var previousEndAngle = ElapsedTimeLayer.midnightAngle

    // MARK: - Initializers

    override init() {
        super.init()
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    override init(layer: Any) {
        super.init(layer: layer)
        commonInit()
    }

    private func commonInit() {
        fillColor = UIColor(named: "Elapsed Time")?.cgColor
        reset()
    }

    // MARK: - Functions

    func reset() {
        previousEndAngle = type(of: self).midnightAngle
    }

    func update(date: Date = Date()) {
        let endAngle = date.rotationAngle

        if shouldUpdate(endAngle) {
            resetIfCrossedMidnight(endAngle)

            path = UIBezierPath(sliceCenter: boundsCenter,  // from ClockLayer
                                radius: radius,             // from ClockLayer
                                startAngle: previousEndAngle,
                                endAngle: endAngle).cgPath
            previousEndAngle = endAngle

            setNeedsDisplay()
        }
    }

    // MARK: - Private Functions

    private func resetIfCrossedMidnight(_ endAngle: CGFloat) {
        let midnight = type(of: self).midnightAngle

        if previousEndAngle < midnight && midnight < endAngle {
            reset()
        }
    }

    private func shouldUpdate(_ endAngle: CGFloat) -> Bool {
        let oneMinuteAngle = CGFloat(1.0 / 360.0 * (CGFloat.pi * 2.0))
        return (endAngle - previousEndAngle) > oneMinuteAngle
    }

}
