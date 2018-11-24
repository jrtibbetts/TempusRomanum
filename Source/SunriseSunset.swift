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

    /// The duration, in minutes, of daylight.
    public var daylightMinutes: TimeInterval {
        return sunset.timeIntervalSince(sunrise) / 60.0
    }

    /// The number of minutes in each daylight hour.
    public var daylightHourDuration: TimeInterval {
        return daylightMinutes / 12.0
    }

    /// An array of `Date`s of the daylight hours.
    public var daylightHourTimes: [Date] {
        return (0..<12).map { sunrise.addingTimeInterval(daylightHourDuration * 60 * Double($0)) }
    }

    /// The duration, in minutes, of nighttime.
    public var nighttimeMinutes: TimeInterval {
        return (24 * 60.0) - daylightMinutes
    }

    /// The number of minutes in each nighttime hour.
    public var nighttimeHourDuration: TimeInterval {
        return nighttimeMinutes / 12.0
    }

    /// An array of `Date`s of the nighttime hours.
    public var nighttimeHourTimes: [Date] {
        return (0..<12).map { sunset.addingTimeInterval(nighttimeHourDuration * 60 * Double($0)) }
    }

}
