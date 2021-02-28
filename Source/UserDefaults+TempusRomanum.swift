//  Copyright © 2019 Poikile Creations. All rights reserved.

import Foundation

public extension UserDefaults {

    var use24HourClock: Bool {
        get {
            return bool(forKey: "use24HourClock")
        }

        set {
            set(newValue, forKey: "use24HourClock")
        }
    }

}
