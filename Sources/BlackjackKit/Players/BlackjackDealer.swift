//
//  BlackjackDealer.swift
//  BlackjackKit
//
//  Created by Cameron Eubank on 3/2/21.
//

import CardKit
import Foundation

internal protocol BlackjackDealerDelegate: AnyObject {
    func dealerDidRequestCard(_ dealer: BlackjackDealer) -> Card?
    
    func dealer(_ dealer: BlackjackDealer,
                didReceiveCard card: Card,
                inHand hand: BlackjackDealerHand)
    
    func dealer(_ dealer: BlackjackDealer,
                didFinishHand hand: BlackjackDealerHand)
}

public final class BlackjackDealer {
    
    // MARK: - Initialization
    
    private weak var delegate: BlackjackDealerDelegate?
    
    internal init(delegate: BlackjackDealerDelegate) {
        self.delegate = delegate
    }
    
    // MARK: - Private
    
    private(set) public var hand = BlackjackDealerHand()
    
    // MARK: - Internal
    
    internal func resetHand() {
        hand.reset()
    }
    
    internal func requestCard() {
        guard let card = delegate?.dealerDidRequestCard(self) else { return }
        hand.addCard(card)
        delegate?.dealer(self, didReceiveCard: card, inHand: hand)
    }
    
    internal func finish() {
        while hand.mustHit {
            requestCard()
        }
        delegate?.dealer(self, didFinishHand: hand)
    }
}
