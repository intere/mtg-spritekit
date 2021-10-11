//
//  Logger.swift
//  CardGameTests
//
//  Created by Eric Internicola on 10/11/21.
//  Copyright © 2021 iColasoft. All rights reserved.
//

import Foundation

enum Logger {

    static func debug(_ message: String, fileName: String = #file, lineNumber: Int = #line,
                      sourceFunction: String = #function) {
        log(message: message, level: "debug", fileName: fileName, lineNumber: lineNumber, sourceFunction: sourceFunction)
    }

    static func info(_ message: String, fileName: String = #file, lineNumber: Int = #line,
                     sourceFunction: String = #function) {
        log(message: message, level: "info", fileName: fileName, lineNumber: lineNumber, sourceFunction: sourceFunction)
    }

    static func warn(_ message: String, fileName: String = #file, lineNumber: Int = #line,
                     sourceFunction: String = #function) {
        log(message: message, level: "warn", fileName: fileName, lineNumber: lineNumber, sourceFunction: sourceFunction)
    }

    static func error(_ error: Error, fileName: String = #file, lineNumber: Int = #line,
                      sourceFunction: String = #function) {
        log(message: "\(error)", level: "error", fileName: fileName, lineNumber: lineNumber, sourceFunction: sourceFunction)
    }

    static func error(_ message: String, fileName: String = #file, lineNumber: Int = #line,
                      sourceFunction: String = #function) {
        log(message: message, level: "error", fileName: fileName, lineNumber: lineNumber, sourceFunction: sourceFunction)
    }

    private static func log(message: String, level: String, fileName: String, lineNumber: Int, sourceFunction: String) {
        let now = Date(timeIntervalSinceNow: 0)
        let timestamp = Date.LogConstants.dateFormatter.string(from: now)
        DispatchQueue.main.async {
            let file = URL(fileURLWithPath: fileName)
            print("[\(timestamp)][\(level)][\(file.lastPathComponent):\(lineNumber)]: \(message)")
        }
    }
}

private extension Date {
    enum LogConstants {
        static let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            return formatter
        }()
    }
}
