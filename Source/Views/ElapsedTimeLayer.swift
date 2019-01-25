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
    }

    // MARK: - Functions

    func update(date: Date = Date()) {
        let endAngle = date.rotationAngle

        path = UIBezierPath(sliceCenter: boundsCenter,  // from ClockLayer
                            radius: radius,             // from ClockLayer
                            startAngle: previousEndAngle,
                            endAngle: endAngle).cgPath

        setNeedsDisplay()
    }

}
