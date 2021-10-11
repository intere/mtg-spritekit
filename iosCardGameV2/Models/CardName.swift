//
//  CardName.swift
//  CardGameTests
//
//  Created by Eric Internicola on 10/10/21.
//  Copyright © 2021 iColasoft. All rights reserved.
//

import Foundation

struct CardName {
    let name: String
    let setCode: String?
    let number: Int?

    static func fromCardName(string: String) -> CardName {
        let parts = string.split(separator: " ")
        var name = [Substring]()
        var setCode: String?
        var number: Int?

        parts.forEach { part in
            guard setCode == nil || number == nil else { return }

            if part.isSetCode {
                setCode = part.removeParens
                return
            }
            if let intValue = Int(part) {
                number = intValue
                return
            }
            name.append(part)
        }

        return CardName(name: name.map({ String($0) }).joined(separator: " "),
                        setCode: setCode, number: number)
    }
}

private extension Substring {

    var removeParens: String {
        let string = String(self)
        let start = string.index(after: string.startIndex)
        let end = string.index(before: string.endIndex)
        return String(string[start..<end])
    }

    var isSetCode: Bool {
        let string = String(self)
        guard string.hasPrefix("("), string.hasSuffix(")") else { return false }
        return [5, 6].contains(string.count)
    }
}
