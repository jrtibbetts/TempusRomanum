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
    
    /// The duration, in seconds, of daylight.
    private var secondsOfDaylight: TimeInterval {
        return sunset.timeIntervalSince(sunrise)
    }
    
    /// The number of minutes in each daylight hour.
    private var daylightHourDurationInSeconds: TimeInterval {
        return secondsOfDaylight / 12.0
    }
    
    /// An array of `Date`s of the daylight hours.
    var daylightHours: [Date] {
        return (0..<12).map { sunrise.addingTimeInterval(daylightHourDurationInSeconds * Double($0)) }
    }
    
    /// The duration, in seconds, of nighttime.
    private var secondsOfNighttime: TimeInterval {
        return (24.0 * 60.0 * 60.0) - secondsOfDaylight
    }
    
    /// The number of minutes in each nighttime hour.
    private var nighttimeHourDurationInSeconds: TimeInterval {
        return secondsOfNighttime / 12.0
    }
    
    /// An array of `Date`s of the nighttime hours. Calculating these isn't
    /// as trivial as calculating the daytime hours, because advancing from
    /// sun*set* to sun*rise* crosses a date boundary at midnight. Therefore,
    /// this array will consist of the nightime hours from midnight till
    /// sunrise, then from sunset to midnight the next day, e.g.
    ///
    ///   1.  6 a.m.
    ///   2.  7 a.m.
    ///   3.  8 a.m.
    ///   4.  9 a.m.
    ///   5. 10 a.m.
    ///   6. 11 a.m.
    ///   7.  6 p.m.
    ///   8.  7 p.m.
    ///   9.  8 p.m.
    ///  10.  9 p.m.
    ///  11. 10 p.m.
    ///  12. 11 p.m.
    ///
    /// The sunrise hours, obviously, occupy that gap between nighttime hours
    /// 6 & 7 (starting at index 1, not 0).
    var nighttimeHours: [Date] {
        var amHours = [Date]()
        var targetHour = sunrise
        let midnight = Calendar.current.startOfDay(for: sunrise)
        
        while targetHour > midnight {
            let hour = targetHour.addingTimeInterval(-nighttimeHourDurationInSeconds)
            amHours.append(hour)
            targetHour = hour
        }
        
        amHours = amHours.sorted()
        
        let pmHours = (0..<(12 - amHours.count)).map {
            sunset.addingTimeInterval(nighttimeHourDurationInSeconds * Double($0))
        }
        
        return pmHours + amHours
    }
    
    /// Get the Roman time equivalent for a particular date and time.
    ///
    /// - parameter time: The modern time to look up.
    ///
    /// - returns: A `RomanNumeral` constant, plus `true` if it's a daylight
    ///            hour.
    func romanHour(forDate time: Date = Date()) -> RomanTime? {
        let daylightHour = daylightHourDurationInSeconds
        let nighttimeHour = nighttimeHourDurationInSeconds
        
        if let (hourIndex, isHalfPast) = daylightHours.index(ofTime: time,
                                                             hourDurationInSeconds: daylightHour) {
            return RomanTime(RomanNumeral.romanNumeral(for: hourIndex + 1)!,
                             isDaylightHour: true,
                             isHalfPast: isHalfPast)
        } else if let (hourIndex, isHalfPast) = nighttimeHours.index(ofTime: time,
                                                                     hourDurationInSeconds: nighttimeHour) {
            return RomanTime(RomanNumeral.romanNumeral(for: hourIndex + 1)!,
                             isDaylightHour: false,
                             isHalfPast: isHalfPast)
        }
        
        return nil
    }
    
}

public extension Array where Element == Date {
    
    // MARK: - Public Functions
    
    func index(ofTime time: Date,
               hourDurationInSeconds: TimeInterval) -> (Int, Bool)? {
        if self.isEmpty {
            return nil
        }
        
        // Append a fake extra time at the end to establish an upper bound for
        // real final element. This makes it far easier to calculate whether
        // the time falls during the last real element.
        let embiggenedArray = self + [self.last!.addingTimeInterval(hourDurationInSeconds)]
        
        if let (foundIndex, _) = embiggenedArray.enumerated()
            .dropLast()
            .first(where: { (index, _) in
                return embiggenedArray[index] <= time
                    && time < embiggenedArray[index].addingTimeInterval(hourDurationInSeconds)
            }) {
            
            let isHalfPast = time.timeIntervalSince(self[foundIndex]) >= (hourDurationInSeconds / 2.0)
            return (foundIndex, isHalfPast)
        } else {
            return nil
        }
    }
    
}
