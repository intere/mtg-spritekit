//
//  RemoteDeckReaderTests.swift
//  CardGameTests
//
//  Created by Eric Internicola on 11/22/18.
//  Copyright © 2018 iColasoft. All rights reserved.
//

import XCTest

class RemoteDeckReaderTests: XCTestCase {

    let url = URL(string: "https://www.mtggoldfish.com/deck/download/1475592")

    func testLoadDeck() {
        guard let url = url else {
            return XCTFail("Failed to build a valid URL")
        }

        let exp = expectation(description: "get deck")

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            defer {
                exp.fulfill()
            }
            if let error = error {
                return XCTFail("Error: \(error.localizedDescription)")
            }
            guard let response = response as? HTTPURLResponse else {
                return XCTFail("Error: wrong response object type")
            }
            guard response.statusCode == 200 else {
                return XCTFail("Error: unexpected response code: \(response.statusCode)")
            }
            guard let data = data else {
                return XCTFail("Didn't get data back")
            }
            guard let string = String(data: data, encoding: .utf8) else {
                return XCTFail("data came back as an empty UTF8 string")
            }
            guard let filename = self.getFilename(from: response.allHeaderFields) else {
                return XCTFail("Failed to get the filename from the headers")
            }
            print("Deck loaded: \(string)")
            print("Filename: \(filename)")

        }.resume()

        waitForExpectations(timeout: 5, handler: nil)
    }

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
