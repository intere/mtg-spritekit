//
//  DeckChooserTableViewController.swift
//  CardGame
//
//  Created by Eric Internicola on 11/22/18.
//  Copyright © 2018 iColasoft. All rights reserved.
//

import UIKit

class DeckChooserTableViewController: UITableViewController {

    var decks = DeckListService.shared.deckFiles

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return decks.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        guard indexPath.row < decks.count else {
            return cell
        }
        cell.textLabel?.text = decks[indexPath.row].userFriendlyName

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let deck = decks[indexPath.row]
        print("Selected file: \(deck.absoluteString)")
    }

    class func loadFromStoryboard() -> DeckChooserTableViewController {
        return UIStoryboard(name: "DeckChooser", bundle: nil)
            .instantiateViewController(withIdentifier: "DeckChooserTableViewController") as! DeckChooserTableViewController
    }

}
