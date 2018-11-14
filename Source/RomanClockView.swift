//  Copyright © 2018 Poikile Creations. All rights reserved.

import UIKit

public final class RomanClockView: UIView {

    // MARK: - Inspectable Properties

    @IBInspectable public var clockBackgroundColor: UIColor? {
        didSet {
            borderLayer.fillColor = (clockBackgroundColor ?? UIColor.white).cgColor
            setNeedsDisplay()
        }
    }

    @IBInspectable public var clockForegroundColor: UIColor? {
        didSet {
            setNeedsDisplay()
        }
    }

    @IBInspectable public var borderColor: UIColor? {
        didSet {
            borderLayer.strokeColor = (borderColor ?? UIColor.black).cgColor
            setNeedsDisplay()
        }
    }

    @IBInspectable public var borderThickness: NSDecimalNumber? {
        didSet {
            borderLayer.lineWidth = CGFloat(borderThickness?.floatValue ?? 3.0)
            setNeedsDisplay()
        }
    }

    // MARK: - Initializers

    public override init(frame: CGRect) {
        super.init(frame: frame)
//        layer.addSublayer(borderLayer)
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        layer.addSublayer(borderLayer)
    }

    // MARK: - UIView

    public override func awakeFromNib() {
        super.awakeFromNib()
        layer.addSublayer(borderLayer)
        layer.addSublayer(hourMarkersLayer)
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    public var sunriseSunset: SunriseSunset? {
        didSet {
            setNeedsDisplay()
        }
    }

    fileprivate lazy var borderLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.frame = self.bounds

        // We want a circle, so determine the largest circle that will fit in
        // the bounds.
        let frameHeight = self.bounds.height
        let frameWidth = self.bounds.width
        let minDimension = min(self.bounds.height, self.bounds.width)
        let circleSize = CGSize(width: minDimension, height: minDimension)
        let circleOrigin = CGPoint(x: (frameWidth / 2.0 - minDimension / 2.0),
                                   y: (frameHeight / 2.0 - minDimension / 2.0))
        layer.path = CGPath(ellipseIn: CGRect(origin: circleOrigin, size: circleSize), transform: nil)

        [1..<24].forEach { (i) in

        }

        return layer
    }()

    fileprivate lazy var hourMarkersLayer: CAReplicatorLayer = {
        let layer = CAReplicatorLayer()
        layer.instanceCount = 24

        let transform = CATransform3DMakeRotation(CGFloat(2 * Float.pi / 24.0), 3.0, 40, 0.0)
        return layer
    }()

}
