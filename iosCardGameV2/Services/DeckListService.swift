//
//  DeckListService.swift
//  CardGame
//
//  Created by Eric Internicola on 10/20/18.
//  Copyright © 2018 iColasoft. All rights reserved.
//

import Foundation

class DeckListService {
    static let shared = DeckListService()

    /// Gets you a list of all of the deck files.
    var deckFiles: [URL] {
        guard let docsDir = docsDirectory else {
            print("Couldn't find the documents directory")
            return []
        }

        do {
            return try fileManager.contentsOfDirectory(at: docsDir, includingPropertiesForKeys: nil, options: .skipsHiddenFiles).filter {
                $0.absoluteString.lowercased().hasSuffix(Constants.deckSuffix)
            }
        }
        catch let error as NSError {
            print("Oops! Something went wrong: \(error)")
            return []
        }
    }

    /// Saves the provided contents to the provided file.
    ///
    /// - Parameters:
    ///   - named: The name of the file (without the deck extension)
    ///   - contents: The contents of the file.
    /// - Returns: A String if there is an error message, nil if success.
    func save(deck named: String, contents: String) -> String? {
        guard let docsDirectory = docsDirectory else {
            return "No docs directory to write to"
        }
        let fixedFileName = named.replacingOccurrences(of: " ", with: "_-_")
        guard let deckFile = URL(string: "\(fixedFileName)\(Constants.deckSuffix)", relativeTo: docsDirectory) else {
            return "Failed to create deck file URL"
        }
        do {
            try contents.write(to: deckFile, atomically: true, encoding: .utf8)
            Notification.DeckEvent.newDeckSaved.notify()
            return nil
        } catch {
            return "ERROR creating deck file:\(error.localizedDescription)"
        }
    }

}

// MARK: - Implementation

private extension DeckListService {

    var fileManager: FileManager {
        return FileManager.default
    }

    var docsDirectory: URL? {
        return fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
    }

    struct Constants {
        static let deckSuffix = ".deck"
    }
}
