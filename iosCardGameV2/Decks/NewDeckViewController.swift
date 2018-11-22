//
//  NewDeckViewController.swift
//  CardGame
//
//  Created by Eric Internicola on 10/20/18.
//  Copyright © 2018 iColasoft. All rights reserved.
//

import UIKit

class NewDeckViewController: UIViewController {

    @IBOutlet weak var deckNameText: UITextField!
    @IBOutlet weak var deckListText: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        deckListText.delegate = self
        deckNameText.delegate = self
    }

    @IBAction
    func tappedCreateDeck(_ sender: Any) {
        checkForUrlAndCreateDeck()
    }

}

// MARK: - UITextViewDelegate

extension NewDeckViewController: UITextViewDelegate {

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
        }
        return true
    }

}

// MARK: - UITextFieldDelegate

extension NewDeckViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}

// MARK: - Implementation

private extension NewDeckViewController {

    /// Builds you a summary of the deck.
    var buildDeckSummary: String {
        let deck = DeckReader().read(fileContent: deckListText.text)

        return "deck with \(deck.mainboardCount) cards in mainboard and \(deck.sideboardCount) cards in the sideboard"
    }

    /// Tells you if the title is valid
    var titleIsValid: Bool {
        guard let text = deckNameText.text else {
            return false
        }

        return !text.isEmpty
    }

    /// Tells you if the deck list is valid.
    var deckListIsValid: Bool {
        guard let text = deckListText.text else {
            return false
        }
        return !text.isEmpty
    }

    func checkForUrlAndCreateDeck() {
        guard let url = URL(string: deckListText.text) else {
            return promptUserCreateDeck()
        }

        RemoteDeckService.shared.fetchDeck(from: url) { (title, content, error) in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {
                    return
                }
                if let title = title {
                    self.deckNameText.text = title
                }
                if let content = content {
                    self.deckListText.text = content
                }

                if let error = error {
                    self.alertError(error)
                } else {
                    self.promptUserCreateDeck()
                }
            }
        }
    }

    /// Prompts the user to create the deck
    func promptUserCreateDeck() {
        guard titleIsValid else {
            return alertFillInTitle()
        }
        guard deckListIsValid else {
            return alertFillInDeck()
        }

        let alert = UIAlertController.yesNoAlert(
            title: "Deck Info",
            message: "Your deck has been read as a \(buildDeckSummary).  Create this deck?",
            yesCallback: { [weak self] in
                self?.saveDeck()
            }, noCallback: { [weak self] in
                return self?.deckListText.becomeFirstResponder()
        })

        present(alert, animated: true)
    }

    func alertFillInTitle() {
        present(UIAlertController.okayAlert(title: "Error", message: "You must provide a title.", callback: { [weak self] in
            self?.deckNameText.becomeFirstResponder()
        }), animated: true)
    }

    func alertFillInDeck() {
        present(UIAlertController.okayAlert(title: "Error", message: "You must provide a deck list.", callback: { [weak self] in
            self?.deckListText.becomeFirstResponder()
        }), animated: true)
    }

    func alertError(_ error: Error) {
        let message = "There was an error loading the requested deck: \(error.localizedDescription)"
        present(UIAlertController.okayAlert(title: "Error", message: message), animated: true, completion: nil)
    }

    func saveDeck() {
        guard let title = deckNameText.text, let content = deckListText.text else {
            return
        }

        if let errorMessage = DeckListService.shared.save(deck: title, contents: content) {
            return present(UIAlertController.okayAlert(title: "Error", message: errorMessage), animated: true)
        }

        DispatchQueue.main.async {
            Notification.DeckEvent.selectDeck.notify(withObject: title)
        }
    }

}
