//
//  BlackjackPlayer.swift
//  BlackjackKit
//
//  Created by Cameron Eubank on 3/2/21.
//

import CardKit
import Foundation

internal protocol BlackjackPlayerDelegate: AnyObject {
    
    func playerDidRequestCard(_ player: BlackjackPlayer) -> Card?
    
    func player(_ player: BlackjackPlayer,
                didReceiveCard card: Card,
                inHand hand: BlackjackPlayerHand)
    
    func player(_ player: BlackjackPlayer,
                didPerformAction action: BlackjackPlayerAction)
}

public final class BlackjackPlayer {
    
    // MARK: - Public
    
    private(set) public var hands = [BlackjackPlayerHand]()
    
    public var currentHand: BlackjackPlayerHand {
        hands.first!
    }
    
    public func perform(_ action: BlackjackPlayerAction) {
        delegate?.player(self, didPerformAction: action)
    }
    
    // MARK: - Initialization
    
    private weak var delegate: BlackjackPlayerDelegate?
    internal(set) public var bankroll: Int {
        didSet {
            print("\(oldValue)")
            print("\(bankroll)")
        }
    }
    
    internal init(delegate: BlackjackPlayerDelegate,
                  bankroll: Int) {
        self.delegate = delegate
        self.bankroll = bankroll
        self.hands.append(BlackjackPlayerHand())
    }
    
    // MARK: - Internal
    
    internal func resetHands() {
        hands.forEach { $0.reset() }
    }
    
    internal func requestCard() {
        guard let card = delegate?.playerDidRequestCard(self) else { return }
        currentHand.addCard(card)
        delegate?.player(self, didReceiveCard: card, inHand: currentHand)
    }
    
    internal func increaseBet(by bet: Int) {
        guard bet > .zero, bankroll > .zero else { return }
        bankroll -= bet
        currentHand.bet += bet
    }
    
    internal func decreaseBet(by bet: Int) {
        guard bet > .zero, currentHand.bet > .zero else { return }
        bankroll += bet
        currentHand.bet -= bet
    }
}
