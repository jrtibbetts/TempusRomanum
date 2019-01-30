//  Copyright © 2018 Poikile Creations. All rights reserved.

import Foundation

public protocol SunriseSunset {

    /// Sunrise. It's assumed that it's for the same day as the `sunset`; if
    /// not, then that's a problem that this struct doesn't address.
    var sunrise: Date { get }

    /// Sunset. It's assumed that it's for the same day as the `sunrise`; if
    /// not, then that's a problem that this struct doesn't address.
    var sunset: Date { get }

}

public protocol SolarAndLunarTimes: SunriseSunset {

    /// The last instance when the sky shows no sunlight whatsoever. The sun
    /// sun is 18° below the horizon.
    var astronomicalDawn: Date { get }

    /// The first instance when the sky shows no sunlight whatsoever. The sun
    /// sun is 18° below the horizon.
    var astronomicalDusk: Date { get }

    /// The first instance when the rising sun hits 6° below the horizon.
    var civilDawn: Date { get }

    /// The first instance when the setting sun hits 6° below the horizon.
    var civilDusk: Date { get }

    /// The first instance when the rising sun hits 12° below the horizon.
    var nauticalDawn: Date { get }

    /// The first instance when the setting sun hits 12° below the horizon.
    var nauticalDusk: Date { get }

}

/// Encapsulates `Date`s for a day's sunrise and sunset, and has numerous
/// handy properties for calculating things like number of minutes of
/// nighttime.
public extension SunriseSunset {

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
    public var daylightHours: [Date] {
        return hours(for: sunrise, hourDuration: daylightHourDuration)
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
    public var nighttimeHours: [Date] {
        return hours(for: sunset, hourDuration: nighttimeHourDuration)
    }

    private func hours(for startDate: Date, hourDuration: TimeInterval) -> [Date] {
        return (0..<12).map { startDate.addingTimeInterval(hourDuration * 60 * Double($0)) }
    }

}
