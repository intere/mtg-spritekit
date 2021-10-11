//
//  RemoteDeckService.swift
//  CardGame
//
//  Created by Eric Internicola on 11/22/18.
//  Copyright © 2018 iColasoft. All rights reserved.
//

import Foundation


typealias DeckLoadedCallback = (_ title: String?, _ content: String?, Error?) -> Void

class RemoteDeckService {
    static let shared = RemoteDeckService()

    /// Fetches you a deck from the provided URL.
    ///
    /// - Parameters:
    ///   - url: The URL to get the deck from.
    ///   - completion: The completion handler.
    func fetchDeck(from url: URL, completion: @escaping DeckLoadedCallback) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return completion(nil, nil, error)
            }
            guard let response = response as? HTTPURLResponse else {
                return completion(nil, nil, RemoteDeckError.invalidResponseType)
            }
            guard response.statusCode == 200 else {
                return completion(nil, nil, RemoteDeckError.invalidStatusCode(response.statusCode))
            }
            guard let data = data else {
                return completion(nil, nil, RemoteDeckError.noData)
            }
            let filename = self.getFilename(from: response.allHeaderFields)
            let content = String(data: data, encoding: .utf8)
            completion(filename, content, nil)

        }.resume()
    }

}

// MARK: - Implementation

private extension RemoteDeckService {

    func getFilename(from headers: [AnyHashable: Any]) -> String? {
        // Content-Disposition: attachment; filename="Deck - Jund.txt"
        guard let header = headers["Content-Disposition"] as? String else {
            return nil
        }
        let split = header.split(separator: "\"")
        guard split.count > 1 else {
            return nil
        }

        let filename = split[1].replacingOccurrences(of: "Deck - ", with: "")
        return filename.replacingOccurrences(of: ".txt", with: "")
    }

}

// MARK: - RemoteDeckError

enum RemoteDeckError: LocalizedError {

    case invalidResponseType
    case invalidStatusCode(Int)
    case noData

    var errorDescription: String? {
        switch self {
        case .invalidResponseType:
            return "Wrong response object type"

        case .invalidStatusCode(let code):
            return "Unexpected response code: \(code)"

        case .noData:
            return "No data came back from the server."
        }
    }
}
