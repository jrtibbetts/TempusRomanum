//  Copyright © 2019 Poikile Creations. All rights reserved.

import SwiftUI

struct ClockFace : View {
    
    @EnvironmentObject private var settings: ClockSettings
    
    @EnvironmentObject private var tempus: Tempus
    
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                let width: CGFloat = min(geometry.size.width, geometry.size.height)
                let frame = CGRect(x: 0.0, y: 0.0, width: width, height: width)
                path.addEllipse(in: frame)
            }
                .fill(LinearGradient(gradient: .init(colors: [self.settings.daylightColor, self.settings.nighttimeColor]),
                                     startPoint: .init(x: 0.5, y: 0.0),
                                     endPoint: .init(x: 0.5, y: 0.4))
            )
        }
    }

}

struct ClockFace_Previews : PreviewProvider {
    static var previews: some View {
        return ClockFace()
            .environmentObject(ClockSettings())
            .environmentObject(Tempus.debugInstance)
    }
}
