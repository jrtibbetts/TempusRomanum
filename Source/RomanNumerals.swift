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

    /// Get the ordinal (e.g. *prima* ("first"), *secunda* ("second"), *tertia*
    /// ("third") value of the number. Since this is an adjective that will
    /// modify the singular nominative form of the feminine noun *hora*
    /// ("hour"), it must also be the feminine singular nominative form.
    var ordinal: String {
        let ordinals = ["prima", "secunda", "tertia",
                        "quarta", "quinta", "sexta",
                        "septima", "octava", "nona",
                        "decima", "undecima", "duodecima"]
        let index = type(of: self).allCases.firstIndex(of: self)!

        return ordinals[index]
    }

    /// Get the Roman numeral for a number from 1 to 12.
    ///
    /// - parameter number: The value whose Roman numeral should be returned.
    ///                     If it's less than `0` or greater than `12`, then
    ///                     `nil` is returned.
    static func romanNumeral(for number: Int) -> RomanNumeral? {
        if 1 <= number && number <= allCases.count {
            return allCases[number - 1]
        } else {
            return nil
        }
    }

}
