//  Copyright © 2018 Poikile Creations. All rights reserved.

import Foundation

/// Encapsulates `Date`s for a day's sunrise and sunset, and has numerous
/// handy properties for calculating things like number of minutes of
/// nighttime.
public struct SunriseSunset {

    /// Sunrise. It's assumed that it's for the same date as the `sunset`; if
    /// not, then that's a problem that this struct doesn't address.
    public let sunrise: Date

    /// Sunset. It's assumed that it's for the same date as the `sunrise`; if
    /// not, then that's a problem that this struct doesn't address.
    public let sunset: Date

    // MARK: - Computed Properties

    public var daylightMinutes: TimeInterval {
        return sunset.timeIntervalSince(sunrise) / 60.0
    }

    public var daylightHourInterval: TimeInterval {
        return daylightMinutes / 12.0
    }

    public var daylightHourTimes: [Date] {
        return (0..<12).map { sunrise.addingTimeInterval(daylightHourInterval * 60 * Double($0)) }
    }

    public var nighttimeMinutes: TimeInterval {
        return (24 * 60.0) - daylightMinutes
    }

    public var nighttimeHourInterval: TimeInterval {
        return nighttimeMinutes / 12.0
    }

    public var nighttimeHourTimes: [Date] {
        return (0..<12).map { sunset.addingTimeInterval(nighttimeHourInterval * 60 * Double($0)) }
    }

}
