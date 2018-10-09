//  Copyright © 2018 Poikile Creations. All rights reserved.

import Foundation

public struct SolarAndLunarData: Codable {
    var error: Bool
    var apiversion: String
    var year: Int
    var month: Int
    var day: Int
    var dayofweek: String
    var datechanged: Bool
    var lon: Double
    var lat: Double
    var tz: Int

    var sundata: [PhenomenonTime]
    var moondata: [PhenomenonTime]

    var closestphase: [Phase]
    var fracillum: String
    var curphase: String

    public struct Phase: Codable {
        var phase: String
        var date: Date
        var time: Date
    }

    public struct PhenomenonTime: Codable {

        public enum Phenomenon: String, Codable {
            case BC
            case R
            case U
            case S
            case EC
        }

        var phen: Phenomenon
        var time: String

    }

}

