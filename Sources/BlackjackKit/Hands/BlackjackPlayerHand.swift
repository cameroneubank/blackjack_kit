//
//  BlackjackPlayerHand.swift
//  BlackjackKit
//
//  Created by Cameron Eubank on 3/2/21.
//

import CardKit
import Foundation

public final class BlackjackPlayerHand {
    
    // MARK: - Public
    
    private(set) public var value: Int = .zero
    private(set) public var alternativeValue: Int?
    internal(set) public var bet: Int = .zero
    
    public var hasBlackjack: Bool {
        cards.count == 2 && value == 21
    }
    
    public var canHit: Bool {
        cards.count == 2
    }
    
    public var canStand: Bool {
        cards.count == 2
    }
    
    public var canSplit: Bool {
        cards.count == 2 && cards.first?.blackjackValue == cards.last?.blackjackValue
    }
    
    public var didBust: Bool {
        value > 21
    }
    
    public func canDoubleDown(bankroll: Int) -> Bool {
        cards.count == 2 && bet * 2 <= bankroll
    }
    
    // MARK: - Private
    
    private var cards = [Card]()
    
    private func calculateValue() {
        value = cards.map { $0.blackjackValue }.sum
        if cards.containsAce {
            let aces: [Card] = cards.filter { $0.value == .ace }
            let alternativeValue = value - (aces.count - 1 * 10)
            self.alternativeValue = alternativeValue
            if value > 21 || alternativeValue > value {
                value = alternativeValue
            }
        }
    }
    
    // MARK: - Internal
    
    internal func reset() {
        cards.removeAll()
        value = .zero
        alternativeValue = nil
        bet = .zero
    }
    
    internal func addCard(_ card: Card) {
        cards.append(card)
        calculateValue()
    }
}

// MARK: - BlackjackPlayerHand.Value {

extension BlackjackPlayerHand {
    public enum BlackjackHandValue {
        case high(Int)
        case low(Int)
    }
}
