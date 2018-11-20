//
//  TurnPhase.swift
//  CardGameV2
//
//  Created by Eric Internicola on 9/29/18.
//  Copyright © 2018 iColasoft. All rights reserved.
//

import Foundation
import GameplayKit
import MTGSDKSwift

class TurnPhase: GKState {
    var triggers = [Trigger]()
}

class UntapPhase: TurnPhase {

    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass == UpkeepPhase.self
    }

}

class UpkeepPhase: TurnPhase {

    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass == DrawPhase.self
    }

}

class DrawPhase: TurnPhase {

    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass == PreCombatMain.self
    }

}

class PreCombatMain: TurnPhase {

    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass == DeclareAttackersStep.self
    }

}

/// The combat phase, which is broken down into sub phases
class CombatPhase: TurnPhase {

}

class DeclareAttackersStep: CombatPhase {

    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass == AttackPlayInstantsAndAbilitiesStep.self
    }
}

class AttackPlayInstantsAndAbilitiesStep: CombatPhase {

    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass == DeclareBlockersStep.self
    }
}

class DeclareBlockersStep: CombatPhase {

    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass == BlockPlayInstantsAndAbilitiesStep.self
    }
}

class BlockPlayInstantsAndAbilitiesStep: CombatPhase {

    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass == CombatDamageStep.self
    }
}

class CombatDamageStep: CombatPhase {

    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass == PostCombatMain.self
    }
}

class PostCombatMain: TurnPhase {

    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass == EndStep.self
    }
}

class EndStep: TurnPhase {


}
