//  Copyright © 2018 Poikile Creations. All rights reserved.

import Foundation

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

