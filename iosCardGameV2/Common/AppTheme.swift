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

    var headerFont: UIFont {
        return UIFont.boldSystemFont(ofSize: 30)
    }

    var bodyFont: UIFont {
        return UIFont.systemFont(ofSize: 28)
    }

    var defaultButtonColor: UIColor {
        return UIColor(rgb: 0x6600e5)
    }

    var defaultButtonTintColor: UIColor {
        return .white
    }

    var defaultTextColor: UIColor {
        return .black
    }

    var defaultBackgroundColor: UIColor {
        return .white
    }

}

extension UIFont {

    struct Theme {
        static var headerFont: UIFont {
            return AppTheme.shared.headerFont
        }

        static var bodyFont: UIFont {
            return AppTheme.shared.bodyFont
        }
    }

}

extension UIColor {

    struct Theme {
        static var defaultButtonColor: UIColor {
            return AppTheme.shared.defaultButtonColor
        }

        static var defaultButtonTintColor: UIColor {
            return AppTheme.shared.defaultButtonTintColor
        }

        static var dialogTextColor: UIColor {
            return AppTheme.shared.defaultTextColor
        }

        static var defaultDialogBackgroundColor: UIColor {
            return AppTheme.shared.defaultBackgroundColor
        }
    }

}
