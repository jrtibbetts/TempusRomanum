//  Copyright © 2019 Poikile Creations. All rights reserved.

import SwiftUI

struct ClockBorder : View {
    
    @EnvironmentObject private var settings: ClockSettings
    
    @State var numberOfMarks: Int = 24
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                ZStack {
                    // Border
                    Path { path in
                        path.addEllipse(in: self.frame(for: geometry))
                    }
                        .stroke(self.settings.borderColor, lineWidth: self.settings.borderWidth)
                    
                    // Modern hour marks
                    if self.settings.showModernMarks {
                        Path { path in
                            let frame = self.frame(for: geometry)
                            let center = CGPoint(x: frame.size.width / 2.0,
                                                 y: frame.size.height / 2.0)
                            let radius = center.x
                            
                            self.edgePoints(for: geometry).forEach { (angle, edgePoint) in
                                path.move(to: edgePoint)
                                let lineEndPoint = CGPoint(x: center.x + (cos(angle) * (radius - self.settings.modernMarkLength)),
                                                           y: center.y + (sin(angle) * (radius - self.settings.modernMarkLength)))
                                path.addLine(to: lineEndPoint)
                            }
                        }
                            .stroke(self.settings.borderColor, lineWidth: self.settings.borderWidth)
                    }
                }
            }
        }
    }
    
    private func edgePoints(for geometry: GeometryProxy) -> [CGFloat: CGPoint] {
        let frame = self.frame(for: geometry)
        let center = CGPoint(x: frame.size.width / 2.0,
                             y: frame.size.height / 2.0)
        let radius = center.x
        
        return (0..<numberOfMarks).reduce(into: [CGFloat: CGPoint]()) { (result, i) in
            let radians = (CGFloat(i) / CGFloat(numberOfMarks)) * (2.0 * CGFloat.pi)
            let edgePoint = CGPoint(x: center.x + (cos(radians) * radius),
                                    y: center.y + (sin(radians) * radius))
            result[radians] = edgePoint
        }
    }

    private func frame(for geometry: GeometryProxy) -> CGRect {
        let width: CGFloat = min(geometry.size.width, geometry.size.height)
        let frame = CGRect(x: 0.0, y: 0.0, width: width, height: width)
        
        return frame
    }
    
}

struct ClockBorder_Previews : PreviewProvider {
    static var previews: some View {
        ClockBorder()
            .environmentObject(ClockSettings())
    }
}
