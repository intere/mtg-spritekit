//
//  UIDeviceExtension.swift
//  CardGame
//
//  Created by Eric Internicola on 10/22/18.
//  Copyright © 2018 iColasoft. All rights reserved.
//

import UIKit

extension UIDevice {

    var isPad: Bool {
        return userInterfaceIdiom == .pad
    }

    var isPhone: Bool {
        return userInterfaceIdiom == .phone
    }

    var isTV: Bool {
        return userInterfaceIdiom == .tv
    }

}
