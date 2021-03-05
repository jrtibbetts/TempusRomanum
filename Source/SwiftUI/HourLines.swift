//  Copyright © 2019 Poikile Creations. All rights reserved.

import SwiftUI

struct HourLines : View {
    
    @State var color = Color.white
    
    @State var dates: [Date]? = nil

    @State var thickness = CGFloat(2.0)
    
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                self.dates?.forEach() { date in
                    let width = min(geometry.size.width, geometry.size.height)
                    let center = CGPoint(x: width / 2.0, y: width / 2.0)
                    path.move(to: center)
                    
                    let edgePoint = CGPoint(x: center.x + CGFloat(cos(date.hour24RotationAngle.radians)) * width / 2.0,
                                            y: center.y + CGFloat(sin(date.hour24RotationAngle.radians)) * width / 2.0)
                    path.addLine(to: edgePoint)
                }
            }
                .stroke(self.color, lineWidth: self.thickness)
        }
    }
    
}

struct HourLines_Previews : PreviewProvider {
    static var previews: some View {
        ZStack {
            HourLines(color: .green,
                      dates: Tempus.debugInstance.sunriseSunset?.daylightHours,
                      thickness: 2.0)
            HourLines(color: .red,
                      dates: Tempus.debugInstance.sunriseSunset?.nighttimeHours,
                      thickness: 2.0)
        }
    }
}
