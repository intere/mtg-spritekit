//
//  MathExtensions.swift
//  CardGame
//
//  Created by Eric Internicola on 9/17/18.
//  Copyright © 2018 Brian Broom. All rights reserved.
//

import Foundation
import UIKit

extension Int {

    var radians: Double {
        return Double(self) * Double.pi / 180.0
    }

}

extension Double {

    var degrees: Double {
        return self * 180.0 / Double.pi
    }

    var radians: Double {
        return self * Double.pi / 180.0
    }

    var cgFloat: CGFloat {
        return CGFloat(self)
    }
}
