//  Copyright © 2018 Poikile Creations. All rights reserved.

import Stylobate
import Foundation

/// A `DateFormatter` for getting `Date`s from the phenenoma time strings,
/// which are simple military time.
fileprivate let timeFormatter = DateFormatter() <~ {
    $0.dateFormat = "HH:mm"
}

/// The JSON data that's returned by the US Naval Observatory's REST API.
public struct SolarAndLunarData: Codable {

    var apiVersion: String
    var dateChanged: Bool
    var day: Int
    var dayOfWeek: String
    var error: Bool
    var lat: Double
    var lon: Double
    var month: Int
    var timeZoneOffset: Int
    var year: Int

    var lunarData: [Phenomenon]
    var solarData: [Phenomenon]

    var closestPhase: Phase
    var currentPhase: String
    var fracillum: String

    fileprivate enum CodingKeys: String, CodingKey {
        case apiVersion = "apiversion"
        case dateChanged = "datechanged"
        case day
        case dayOfWeek = "dayofweek"
        case error
        case lat
        case lon
        case month
        case timeZoneOffset = "tz"
        case year

        case lunarData = "moondata"
        case solarData = "sundata"

        case closestPhase = "closestphase"
        case currentPhase = "curphase"
        case fracillum
    }

    public struct Phase: Codable {
        var phase: String
        var date: String
        var time: String
    }

    public struct Phenomenon: Codable {

        var phenomenon: String
        var time: String

        fileprivate enum CodingKeys: String, CodingKey {
            case phenomenon = "phen"
            case time
        }

    }

}

public extension SolarAndLunarData {

    /// A dictionary of the solar phenomena times, keyed by phenomena codes.
    ///
    /// The codes are:
    ///  * R: sunrise
    ///  * U: upper transit
    ///  * BC: beginning of civil twilight
    ///  * EC: end of civil twilight
    ///  * S: sunset
    public var solarPhenomena: [String: String] {
        return phenomenaMap(solarData)
    }

    fileprivate func phenomenaMap(_ phenomena: [Phenomenon]) -> [String: String] {
        return phenomena.reduce(into: [String: String]()) { $0[$1.phenomenon] = $1.time }
    }

    public var sunriseString: String {
        return solarPhenomena["R"]!
    }

    public var sunrise: Date {
        return timeFormatter.date(from: sunriseString)!
    }

    public var sunsetString: String! {
        return solarPhenomena["S"]!
    }

    public var sunset: Date {
        return timeFormatter.date(from: sunsetString)!
    }

}

/// Encapsulates `Date`s for a day's sunrise and sunset, and has numerous
/// handy properties for calculating things like number of minutes of
/// nighttime.
public struct SunriseSunset {

    public let sunrise: Date

    public let sunset: Date

    // MARK: - Computed Properties

    public var sunriseString: String {
        return timeFormatter.string(from: sunrise)
    }

    public var sunsetString: String {
        return timeFormatter.string(from: sunset)
    }

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
