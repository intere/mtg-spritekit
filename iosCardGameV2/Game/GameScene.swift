

import MTGSDKSwift
import SpriteKit

enum CardLevel: CGFloat {
    case board = 10
    case moving = 100
    case enlarged = 200
}

class GameScene: SKScene {

    var playerBoard: PlayerBoard!
    var messageLabel: SKLabelNode?
    var gameCamera = SKCameraNode()
    var selectedCard: SKCard? {
        didSet {
            guard let selectedCard = selectedCard else {
                return
            }
            if let name = selectedCard.card.name {
                print("Selected Card: \(name)")
            }
        }
    }

    override func didMove(to view: SKView) {
        camera = gameCamera
        camera?.position = CGPoint(x: view.frame.midX, y: view.frame.midY)

        guard NSClassFromString("XCTestCase") == nil else {
            return
        }

        addLoadingLabel()
        cacheDeck()

        Notification.UserAction.mulliganHand.addObserver(self, selector: #selector(takeMulligan(_:)))
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            guard let card = self.card(for: touch), !card.enlarged else {
                continue
            }
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            guard let card = card(for: touch) else {
                return
            }
            guard !touch.isMultiTap else {
                card.toggleEnlarged()
                return
            }
            guard !card.enlarged else {
                return
            }

            if card.selected {
                card.deselect()
                selectedCard = nil
            } else {
                selectedCard?.deselect()
                card.select()
                selectedCard = card
            }
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            guard let card = card(for: touch) else {
                continue
            }
            guard !card.enlarged else {
                continue
            }

        }
    }

}

// MARK: - Notifications

extension GameScene {

    @objc
    func takeMulligan(_ notification: NSNotification) {
        // 1. Remove current cards
        for child in children where child.name == "Hand" {
            child.removeFromParent()
        }

        // 2. take a mulligan and show that hand
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else {
                return
            }
            self.playerBoard.mulligan()
            self.showHand()

            guard self.playerBoard.cardsInHand > 0 else {
                return
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                Notification.GameSceneEvent.gameLoaded.notify()
            }
        }

    }

}

// MARK: - Implementation

extension GameScene {

    /// Loads the deck (deck.txt file) and caches all of the images for it.
    func cacheDeck() {
        let deck = playerBoard.player.deck
        
        // Ensure that we cache all of the cards in the deck, then continue
        MtgApiService.shared.cache(deck: deck) { (error) in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                if let error = error {
                    self.messageLabel?.text = "Error loading deck from API\n\(error.localizedDescription)"
                    return
                }
                self.messageLabel?.run(SKAction.fadeOut(withDuration: 0.5)) {
                    self.messageLabel?.removeFromParent()
                }
                self.startGame()
                Notification.GameSceneEvent.gameLoaded.notify()
            }
        }
    }

    /// Gets you the card for the provided touch.
    ///
    /// - Parameter touch: The touch event
    /// - Returns: An SKCard if there was one at the touch point.
    func card(for touch: UITouch) -> SKCard? {
        let location = touch.location(in: self)
        return card(at: location)
    }

    /// Gets you the card at the provided location.
    ///
    /// - Parameter location: The location to check for a cad.
    /// - Returns: The SKCard if it exists at the provided point.
    func card(at location: CGPoint) -> SKCard? {
        return atPoint(location) as? SKCard ?? atPoint(location).parent as? SKCard
    }

    /// Adds a "loading" message to the view.
    func addLoadingLabel() {
        let messageLabel = SKLabelNode(text: "Loading cards, please wait...")
        messageLabel.fontSize = 36
        messageLabel.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(messageLabel)
        self.messageLabel = messageLabel
    }

    /// Starts the game up, visually
    func startGame() {
        playerBoard.startGame()
        showHand()
        showLibrary()
    }

    func showLibrary() {
        let library = SKCardPile(title: "Library", cards: playerBoard.library, faceDown: true)
        let libraryPile = SKPlaceholderPile(pile: library)
        libraryPile.position = CGPoint(x: frame.maxX - (SKCard.Constants.width / 2 + 30), y: frame.maxY - (SKCard.Constants.height / 2 + 30))
        addChild(libraryPile)
    }

    /// Positions the players hand
    func showHand() {
//        let hand = playerBoard.hand
//
//        var startX = CGFloat(20) + SKCard.Constants.width / 2
//        var startY = CGFloat(frame.minY + 30) + SKCard.Constants.height / 2
//
//        for card in hand {
//            let skCard = SKCard(card: card)
//            skCard.position = CGPoint(x: startX, y: startY)
//            if reset(y: startY) {
//                resetPosition(card: skCard)
//                startX = skCard.position.x
//                startY = skCard.position.y
//            }
//            startX += skCard.frame.width + 5
//            skCard.fadeInAfter(addingTo: self)
//        }
        let hand = SKCardGroup(name: "Hand", cards: playerBoard.hand.map({ SKCard(card: $0) }))
        hand.position = CGPoint(x: SKCard.Constants.width / 2 + 20, y: frame.minY + 30 + SKCard.Constants.height / 2)
        addChild(hand)
    }

    /// Renders the deck on the screen (makes use of the deck and the cards).
    ///
    /// - Parameters:
    ///   - deck: The deck to show on the screen.
    ///   - cards: The cards to show on the screen.
    func showOverlapped(deck: Deck, cards: [Card]) {
        var cardHash = [String: Card]()
        cards.forEach { card in
            guard let name = card.name else {
                return print("ERROR: Card with no name")
            }
            cardHash[name] = card
        }

        var startX = CGFloat(100)
        var startY = CGFloat(frame.maxY - 10) - SKCard.Constants.height / 2

        for card in deck.mainboard {
            guard let apiCard = cardHash[card.name] else {
                print("ERROR: no API Card for \(card.name)")
                continue
            }
            guard apiCard.imageUrl != nil else {
                print("ERROR: no image for card \(card.name)")
                continue
            }
            for _ in 0..<card.quantity {
                let skCard = SKCard(card: apiCard)
                skCard.position = CGPoint(x: startX, y: startY)
                if reset(y: startY) {
                    resetPosition(card: skCard)
                    startX = skCard.position.x
                    startY = skCard.position.y
                }
                addChild(skCard)
                startY -= 25
            }
            startY -= SKCard.Constants.height
        }
    }

    /// Should the y be reset (based on the current Y value)?
    ///
    /// - Parameter y: The y value we want to drop a card in at.
    /// - Returns: True if the y value would have the card too low, false if not.
    func reset(y: CGFloat) -> Bool {
        return y - SKCard.Constants.height / 2 < 10
    }

    /// Takes the provided card and moves it up and to the right.
    ///
    /// - Parameter card: The card to be repositioned.
    func resetPosition(card: SKCard) {
        let newY = CGFloat(frame.maxY - 10) - SKCard.Constants.height / 2
        let newX = card.position.x + 20 + SKCard.Constants.width

        card.position = CGPoint(x: newX, y: newY)
    }
}

// MARK: - UITouch extension

extension UITouch {

    /// Is this a multi (double or more) tap?
    var isMultiTap: Bool {
        return tapCount > 1
    }

}
