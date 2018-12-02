//
//  SetupGameViewController.swift
//  CardGame
//
//  Created by Eric Internicola on 11/26/18.
//  Copyright © 2018 iColasoft. All rights reserved.
//

import Cartography
import UIKit

class SetupGameViewController: UIViewController {

    var player1View: SetupPlayerView!
    var player2View: SetupPlayerView!
    var startButton = UIButton(type: .custom)

    /// The player view that the user tapped "Select Deck" on.
    var pickingView: SetupPlayerView?

    override func viewDidLoad() {
        super.viewDidLoad()

        player1View = SetupPlayerView(title: "Player 1", playerName: GameSettings.shared.player1Name, selectedDeck: GameSettings.shared.player1Deck)
        player2View = SetupPlayerView(title: "Player 2", playerName: GameSettings.shared.player2Name, selectedDeck: GameSettings.shared.player2Deck)

        [player1View, player2View, startButton].forEach { view.addSubview($0) }

        constrain(view, player1View, player2View, startButton) { view, player1View, player2View, startButton in
            player1View.left == view.left + 8
            player1View.right == view.right - 8
            if #available(iOS 11.0, *) {
                player1View.top == view.safeAreaLayoutGuide.top
            } else {
                player1View.top == view.topMargin
            }

            player2View.top == player1View.bottom + 8
            player2View.left == view.left + 8
            player2View.right == view.right - 8

            startButton.top == player2View.bottom + 20
            startButton.centerX == view.centerX
            startButton.bottom <= view.bottom - 8
        }
        startButton.setTitle("Start Game", for: .normal)
        startButton.setTitleColor(UIColor.blue, for: .normal)
        startButton.addTarget(self, action: #selector(startGame(_:)), for: .touchUpInside)

        Notification.SetupPlayerView.tappedSelectDeck.addObserver(self, selector: #selector(loadDeckSelector(_:)))
    }
    
    class func loadFromStoryboard() -> SetupGameViewController {
        return UIStoryboard(name: "Gameplay", bundle: nil)
            .instantiateViewController(withIdentifier: "SetupGameViewController") as! SetupGameViewController
    }

    @IBAction
    func startGame(_ source: Any) {
        startGame()
    }
}

// MARK: - DeckChooserDelegate

extension SetupGameViewController: DeckChooserDelegate {

    func selected(deck: URL) {
        guard let pickingView = pickingView else {
            return
        }
        pickingView.selectedDeck = deck
    }

}

// MARK: - Notifications

extension SetupGameViewController {

    @objc
    func loadDeckSelector(_ notification: NSNotification) {
        guard let source = notification.object as? SetupPlayerView else {
            return
        }
        pickingView = source

        let deckChooser = DeckChooserTableViewController.loadFromStoryboard()
        deckChooser.modalPresentationStyle = .popover
        deckChooser.popoverPresentationController?.sourceView = source.selectDeckButton
        deckChooser.chooserDelegate = self
        present(deckChooser, animated: true, completion: nil)
    }

}

// MARK: - Implementation

private extension SetupGameViewController {

    func startGame() {
        guard let player1Name = player1View.playerNameText.text,
            let player2Name = player2View.playerNameText.text,
            let player1Deck = player1View.selectedDeck,
            let player2Deck = player2View.selectedDeck else {
                return
        }

        GameSettings.shared.player1Name = player1Name
        GameSettings.shared.player1Deck = player1Deck
        GameSettings.shared.player2Name = player2Name
        GameSettings.shared.player2Deck = player2Deck

        ModernGamePlayService.shared.createGame(player1: player1Name, deck1: player1Deck,
                                                player2: player2Name, deck2: player2Deck) { (game, error) in
            if let error = error {
                return print("ERROR: \(error.localizedDescription)")
            }
            guard let game = game else {
                return print("Error, no game object came back")
            }

            DispatchQueue.main.async { [weak self] in
                self?.start(game: game)
            }
        }
    }

    func start(game: Game) {
        let board = GameViewController.loadFromStoryboard()
        board.game = game
        navigationController?.pushViewController(board, animated: true)
    }
}

// MARK: - SetupPlayerView

class SetupPlayerView: UIView {
    let titleLabel = UILabel()
    let playerNameText = UITextField()
    let selectDeckButton = UIButton(type: .custom)
    let deckLabel = UILabel()
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    var selectedDeck: URL? {
        didSet {
            setDeckName()
        }
    }

    convenience init(title: String? = nil, playerName: String? = nil, selectedDeck: URL? = nil) {
        self.init(frame: .zero)
        self.title = title
        self.playerNameText.text = playerName
        self.selectedDeck = selectedDeck

        [titleLabel, playerNameText, selectDeckButton, deckLabel].forEach { addSubview($0) }
        playerNameText.placeholder = "Player's Name"

        layer.borderColor = UIColor.black.withAlphaComponent(0.5).cgColor
        layer.borderWidth = 1

        constrain(self, titleLabel, playerNameText, selectDeckButton, deckLabel) { view, titleLabel, playerNameLabel, selectDeckButton, deckLabel in

            titleLabel.top == view.top + 8
            titleLabel.left == view.left + 8
            titleLabel.right == view.right - 8

            playerNameLabel.top == titleLabel.bottom + 8
            playerNameLabel.left == titleLabel.left
            playerNameLabel.right == titleLabel.right

            selectDeckButton.top == playerNameLabel.bottom + 8
            selectDeckButton.left == titleLabel.left
            selectDeckButton.bottom == view.bottom - 8

            deckLabel.left == selectDeckButton.right + 8
            deckLabel.right == view.right
            deckLabel.centerY == selectDeckButton.centerY
        }
        titleLabel.text = title

        selectDeckButton.setTitle("Select Deck", for: .normal)
        selectDeckButton.setTitleColor(UIColor.blue, for: .normal)
        selectDeckButton.addTarget(self, action: #selector(tappedSelectDeck(_:)), for: .touchUpInside)
        setDeckName()
    }

    func setDeckName() {
        guard let deckName = selectedDeck?.userFriendlyName else {
            deckLabel.text = "No deck selected"
            return
        }
        deckLabel.text = deckName
    }
}

// MARK: - User Events

extension SetupPlayerView {

    @IBAction
    func tappedSelectDeck(_ source: UIButton) {
        Notification.SetupPlayerView.tappedSelectDeck.notify(withObject: self)
    }
}

// MARK: - SetupPlayerView Notification

extension Notification {

    enum SetupPlayerView: String, Notifiable, CustomStringConvertible {
        case tappedSelectDeck = "tapped.select.deck"

        static var notificationBase: String {
            return "com.icolasoft.mtg.playerview"
        }

        var description: String {
            return rawValue
        }
    }
}
