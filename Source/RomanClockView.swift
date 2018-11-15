//  Copyright © 2018 Poikile Creations. All rights reserved.

import UIKit

public final class RomanClockView: UIView {

    // MARK: - Inspectable Properties

    @IBInspectable public var clockBackgroundColor: UIColor? {
        didSet {
            clockFace.fillColor = (clockBackgroundColor ?? UIColor.white).cgColor
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
            clockFace.strokeColor = (borderColor ?? UIColor.black).cgColor
            setNeedsDisplay()
        }
    }

    @IBInspectable public var borderThickness: NSDecimalNumber? {
        didSet {
            clockFace.lineWidth = CGFloat(borderThickness?.floatValue ?? 3.0)
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
        layer.addSublayer(clockFace)
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

    fileprivate lazy var clockFace: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.frame = self.bounds

        // We want a circle, so determine the largest circle that will fit in
        // the bounds, minus a margin for the numerals.
        let frameHeight = self.bounds.height
        let frameWidth = self.bounds.width
        let minDimension = (minimumDimension * 0.9)
        let circleSize = CGSize(width: minDimension, height: minDimension)
        let circleOrigin = CGPoint(x: (frameWidth / 2.0 - minDimension / 2.0),
                                   y: (frameHeight / 2.0 - minDimension / 2.0))
        layer.path = CGPath(ellipseIn: CGRect(origin: circleOrigin, size: circleSize), transform: nil)

        if let solarData = sunriseSunset {
            (1...24).forEach { (i) in
                if i % 6 == 0 {
                    let textLayer = CATextLayer()
                    textLayer.frame = CGRect(origin: circleOrigin, size: circleSize.applying(CGAffineTransform(translationX: 30.0, y: 30.0)))
                    textLayer.setAffineTransform(CGAffineTransform(rotationAngle: (CGFloat(i) / 12.0) * CGFloat.pi + (CGFloat.pi / 4)))
                    textLayer.string = "\(i)"
                    textLayer.fontSize = 16.0
                    textLayer.foregroundColor = UIColor.black.cgColor
                    textLayer.backgroundColor = UIColor.clear.cgColor
                    layer.addSublayer(textLayer)
                }
            }
        }

        return layer
    }()

    fileprivate var minimumDimension: CGFloat {
        return min(self.bounds.height, self.bounds.width)
    }

}
