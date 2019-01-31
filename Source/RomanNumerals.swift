//  Copyright © 2019 Poikile Creations. All rights reserved.

import Foundation

/// An enumeration of the Roman numerals `I` through `XII`.
public enum RomanNumeral: String, CaseIterable {

    case I
    case II
    case III
    case IV
    case V
    case VI
    case VII
    case VIII
    case IX
    case X
    case XI
    case XII

    var ordinal: String {
        let index = type(of: self).allCases.firstIndex(of: self)!

        return type(of: self).ordinals[index]
    }

    public static var allCases: AllCases {
        return [.I, .II, .III, .IV, .V, .VI, .VII, .VIII, .IX, .X, .XI, .XII]
    }

    private static var ordinals: [String] = ["prima",   "secunda",  "tertia",
                                             "quarta",  "quinta",   "sexta",
                                             "septima", "octava",   "nona",
                                             "decima",  "undecima", "duodecima"]

    /// Get the time, expressed as the ordinal hour value and, if half-past the
    /// hour or later, the phrase `et dimidia`. The Romans did not have the
    /// same notion of minutes that we do today.
    public static func timeString(from date: Date, sunriseSunset: SunriseSunset) -> String {
        let calendar = Calendar.current
        let desiredComponents: [Calendar.Component] = [.hour, .minute, .timeZone]
        let components = calendar.dateComponents(Set<Calendar.Component>(desiredComponents), from: date)

        var hour = components.hour!
        let minute = components.minute!
        hour = (hour + 6) % 12  // convert 24-hour time to 12-hour time
        var string = "\(allCases[hour].ordinal) hora"

        if minute >= 30 {
            string.append(" et dimidia")
        }

        return string
    }
    
}
