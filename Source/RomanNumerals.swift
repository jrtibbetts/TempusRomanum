//  Copyright © 2019 Poikile Creations. All rights reserved.

import Foundation

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
        switch self {
        case .I:
            return "prima"
        case .II:
            return "secunda"
        case .III:
            return "tertia"
        case .IV:
            return "quarta"
        case .V:
            return "quinta"
        case .VI:
            return "sexta"
        case .VII:
            return "septima"
        case .VIII:
            return "octava"
        case .IX:
            return "nona"
        case .X:
            return "decima"
        case .XI:
            return "undecima"
        case .XII:
            return "duodecima"
        }
    }

    public static var allCases: AllCases {
        return [.I, .II, .III, .IV, .V, .VI, .VII, .VIII, .IX, .X, .XI, .XII]
    }
    
}
