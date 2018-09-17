//
//  DeckReader.swift
//  CardGame
//
//  Created by Eric Internicola on 9/17/18.
//  Copyright © 2018 iColasoft. All rights reserved.
//

import Foundation

struct CardGroup {
    var name = ""
    var quantity = 1
}

struct Deck {
    var mainboard = [CardGroup]()
    var sideboard = [CardGroup]()

    var mainboardCount: Int {
        return mainboard.reduce(0, { $0 + $1.quantity })
    }

    var sideboardCount: Int {
        return sideboard.reduce(0, { $0 + $1.quantity })
    }
}

struct DeckReader {
    static let shared = DeckReader()

    func read(fileNamed: String) -> Deck? {
        guard let path = Bundle.main.path(forResource: fileNamed, ofType: nil) else {
            return nil
        }
        do {
            let content = try String(contentsOfFile: path)
            return read(fileContent: content)
        } catch {
            print("Error reading contents of file \(path): \(error.localizedDescription)")
        }
        
        return nil
    }

    /// Reads the provided file content and gives you back a deck from that file.
    ///
    /// - Parameter file: the file to read the deck from.
    /// - Returns: A Deck built by reading your file.
    func read(fileContent: String) -> Deck {
        var deck = Deck()

        let lines = fileContent.replacingOccurrences(of: "\r\n", with: "\n").split(separator: "\n")
        var sideboard = false

        for line in lines {
            guard !line.isEmpty && !line.lowercased().starts(with: "sideboard") else {
                sideboard = true
                continue
            }
            var parts = line.split(separator: " ")
            guard parts.count > 1, let quantity = Int(parts.remove(at: 0)) else {
                print("Failed to parse line: \(line)")
                continue
            }
            let name = parts.joined(separator: " ")

            if sideboard {
                deck.sideboard.append(CardGroup(name: name, quantity: quantity))
            } else {
                deck.mainboard.append(CardGroup(name: name, quantity: quantity))
            }
        }

        return deck
    }
    
}
