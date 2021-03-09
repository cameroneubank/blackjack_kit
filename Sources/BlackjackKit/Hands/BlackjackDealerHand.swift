//
//  BlackjackDealerHand.swift
//  BlackjackKit
//
//  Created by Cameron Eubank on 3/2/21.
//

import CardKit
import Foundation

public final class BlackjackDealerHand {
    
    // MARK: - Public
    
    private(set) public var value: Int = .zero
    
    // MARK: - Private
    
    private var cards = [Card]()
    
    private func calculateValue() {
        let value = cards.map { $0.blackjackValue }.sum
        if cards.containsAce {
            let aces: [Card] = cards.filter { $0.value == .ace }
            if value == 17 {
                self.value = value
            } else if value > 21 {
                // We have at least two aces.
                // See if treating the first as low gets us below 21.
                // If it does, we can treat the first ace as one.
                // Otherwise, we need to treat every ace low.
                if value - 10 <= 21 {
                    self.value = value - 10
                } else {
                    let lowAcesValue = (aces.count - 1) * 10
                    self.value = value - lowAcesValue
                }
            } else {
                self.value = value
            }
        } else {
            self.value = value
        }
    }

    // MARK: - Internal
    
    internal func reset() {
        cards.removeAll()
        value = .zero
    }
    
    internal func addCard(_ card: Card) {
        cards.append(card)
        calculateValue()
    }
    
    internal var mustHit: Bool {
        value < 17
    }
    
    internal var hasBlackjack: Bool {
        guard cards.count == 2 else { return false }
        return value == 21
    }
    
    internal var didBust: Bool {
        value > 21
    }
    
    internal var canOfferInsurance: Bool {
        guard cards.count == 2, let firstCard = cards.first else { return false }
        return firstCard.value == .ace
    }
}
