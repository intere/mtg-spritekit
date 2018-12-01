//
//  Debouncer.swift
//  CardGame
//
//  Created by Eric Internicola on 12/1/18.
//  Copyright © 2018 iColasoft. All rights reserved.
//

import Foundation

typealias DebounceBlock = () -> Void

class Debouncer: NSObject {
    var callback: DebounceBlock
    var delay: Double
    weak var timer: Timer?

    init(delay: Double, callback: @escaping DebounceBlock) {
        self.delay = delay
        self.callback = callback
    }

    func call() {
        timer?.invalidate()
        let nextTimer = Timer.scheduledTimer(timeInterval: delay, target: self, selector: #selector(Debouncer.fireNow), userInfo: nil, repeats: false)
        timer = nextTimer
    }

    @objc
    func fireNow() {
        self.callback()
    }
}
