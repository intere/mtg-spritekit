//
//  CombineMagicCardService.swift
//  CardGame
//
//  Created by Eric Internicola on 10/9/21.
//  Copyright © 2021 iColasoft. All rights reserved.
//

import Combine
import Foundation
import UIKit

typealias CardSearchCompletion = (Result<CardSearchResults, Error>) -> Void
typealias DeckLoadingCompletion = (Result<[CardSearchResults.Card], Error>) -> Void
typealias CardImageCompletion = (Result<UIImage, Error>) -> Void

protocol MagicCardSearch {
    func search(for name: String, maxResults: Int, page: Int, completion: @escaping CardSearchCompletion)
    func loadImage(urlString: String, completion: @escaping CardImageCompletion)
}

extension MagicCardSearch {
    func search(for name: String, completion: @escaping CardSearchCompletion) {
        search(for: name, maxResults: 20, page: 1, completion: completion)
    }
}

class CombineMagicCardSearch: MagicCardSearch {
    private var cancellables = Set<AnyCancellable>()

    func loadImage(urlString: String, completion: @escaping CardImageCompletion) {
        guard let url = URL(string: urlString) else { return completion(.failure(MagicCardSearchError.createUrlError(urlString: urlString))) }

        URLSession.shared.dataTaskPublisher(for: url)
            .map { result -> UIImage? in
                return UIImage(data: result.data)
            }
            .eraseToAnyPublisher()
            .replaceError(with: nil)
            .sink { result in
                if let result = result {
                    completion(.success(result))
                } else {
                    completion(.failure(MagicCardSearchError.invalidImageDataError))
                }
            }
            .store(in: &cancellables)
    }

    func search(for name: String, maxResults: Int, page: Int, completion: @escaping CardSearchCompletion) {
        guard let url = searchUrl(for: name, maxResults: maxResults, page: page) else {
            return completion(.failure(MagicCardSearchError.createUrlError(urlString: "card search - \(name)")))
        }

        print("Searching for \(name): \(url.absoluteString)")

        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: CardSearchResults.self, decoder: JSONDecoder())
            .catch({ (error) -> Just<CardSearchResults> in
                print("Error getting card '\(name)': \(error)")
                return Just(CardSearchResults(cards: .none))
            })
//            .replaceError(with: CardSearchResults(cards: nil))
//            .eraseToAnyPublisher()
            .sink(receiveCompletion: { completion in
                print("Sink completion: \(completion)")
            }, receiveValue: { result in
                if result.cards == nil {
                    print("\(name) has nil cards")
                    completion(.failure(MagicCardSearchError.cardSearchError))
                } else {
                    completion(.success(result))
                }
            }).store(in: &cancellables)
    }

}

// MARK: - Errors

enum MagicCardSearchError: LocalizedError {
    case implemntMeError
    case createUrlError(urlString: String)
    case invalidImageDataError
    case cardSearchError

    var errorDescription: String? {
        switch self {
        case .implemntMeError:
            return "Not yet implemented..."
        case .createUrlError(let urlString):
            return "Unable to create a URL from the string: '\(urlString)'"
        case .invalidImageDataError:
            return "Invalid image data"
        case .cardSearchError:
            return "Card Search error"
        }
    }
}

// MARK: - Helpers

private extension CombineMagicCardSearch {

    func searchUrl(for name: String, maxResults: Int, page: Int) -> URL? {
        let cardName: CardName = .fromCardName(string: name)
        var components = URLComponents(string: "https://api.magicthegathering.io/v1/cards")
        components?.queryItems = [
            URLQueryItem(name: "page", value: String(page)),
            URLQueryItem(name: "pageSize", value: String(maxResults)),
            URLQueryItem(name: "contains", value: "imageUrl")
        ] + cardName.queryParams

        return components?.url
    }
}

extension CardName {
    var queryParams: [URLQueryItem] {
        var result = [URLQueryItem(name: "name", value: name)]
        if let setCode = setCode {
            result.append(URLQueryItem(name: "set", value: setCode))
        }
        // TODO: What about the number?
        return result
    }
}

// MARK: - CardSearchResults

struct CardSearchResults: Codable {
    let cards: [Card]?

    // MARK: - Card
    struct Card: Codable {
        let names: [String]?
        let name, manaCost: String?
        let cmc: Int?
        let colors, colorIdentity: [String]?
        let type: String?
        let types: [String]?
        let rarity, cardSet, setName, text: String?
        let flavor, artist, number, layout: String?
        let multiverseid: String?
        let imageURL: String?
        let rulings: [Ruling]?
        let foreignNames: [ForeignName]?
        let printings: [String]?
        let originalText, originalType: String?
        let legalities: [[String: String]]?
        let id, watermark: String?
        let variations: [String]?
        let power: String?
        let supertypes: [String]?
        let subtypes: [String]?
        let loyalty: String?
        let toughness: String?

        enum CodingKeys: String, CodingKey {
            case names, name, manaCost, cmc, colors, colorIdentity, type, types, rarity
            case cardSet = "set"
            case setName, text, flavor, artist, number, layout, multiverseid
            case imageURL = "imageUrl"
            case rulings, foreignNames, printings, originalText, originalType, legalities, id, watermark, variations, power, supertypes, subtypes, loyalty, toughness
        }

        // MARK: - ForeignName
        struct ForeignName: Codable {
            let name, text, type, flavor: String?
            let imageURL: String?
            let language: String?
            let multiverseid: Int?

            enum CodingKeys: String, CodingKey {
                case name, text, type, flavor
                case imageURL = "imageUrl"
                case language, multiverseid
            }
        }

        // MARK: - Ruling
        struct Ruling: Codable {
            let date, text: String?
        }
    }
}
