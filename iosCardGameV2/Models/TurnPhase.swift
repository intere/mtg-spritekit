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

}

class UpkeepPhase: TurnPhase {

}

class DrawPhase: TurnPhase {

}

class FirstMainPhase: TurnPhase {

}

/// The combat phase, which is broken down into sub phases
class CombatPhase: TurnPhase {

}

class DeclareAttackersStep: CombatPhase {

}

class AttackPlayInstantsAndAbilitiesStep: CombatPhase {

}

class DeclareBlockersStep: CombatPhase {

}

class BlockPlayInstantsAndAbilitiesStep: CombatPhase {

}

class CombatDamageStep: CombatPhase {

}

class SecondMainPhase: TurnPhase {

}

class EndStep: TurnPhase {

}
