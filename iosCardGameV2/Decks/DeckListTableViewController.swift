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
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
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
        cell.textLabel?.text = files[indexPath.row].lastPathComponent

        return cell
    }

}

// MARK: - Actions

extension DeckListTableViewController {

    @IBAction
    func tappedAdd(_ sender: Any) {
        print("You tapped add deck")
    }

}
