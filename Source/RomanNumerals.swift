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

    static func romanNumeral(for number: Int) -> RomanNumeral? {
        if (1 <= number && number <= allCases.count) {
            return allCases[number - 1]
        } else {
            return nil
        }
    }

    private static var ordinals: [String] = ["prima",   "secunda",  "tertia",
                                             "quarta",  "quinta",   "sexta",
                                             "septima", "octava",   "nona",
                                             "decima",  "undecima", "duodecima"]
    
}
