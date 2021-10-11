//
//  DeckReader.swift
//  CardGame
//
//  Created by Eric Internicola on 9/17/18.
//  Copyright © 2018 iColasoft. All rights reserved.
//

import Foundation

struct DeckReader {
    static let shared = DeckReader()

    /// Reads the contents of the path you provide.
    ///
    /// - Parameter path: The path to a deck file.
    /// - Returns: The Deck if it could be read, or nil if there was a problem.
    func readFile(path: URL) -> Deck? {
        do {
            let content = try String(contentsOf: path)
            return read(fileContent: content)
        } catch {
            Logger.error("reading contents of file: \(path.absoluteString)")
        }

        return nil
    }

    /// Reads the provided filename (from the main bundle) if it can be located.
    ///
    /// - Parameter fileNamed: The name of the file to load from the bundle.
    /// - Returns: A Deck object if the file exists and it could be read as a deck or nil.
    func readBundleFile(fileNamed: String) -> Deck? {
        guard let path = Bundle.main.path(forResource: fileNamed, ofType: nil) else {
            return nil
        }
        do {
            let content = try String(contentsOfFile: path)
            return read(fileContent: content)
        } catch {
            Logger.error(error)
        }
        
        return nil
    }

    /// Reads the provided file content and gives you back a deck from that file.
    ///
    /// - Parameter file: the file to read the deck from.
    /// - Returns: A Deck built by reading your file.
    func read(fileContent: String) -> Deck {
        let deck = Deck()

        let lines = fileContent.replacingOccurrences(of: "\r\n", with: "\n")
            .replacingOccurrences(of: "\n\n", with: "\n \n").split(separator: "\n")
        var sideboard = false

        for line in lines {
            Logger.debug("Line: '\(line)'")
            guard !line.replacingOccurrences(of: " ", with: "").isEmpty && !line.lowercased().starts(with: "sideboard") else {
                sideboard = true
                continue
            }
            var parts = line.split(separator: " ")
            guard parts.count > 1, let quantity = Int(parts.remove(at: 0)) else {
                Logger.error("Failed to parse line: \(line)")
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
