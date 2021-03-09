//
//  Sequence+.swift
//  BlackjackKit
//
//  Created by Cameron Eubank on 3/2/21.
//

import CardKit
import Foundation

// MARK: - Element == Int

internal extension Sequence where Element == Int {
    
    var sum: Int {
        reduce(0, +)
    }
}

// MARK: - Element == Card

internal extension Sequence where Element == Card {
    
    var containsAce: Bool {
        let cardValues: [CardValue] = self.map { $0.value }
        return cardValues.contains(.ace)
    }
}
