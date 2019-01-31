//  Copyright © 2019 Poikile Creations. All rights reserved.

import Foundation

public extension UserDefaults {

    public var use12HourClock: Bool {
        get {
            return bool(forKey: "use12HourClock")
        }

        set {
            set(newValue, forKey: "use12HourClock")
        }
    }

}
