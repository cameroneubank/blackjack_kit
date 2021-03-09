//
//  BlackjackDealerHandTests.swift
//  BlackjackKit
//
//  Created by Cameron Eubank on 3/2/21.
//

@testable import BlackjackKit
@testable import CardKit
import Foundation
import XCTest

final class BlackjackDealerHandTests: XCTestCase {
    
    func test_oneCard_noAces() {
        let hand = BlackjackDealerHand()
        hand.addCard(Card(suit: .spade, value: .eight))
        XCTAssertEqual(hand.value, 8)
        XCTAssertTrue(hand.mustHit)
        XCTAssertFalse(hand.hasBlackjack)
        XCTAssertFalse(hand.canOfferInsurance)
    }
    
    func test_twoCards_noAces() {
        let hand = BlackjackDealerHand()
        hand.addCard(Card(suit: .spade, value: .eight))
        hand.addCard(Card(suit: .spade, value: .six))
        XCTAssertEqual(hand.value, 14)
        XCTAssertTrue(hand.mustHit)
        XCTAssertFalse(hand.hasBlackjack)
        XCTAssertFalse(hand.canOfferInsurance)
    }
    
    func test_threeCards_noAces() {
        let hand = BlackjackDealerHand()
        hand.addCard(Card(suit: .spade, value: .two))
        hand.addCard(Card(suit: .spade, value: .four))
        hand.addCard(Card(suit: .spade, value: .six))
        XCTAssertEqual(hand.value, 12)
        XCTAssertTrue(hand.mustHit)
        XCTAssertFalse(hand.hasBlackjack)
        XCTAssertFalse(hand.canOfferInsurance)
    }
    
    func test_sixCards_noAces() {
        let hand = BlackjackDealerHand()
        hand.addCard(Card(suit: .spade, value: .two))
        hand.addCard(Card(suit: .spade, value: .two))
        hand.addCard(Card(suit: .spade, value: .two))
        hand.addCard(Card(suit: .spade, value: .two))
        hand.addCard(Card(suit: .spade, value: .two))
        hand.addCard(Card(suit: .spade, value: .two))
        XCTAssertEqual(hand.value, 12)
        XCTAssertTrue(hand.mustHit)
        XCTAssertFalse(hand.hasBlackjack)
        XCTAssertFalse(hand.canOfferInsurance)
    }
    
    // MARK: - Test Value All Aces
    
    func test_oneCard_allAces() {
        let hand = BlackjackDealerHand()
        hand.addCard(Card(suit: .spade, value: .ace))
        XCTAssertEqual(hand.value, 11)
        XCTAssertTrue(hand.mustHit)
        XCTAssertFalse(hand.hasBlackjack)
        XCTAssertFalse(hand.canOfferInsurance)
    }
    
    func test_twoCards_allAces() {
        let hand = BlackjackDealerHand()
        hand.addCard(Card(suit: .spade, value: .ace))
        hand.addCard(Card(suit: .spade, value: .ace))
        XCTAssertEqual(hand.value, 12)
        XCTAssertTrue(hand.mustHit)
        XCTAssertFalse(hand.hasBlackjack)
        XCTAssertTrue(hand.canOfferInsurance)
    }
    
    func test_threeCards_allAces() {
        let hand = BlackjackDealerHand()
        hand.addCard(Card(suit: .spade, value: .ace))
        hand.addCard(Card(suit: .spade, value: .ace))
        hand.addCard(Card(suit: .spade, value: .ace))
        XCTAssertEqual(hand.value, 13)
        XCTAssertTrue(hand.mustHit)
        XCTAssertFalse(hand.hasBlackjack)
        XCTAssertFalse(hand.canOfferInsurance)
    }
    
    func test_sixCards_allAces() {
        let hand = BlackjackDealerHand()
        hand.addCard(Card(suit: .spade, value: .ace))
        hand.addCard(Card(suit: .spade, value: .ace))
        hand.addCard(Card(suit: .spade, value: .ace))
        hand.addCard(Card(suit: .spade, value: .ace))
        hand.addCard(Card(suit: .spade, value: .ace))
        hand.addCard(Card(suit: .spade, value: .ace))
        XCTAssertEqual(hand.value, 16)
        XCTAssertTrue(hand.mustHit)
        XCTAssertFalse(hand.hasBlackjack)
        XCTAssertFalse(hand.canOfferInsurance)
    }
    
    // MARK: - Test Value Some Aces
    
    func test_twoCards_someAces() {
        let hand = BlackjackDealerHand()
        hand.addCard(Card(suit: .spade, value: .six))
        hand.addCard(Card(suit: .spade, value: .ace))
        XCTAssertEqual(hand.value, 17)
        XCTAssertFalse(hand.mustHit)
        XCTAssertFalse(hand.hasBlackjack)
        XCTAssertFalse(hand.canOfferInsurance)
    }
    
    func test_threeCards_someAces() {
        let hand = BlackjackDealerHand()
        hand.addCard(Card(suit: .spade, value: .ace))
        hand.addCard(Card(suit: .spade, value: .ace))
        hand.addCard(Card(suit: .spade, value: .six))
        XCTAssertEqual(hand.value, 18)
        XCTAssertFalse(hand.mustHit)
        XCTAssertFalse(hand.hasBlackjack)
        XCTAssertFalse(hand.canOfferInsurance)
    }
    
    func test_sixCards_someAces() {
        let hand = BlackjackDealerHand()
        hand.addCard(Card(suit: .spade, value: .ace))
        hand.addCard(Card(suit: .spade, value: .ace))
        hand.addCard(Card(suit: .spade, value: .ace))
        hand.addCard(Card(suit: .spade, value: .ace))
        hand.addCard(Card(suit: .spade, value: .ace))
        hand.addCard(Card(suit: .spade, value: .two))
        XCTAssertEqual(hand.value, 17)
        XCTAssertFalse(hand.mustHit)
        XCTAssertFalse(hand.hasBlackjack)
        XCTAssertFalse(hand.canOfferInsurance)
    }
    
    // MARK: - Test Value Some Aces Twenty One
    
    func test_twoCards_oneAce_twentyOne() {
        let hand = BlackjackDealerHand()
        hand.addCard(Card(suit: .spade, value: .king))
        hand.addCard(Card(suit: .spade, value: .ace))
        XCTAssertEqual(hand.value, 21)
        XCTAssertFalse(hand.mustHit)
        XCTAssertTrue(hand.hasBlackjack)
        XCTAssertFalse(hand.canOfferInsurance)
    }
    
    func test_threeCards_oneAce_twentyOne() {
        let hand = BlackjackDealerHand()
        hand.addCard(Card(suit: .spade, value: .ace))
        hand.addCard(Card(suit: .spade, value: .five))
        hand.addCard(Card(suit: .spade, value: .five))
        XCTAssertEqual(hand.value, 21)
        XCTAssertFalse(hand.mustHit)
        XCTAssertFalse(hand.hasBlackjack)
        XCTAssertFalse(hand.canOfferInsurance)
    }
    
    func test_fourCards_oneAce_twentyOne() {
        let hand = BlackjackDealerHand()
        hand.addCard(Card(suit: .spade, value: .ace))
        hand.addCard(Card(suit: .spade, value: .three))
        hand.addCard(Card(suit: .spade, value: .two))
        hand.addCard(Card(suit: .spade, value: .five))
        XCTAssertEqual(hand.value, 21)
        XCTAssertFalse(hand.mustHit)
        XCTAssertFalse(hand.hasBlackjack)
        XCTAssertFalse(hand.canOfferInsurance)
    }
    
    func test_sixCards_oneAce_twentyOne() {
        let hand = BlackjackDealerHand()
        hand.addCard(Card(suit: .spade, value: .ace))
        hand.addCard(Card(suit: .spade, value: .two))
        hand.addCard(Card(suit: .spade, value: .two))
        hand.addCard(Card(suit: .spade, value: .two))
        hand.addCard(Card(suit: .spade, value: .two))
        hand.addCard(Card(suit: .spade, value: .two))
        XCTAssertEqual(hand.value, 21)
        XCTAssertFalse(hand.mustHit)
        XCTAssertFalse(hand.hasBlackjack)
        XCTAssertFalse(hand.canOfferInsurance)
    }
    
    func test_threeCards_twoAces_twentyOne() {
        let hand = BlackjackDealerHand()
        hand.addCard(Card(suit: .spade, value: .ace))
        hand.addCard(Card(suit: .spade, value: .ace))
        hand.addCard(Card(suit: .spade, value: .nine))
        XCTAssertEqual(hand.value, 21)
        XCTAssertFalse(hand.mustHit)
        XCTAssertFalse(hand.hasBlackjack)
        XCTAssertFalse(hand.canOfferInsurance)
    }
    
    func test_fourCards_threeAce_twentyOne() {
        let hand = BlackjackDealerHand()
        hand.addCard(Card(suit: .spade, value: .ace))
        hand.addCard(Card(suit: .spade, value: .ace))
        hand.addCard(Card(suit: .spade, value: .ace))
        hand.addCard(Card(suit: .spade, value: .eight))
        XCTAssertEqual(hand.value, 21)
        XCTAssertFalse(hand.mustHit)
        XCTAssertFalse(hand.hasBlackjack)
        XCTAssertFalse(hand.canOfferInsurance)
    }
    
    func test_sixCards_fiveAces_twentyOne() {
        let hand = BlackjackDealerHand()
        hand.addCard(Card(suit: .spade, value: .ace))
        hand.addCard(Card(suit: .spade, value: .ace))
        hand.addCard(Card(suit: .spade, value: .ace))
        hand.addCard(Card(suit: .spade, value: .ace))
        hand.addCard(Card(suit: .spade, value: .ace))
        hand.addCard(Card(suit: .spade, value: .six))
        XCTAssertEqual(hand.value, 21)
        XCTAssertFalse(hand.mustHit)
        XCTAssertFalse(hand.hasBlackjack)
        XCTAssertFalse(hand.canOfferInsurance)
    }
}
