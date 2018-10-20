//
//  AlertViewController.swift
//  CardGame
//
//  Created by Eric Internicola on 10/19/18.
//  Copyright © 2018 iColasoft. All rights reserved.
//

import Cartography
import UIKit

class AlertViewController: UIViewController {

    var contentView = UIView()
    var titleLabel = UILabel()
    var messageLabel = UILabel()
    var buttons = [UIButton]()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(contentView)

        contentView.backgroundColor = UIColor.Theme.defaultDialogBackgroundColor
        titleLabel.font = UIFont.Theme.headerFont
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0

        messageLabel.font = UIFont.Theme.bodyFont
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0

        contentView.addSubview(titleLabel)
        contentView.addSubview(messageLabel)
        buttons.forEach { contentView.addSubview($0) }

        for button in buttons {
            button.setTitleColor(UIColor.Theme.defaultButtonColor, for: .normal)
            button.tintColor = UIColor.Theme.defaultButtonTintColor
            button.layer.cornerRadius = 20
        }

        constrain(view, contentView, titleLabel, messageLabel) { view, contentView, titleLabel, messageLabel in

        }

    }



}
