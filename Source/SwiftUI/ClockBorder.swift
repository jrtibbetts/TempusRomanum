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
                    let circleFrame = self.frame(for: geometry)

                    Circle()
                        .stroke(self.settings.borderColor, lineWidth: self.settings.borderWidth)
                        .frame(width: circleFrame.width, height: circleFrame.height)

                    Text("Foo")
                    // Modern hour marks
                    let center = circleFrame.center
                    let radius = center.x

                    ForEach(edgePoints(for: geometry), id: \.radians) { (point) in
                         HourMark()
                    }
                }
            }
        }
    }

    struct HourMark: View {

        @EnvironmentObject private var settings: ClockSettings

        var body: some View {
            Path { (path) in
                let markLength = settings.modernMarkLength
                let leftPoint = CGPoint(x: markLength - (markLength / 2.0), y: 0)
                let rightPoint = CGPoint(x: markLength + (markLength / 2.0), y: 0)
                let pointPoint = CGPoint(x: markLength, y: markLength)
                path.move(to: leftPoint)
                path.addLines([rightPoint, pointPoint, leftPoint])
            }
        }

    }

    struct EdgePoint {
        var radians: CGFloat
        var point: CGPoint
    }

    private func edgePoints(for geometry: GeometryProxy) -> [EdgePoint] {
        let frame = self.frame(for: geometry)
        let center = CGPoint(x: frame.size.width / 2.0,
                             y: frame.size.height / 2.0)
        let radius = center.x
        
        return (0..<numberOfMarks)
            .reduce(into: [EdgePoint]()) { (result, i) in
                let radians = (CGFloat(i) / CGFloat(numberOfMarks)) * (2.0 * CGFloat.pi)
                let point = CGPoint(x: center.x + (cos(radians) * radius),
                                        y: center.y + (sin(radians) * radius))
                result.append(EdgePoint(radians: radians, point: point))
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
            .padding(20)
    }
}
