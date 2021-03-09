//
//  Card+.swift
//  BlackjackKit
//
//  Created by Cameron Eubank on 3/2/21.
//

import CardKit
import Foundation

internal extension Card {
    
    var blackjackValue: Int {
        switch value {
        case .two: return 2
        case .three: return 3
        case .four: return 4
        case .five: return 5
        case .six: return 6
        case .seven: return 7
        case .eight: return 8
        case .nine: return 9
        case .ten, .jack, .queen, .king: return 10
        case .ace: return 11 // Treat aces high by default.
        case .joker: return 0
        }
    }
}
