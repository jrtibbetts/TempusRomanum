//  Copyright © 2019 Poikile Creations. All rights reserved.

import SwiftUI

struct Clock : View {
    
    @EnvironmentObject var tempus: Tempus
    
    var body: some View {
        ZStack {
            ClockFace()
            ClockBorder()
            HourLines(color: Color(UIColor(named: "Nighttime")!), hours: tempus.sunriseSunset?.nighttimeHours, thickness: 2.0)
            HourLines(color: Color(UIColor(named: "Daylight")!), hours: tempus.sunriseSunset?.daylightHours, thickness: 2.0)
            ClockHands()
        }
        .padding(Edge.Set([.leading, .top, .trailing]), 20.0)
    }
    
}

struct Clock_Previews : PreviewProvider {
    
    static var previews: some View {
        Clock()
            .environmentObject(ClockSettings())
            .environmentObject(Tempus.debugInstance)
            .background(Color.green)
    }

}

import UIKit

class ClockHostingController: UIHostingController<ClockContainer> {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder, rootView: ClockContainer())
    }

}

struct ClockContainer: View {

    var body: some View {
        return Clock()
            .environmentObject(ClockSettings())
            .environmentObject(Tempus.debugInstance)
    }

}
