//
//  BlackjackTable.swift
//  BlackjackKit
//
//  Created by Cameron Eubank on 3/2/21.
//

import CardKit
import Foundation

/// Protocol allowing conformers to respond to events that occur within an instance of `BlackjackTable`.
public protocol BlackjackTableDelegate: AnyObject {
    
    func table(_ table: BlackjackTable,
               didChangeState state: BlackjackTable.State)
    
    func player(_ player: BlackjackPlayer,
                didReceiveCard card: Card,
                inHand hand: BlackjackPlayerHand,
                fromTable table: BlackjackTable)
    
    func dealer(_ dealer: BlackjackDealer,
                didReceiveCard card: Card,
                inHand hand: BlackjackDealerHand,
                fromTable table: BlackjackTable)
    
}

public final class BlackjackTable {
    
    // MARK: - Initialization
    
    private let configuration: BlackjackTable.Configuration
    private weak var delegate: BlackjackTableDelegate?
    private let deck: CardDeck
    private(set) public lazy var player = BlackjackPlayer(delegate: self,
                                                          bankroll: configuration.buyInAmount)
    private lazy var dealer = BlackjackDealer(delegate: self)
    private(set) public var state: State = .acceptingBets {
        didSet {
            delegate?.table(self, didChangeState: state)
        }
    }
    
    public init(configuration: BlackjackTable.Configuration,
                delegate: BlackjackTableDelegate) {
        self.configuration = configuration
        self.delegate = delegate
        let deckConfiguration = CardDeck.Configuration(numberOfDecks: configuration.numberOfDecks,
                                                       preshuffled: true,
                                                       refillsWhenEmpty: true,
                                                       excludedCardValues: [.joker],
                                                       excludedCardSuits: [.joker])
        self.deck = CardDeck(configuration: deckConfiguration)
    }
    
    // MARK: - Public
    
    public func reset() {
        player.resetHands()
        dealer.resetHand()
    }
    
    // MARK: - Private

    private func handlePlayerAction(_ action: BlackjackPlayerAction) {
        switch action {
        case .bet(let type):
            switch type {
            case .up(let amount):
                player.increaseBet(by: amount)
            case .down(let amount):
                player.decreaseBet(by: amount)
            }
        case .doubleDown:
            player.increaseBet(by: player.currentHand.bet * 2)
            player.requestCard()
            state = .noMoreBets
            dealer.finish()
        case .hit:
            player.requestCard()
            if player.currentHand.didBust || player.currentHand.hasBlackjack {
                endGame()
            }
        case .readyUp:
            player.requestCard()
            dealer.requestCard()
            player.requestCard()
            dealer.requestCard()
            state = .dealt
            if player.currentHand.hasBlackjack {
                endGame()
            }
        case .split:
            break
        case .stand:
            state = .noMoreBets
            if player.currentHand.hasBlackjack {
                endGame()
            } else {
                dealer.finish()
            }
            break
        }
    }
    
    private func endGame() {
        if player.currentHand.hasBlackjack { // Player blackjacks
            let payout = Double(player.currentHand.bet) * 1.5
            player.bankroll += Int(payout)
            state = .gameOver(.playerVictory(.blackjack))
        } else if dealer.hand.hasBlackjack { // Dealer blackjacks
            state = .gameOver(.dealerVictory(.blackjack))
        } else if player.currentHand.didBust { // Player busts
            state = .gameOver(.dealerVictory(.standard))
        } else if dealer.hand.didBust { // Dealer busts
            player.bankroll += player.currentHand.bet * 2
            state = .gameOver(.playerVictory(.standard))
        } else if dealer.hand.value > player.currentHand.value { // Dealer > player
            state = .gameOver(.dealerVictory(.standard))
        } else if dealer.hand.value < player.currentHand.value { // Dealer < player
            player.bankroll += player.currentHand.bet * 2
            state = .gameOver(.playerVictory(.standard))
        } else if dealer.hand.value == player.currentHand.value { // Push
            player.bankroll += player.currentHand.bet
            state = .gameOver(.push)
        } else {
            print("Something went wrong!")
        }
    }
}

// MARK: - BlackjackPlayerDelegate

extension BlackjackTable: BlackjackPlayerDelegate {
    func player(_: BlackjackPlayer, didPerformAction action: BlackjackPlayerAction) {
        handlePlayerAction(action)
    }

    func playerDidRequestCard(_: BlackjackPlayer) -> Card? {
        deck.drawCard()
    }
    
    func player(_ player: BlackjackPlayer, didReceiveCard card: Card, inHand hand: BlackjackPlayerHand) {
        delegate?.player(player, didReceiveCard: card, inHand: hand, fromTable: self)
    }
}

// MARK: - BlackjackDealerDelegate

extension BlackjackTable: BlackjackDealerDelegate {
    func dealerDidRequestCard(_: BlackjackDealer) -> Card? {
        deck.drawCard()
    }
    
    func dealer(_ dealer: BlackjackDealer, didReceiveCard card: Card, inHand hand: BlackjackDealerHand) {
        delegate?.dealer(dealer, didReceiveCard: card, inHand: hand, fromTable: self)
    }
    
    func dealer(_: BlackjackDealer, didFinishHand _: BlackjackDealerHand) {
        endGame()
    }
}

// MARK: - BlackjackTable.Configuration

public extension BlackjackTable {
    
    struct Configuration {
        let numberOfDecks: Int
        let buyInAmount: Int
        
        public init(numberOfDecks: Int = 6,
                    buyInAmount: Int = 1000) {
            self.numberOfDecks = numberOfDecks
            self.buyInAmount = buyInAmount
        }
    }
}

// MARK: - BlackjackTable.State

public extension BlackjackTable {
    
    enum State {
        case acceptingBets
        case dealt
        case gameOver(GameOverType)
        case noMoreBets
        
        public enum GameOverType {
            case dealerVictory(DealerVictoryType)
            case playerVictory(PlayerVictoryType)
            case push
            
            public enum DealerVictoryType {
                case blackjack
                case standard
                case surrender
            }
            
            public enum PlayerVictoryType {
                case blackjack
                case standard
            }
        }
    }
}
