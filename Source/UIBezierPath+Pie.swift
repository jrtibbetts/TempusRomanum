import UIKit

public extension UIBezierPath {

    public convenience init(sliceCenter: CGPoint, radius: CGFloat, startAngle: CGFloat, endAngle: CGFloat, clockwise: Bool) {
        self.init(arcCenter: sliceCenter, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: clockwise)
        addLine(to: sliceCenter)
        close()
    }

}
