//
//  CardManager.swift
//  CardGame
//
//  Created by Eric Internicola on 9/17/18.
//  Copyright © 2018 Brian Broom. All rights reserved.
//

import Foundation
import MTGSDKSwift

struct CardManager {

    static let shared = CardManager()
    let magic = Magic()

    /// Loads an image for you.
    ///
    /// - Parameters:
    ///   - urlString: the image you want to load.
    ///   - completion: the completion handler.
    func loadImage(urlString: String, completion: @escaping Magic.CardImageCompletion) {
        var card = MTGSDKSwift.Card()
        card.imageUrl = urlString

        magic.fetchImageForCard(card, completion: completion)
    }

}
