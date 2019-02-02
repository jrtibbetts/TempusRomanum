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
    private var daylightMinutes: TimeInterval {
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
    private var nighttimeMinutes: TimeInterval {
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

    /// Get the Roman time equivalent for a particular date and time.
    ///
    /// - parameter time: The modern time to look up.
    ///
    /// - returns: A `RomanNumeral` constant, plus `true` if it's a daylight
    ///            hour.
    public func romanHour(forDate time: Date = Date()) -> RomanTime? {
        let hourIndex: Int
        let isDaylightHour: Bool
        let isHalfPast: Bool

        if let index = daylightHours.index(ofTime: time) {
            hourIndex = index
            isDaylightHour = true
            isHalfPast = time > daylightHours[hourIndex] + (daylightHourDuration * 60.0 / 2.0)
        } else if let index = nighttimeHours.index(ofTime: time) {
            hourIndex = index
            isDaylightHour = false
            isHalfPast = time > nighttimeHours[hourIndex] + (nighttimeHourDuration * 60.0 / 2.0)
        } else {
            return nil
        }

        return RomanTime(RomanNumeral.romanNumeral(for: hourIndex + 1)!,
                         isDaylightHour: isDaylightHour,
                         isHalfPast: isHalfPast)
    }

}

fileprivate extension Array where Element == Date {

    func index(ofTime time: Date = Date()) -> Int? {
        if let (foundIndex, _) = self.dropLast().enumerated().first(where: { (index, date) in
            return date.rotationAngle <= time.rotationAngle && time.rotationAngle < self[index + 1].rotationAngle
        }) {
            return foundIndex
        } else {
            return nil
        }
    }

}

public struct RomanTime {

    public var romanNumeral: RomanNumeral
    public var isDaylightHour: Bool
    public var isHalfPast: Bool

    public init(_ romanNumeral: RomanNumeral,
                isDaylightHour: Bool = true,
                isHalfPast: Bool = false) {
        self.romanNumeral = romanNumeral
        self.isDaylightHour = isDaylightHour
        self.isHalfPast = isHalfPast
    }

    /// Get the time, expressed as the ordinal hour value and, if half-past the
    /// hour or later, the phrase `et dimidia`. The Romans did not have the
    /// same notion of minutes that we do today.
    public var string: String {
        let hourString = romanNumeral.ordinal
        let dayHalf = isDaylightHour ? "diei" : "noctis"
        var string = "\(hourString) hora \(dayHalf)"

        if isHalfPast {
            string.append(" et dimidia")
        }

        return string
    }

}
