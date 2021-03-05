//  Copyright © 2019 Poikile Creations. All rights reserved.

import Combine
import SwiftUI

final public class ClockSettings: ObservableObject {

    // MARK: - Bound Properties
    
    @Published public var borderColor = Color.black
    
    @Published public var borderWidth = CGFloat(3)
    
    @Published public var daylightColor = Color("Daylight")
    
    @Published public var hourHandColor = Color.red
    
    @Published public var hourHandLengthProportion = CGFloat(0.5)
    
    @Published public var minuteHandColor = Color.orange
    
    @Published public var minuteHandLengthProportion = CGFloat(0.8)

    @Published public var modernMarkLength = CGFloat(10)
    
    @Published public var nighttimeColor = Color("Nighttime")

    @Published public var showModernMarks = true

    // MARK: - ObservableObject Properties
    
    public let didChange = PassthroughSubject<ClockSettings, Never>()

}
