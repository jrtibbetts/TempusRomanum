//  Copyright © 2019 Poikile Creations. All rights reserved.

import Foundation

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
