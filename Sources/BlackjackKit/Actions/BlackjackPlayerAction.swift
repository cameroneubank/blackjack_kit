//
//  BlackjackPlayerAction.swift
//  BlackjackKit
//
//  Created by Cameron Eubank on 3/2/21.
//

import Foundation

public enum BlackjackPlayerAction {
    case bet(BetType)
    case readyUp
    case hit
    case stand
    case doubleDown
    case split
    
    public enum BetType {
        case up(Int)
        case down(Int)
    }
}
