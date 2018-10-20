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
        let fileManager = FileManager.default

        guard let docsDir = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Couldn't find the documents directory")
            return []
        }


        do {
            return try fileManager.contentsOfDirectory(at: docsDir, includingPropertiesForKeys: nil, options: .skipsHiddenFiles).filter {
                $0.absoluteString.lowercased().hasSuffix(".deck")
            }
        }
        catch let error as NSError {
            print("Ooops! Something went wrong: \(error)")
            return []
        }
    }
}
