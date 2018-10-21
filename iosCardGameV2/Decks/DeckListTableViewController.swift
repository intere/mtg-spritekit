//
//  DeckListTableViewController.swift
//  CardGame
//
//  Created by Eric Internicola on 10/20/18.
//  Copyright © 2018 iColasoft. All rights reserved.
//

import UIKit

class DeckListTableViewController: UITableViewController {

    var files = DeckListService.shared.deckFiles

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        files = DeckListService.shared.deckFiles
        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        Notification.DeckEvent.newDeckSaved.addObserver(self, selector: #selector(newDeckAdded(_:)))
        Notification.DeckEvent.selectDeck.addObserver(self, selector: #selector(selectDeck(_:)))
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return files.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        guard indexPath.row < files.count else {
            return cell
        }
        cell.textLabel?.text = files[indexPath.row].userFriendlyName

        return cell
    }

    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        return [
            UITableViewRowAction(style: .normal, title: "Play", handler: { [weak self] _, indexPath in
                self?.playDeck(at: indexPath.row)
            })
        ]
    }

}

// MARK: - Segues

extension DeckListTableViewController {

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard let deckPreview = segue.destination as? DeckPreviewViewController,
            let cell = sender as? UITableViewCell,
            let indexPath = tableView.indexPath(for: cell),
            indexPath.row < files.count else {
                return print("Nope")
        }

        guard let deck = deck(at: indexPath.row) else {
            return print("Failed to read deck file")
        }
        deckPreview.deck = deck
    }
}

// MARK: - Notifications

extension DeckListTableViewController {

    @objc
    func newDeckAdded(_ notification: NSNotification) {
        files = DeckListService.shared.deckFiles
        tableView.reloadData()
    }

    @objc
    func selectDeck(_ notification: NSNotification) {
        guard let name = notification.object as? String else {
            return assertionFailure("No name selected")
        }
        for idx in 0..<files.count where files[idx].userFriendlyName == name {
            tableView.selectRow(at: IndexPath(row: idx, section: 0), animated: true, scrollPosition: .middle)
            let previewVC = DeckPreviewViewController.loadFromStoryboard()
            previewVC.deck = deck(at: idx)
            showDetailViewController(previewVC, sender: self)
            break
        }
    }

}

// MARK: - Actions

extension DeckListTableViewController {

    @IBAction
    func tappedAdd(_ sender: Any) {
        print("You tapped add deck")
    }

}

// MARK: - Implementation

private extension DeckListTableViewController {

    /// This function will setup a test play of the deck at the provided index
    ///
    /// - Parameter index: the index of the deck you wish to play.
    func playDeck(at index: Int) {
        guard let deck = deck(at: index) else {
            return
        }

        Notification.DeckEvent.playDeck.notify(withObject: deck)
    }

    /// Gets you the deck at the provided index.
    ///
    /// - Parameter index: The index of the deck you want to read.
    /// - Returns: The deck object if it could be read.
    func deck(at index: Int) -> Deck? {
        guard index < files.count else {
            return nil
        }

        return DeckReader.shared.readFile(path: files[index])
    }

}

// MARK: - URL Extension

extension URL {

    /// Gets you the user friendly name of the file.
    var userFriendlyName: String {
        return (lastPathComponent as NSString).deletingPathExtension.replacingOccurrences(of: "_-_", with: " ")
    }
}
