//  Copyright © 2019 Poikile Creations. All rights reserved.

import UIKit

/// The overlay that shades the time that's elapsed today since midnight.
class ElapsedTimeLayer: ClockLayer {

    // MARK: - Properties

    /// The lowest point on the circle.
    let midnightAngle = 0.5 * CGFloat.pi

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
    }

    // MARK: - Functions

    /// Set the semicircular path from midnight until the specified time.
    ///
    /// - parameter date: The end time of the shaded area. By default, this is
    ///                   the exact time when this function was called.
    func update(date: Date = Date()) {
        let endAngle = date.rotationAngle

        path = UIBezierPath(sliceCenter: boundsCenter,  // from ClockLayer
                            radius: radius,             // from ClockLayer
                            startAngle: midnightAngle,
                            endAngle: endAngle).cgPath

        setNeedsDisplay()
    }

}
