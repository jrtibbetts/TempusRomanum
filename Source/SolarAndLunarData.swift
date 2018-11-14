//  Copyright © 2018 Poikile Creations. All rights reserved.

import Stylobate
import Foundation

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

    /// A `DateFormatter` for getting `Date`s from the phenenoma time strings,
    /// which are simple military time.
    fileprivate static var timeFormatter = DateFormatter() <~ {
        $0.dateFormat = "HH:mm"
    }

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
        return SolarAndLunarData.timeFormatter.date(from: sunriseString)!
    }

    public var sunsetString: String! {
        return solarPhenomena["S"]!
    }

    public var sunset: Date {
        return SolarAndLunarData.timeFormatter.date(from: sunsetString)!
    }

}
