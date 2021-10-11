//
//  AppTheme.swift
//  CardGame
//
//  Created by Eric Internicola on 10/19/18.
//  Copyright © 2018 iColasoft. All rights reserved.
//

import UIKit


class AppTheme {
    static var shared = AppTheme()

    var headerFont: UIFont { .boldSystemFont(ofSize: 30) }
    var bodyFont: UIFont { .systemFont(ofSize: 28) }
    var defaultButtonColor: UIColor { UIColor(rgb: 0x6600e5) }
    var defaultButtonTintColor: UIColor { .white }
    var defaultTextColor: UIColor { .black }

    var defaultBackgroundColor: UIColor { .white }

}

extension UIFont {

    struct Theme {
        static var headerFont: UIFont { AppTheme.shared.headerFont }
        static var bodyFont: UIFont { AppTheme.shared.bodyFont }
    }

}

extension UIColor {

    struct Theme {
        static var defaultButtonColor: UIColor { AppTheme.shared.defaultButtonColor }
        static var defaultButtonTintColor: UIColor { AppTheme.shared.defaultButtonTintColor }
        static var dialogTextColor: UIColor { AppTheme.shared.defaultTextColor }
        static var defaultDialogBackgroundColor: UIColor { AppTheme.shared.defaultBackgroundColor }
    }

}
