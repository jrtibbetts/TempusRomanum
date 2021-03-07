//  Copyright © 2019 Poikile Creations. All rights reserved.

import SwiftUI

struct ClockFace : View {
    
    @EnvironmentObject private var settings: ClockSettings
    
    @EnvironmentObject private var tempus: Tempus

    var sunriseDegrees: CGFloat {
        guard let sunrise = tempus.sunriseSunset?.sunrise else {
            return 0.25
        }

        return CGFloat(sunrise.hour24RotationAngle.degrees)
    }

    var sunsetDegrees: CGFloat {
        guard let sunset = tempus.sunriseSunset?.sunset else {
            return 0.75
        }

        return CGFloat(sunset.hour24RotationAngle.degrees)
    }

    var body: some View {
        VStack {
            GeometryReader { (proxy) in
                Circle()
                    .trim(from: sunriseDegrees, to: sunsetDegrees)
                    .stroke(style: StrokeStyle(lineWidth: 20.0, lineCap: .round, lineJoin: .round))
                    .fill(LinearGradient(gradient: .init(colors: [self.settings.daylightColor, self.settings.nighttimeColor]),
                                         startPoint: .init(x: 0.5, y: 0.0),
                                         endPoint: .init(x: 0.5, y: 1))
                    )
                    .foregroundColor(.red)
            }
            Text("Sunrise degrees: \(sunriseDegrees)")
            Text("Sunset degrees: \(sunsetDegrees)")
        }
    }
    
}

struct ClockFace_Previews : PreviewProvider {
    static var previews: some View {
        return ClockFace()
            .environmentObject(ClockSettings())
            .environmentObject(Tempus.debugInstance)
            .padding(20)
    }
}
