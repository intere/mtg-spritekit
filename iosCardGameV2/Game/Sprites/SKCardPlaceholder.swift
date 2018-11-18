//
//  SKCardPlaceholder.swift
//  CardGame
//
//  Created by Eric Internicola on 11/18/18.
//  Copyright © 2018 iColasoft. All rights reserved.
//

import SpriteKit

class SKCardPlaceholder: SKSpriteNode {

    init() {
        super.init(texture: Constants.texture, color: .clear, size: Constants.defaultSize)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Constants

extension SKCardPlaceholder {

    struct Constants {
        static let defaultSize = CGSize(width: 106, height: 146)
        static let texture = SKTexture(imageNamed: "placeholder")
    }

}
