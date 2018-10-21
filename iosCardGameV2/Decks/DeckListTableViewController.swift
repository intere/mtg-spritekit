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
        let text = (files[indexPath.row].lastPathComponent as NSString).deletingPathExtension
        cell.textLabel?.text = text.replacingOccurrences(of: "_-_", with: " ")

        return cell
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

        guard let deck = DeckReader.shared.readFile(path: files[indexPath.row]) else {
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

}

// MARK: - Actions

extension DeckListTableViewController {

    @IBAction
    func tappedAdd(_ sender: Any) {
        print("You tapped add deck")
    }

}
