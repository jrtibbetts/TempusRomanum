//  Copyright © 2019 Poikile Creations. All rights reserved.

import Foundation

/// The various astronomical times for the given date and location. ALL
/// times are specified as UTC. See
/// http://www.digital-photo-secrets.com/tip/2832/the-differences-between-civil-nautical-and-astronomical-twilight/
/// for a discussion about the differences between civil, nautical,
/// and astronomical times.
struct SunriseSunsetDotOrgTimes: Codable, SolarAndLunarTimes {

    var astronomicalTwilightBegin: Date
    var astronomicalTwilightEnd: Date
    var civilTwilightBegin: Date
    var civilTwilightEnd: Date
    var nauticalTwilightBegin: Date
    var nauticalTwilightEnd: Date
    var sunrise: Date
    var sunset: Date

    var astronomicalDawn: Date {
        return astronomicalTwilightBegin
    }

    var astronomicalDusk: Date {
        return astronomicalTwilightEnd
    }

    var civilDawn: Date {
        return civilTwilightBegin
    }

    var civilDusk: Date {
        return civilTwilightEnd
    }

    var nauticalDawn: Date {
        return nauticalTwilightBegin
    }

    var nauticalDusk: Date {
        return nauticalTwilightEnd
    }

}
